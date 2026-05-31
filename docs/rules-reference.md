# Rules Reference

Documentation of each rule and helper: purpose, condition, action, and
knowledge source. The scoring rules are **generic** — they never name a specific
major or attribute, only operate on the `requirement`, `attr`, and `rank` facts
(spec §12). Knowledge lives in `requirements.clp`; logic lives here.

Salience layering controls the inference phases:

| Salience | Rules | Phase |
|---------:|-------|-------|
| 0 | `score-full-match`, `score-partial-match` | award points |
| -10 | `compute-percent` | normalise to percentage |
| -100 | `print-report` | print the ranked report |

Because CLIPS fires all higher-salience activations before any lower one, every
requirement is scored before any percentage is computed, and every percentage is
computed before the report prints.

---

## Scoring Rules

### `score-full-match` (salience 0)
- **Purpose:** award the full weight when the student meets or exceeds a
  requirement, and record the human-readable justification.
- **Condition:** a `requirement (major ?m) (attribute ?a) (level ?rl) (weight ?w)
  (reason ?r)`; the student's `attr` for the same attribute `?a`; both values
  mapped through `rank` to `?srank` and `?rrank`; `(test (>= ?srank ?rrank))`;
  `(not (scored ?s ?m ?a))`; and the major's `recommendation`.
- **Action:** `modify` the recommendation to add `?w` to `raw` and append `?r` to
  `reasons`; assert `(scored ?s ?m ?a)`.
- **Knowledge source:** spec §4.2 — "if `srank >= rrank` → award the full weight
  and add the justification."

```clips
(defrule score-full-match
   (requirement (major ?m) (attribute ?a) (level ?rl) (weight ?w) (reason ?r))
   (attr (student ?s) (name ?a) (value ?sv))
   (rank ?sv ?srank)
   (rank ?rl ?rrank)
   (test (>= ?srank ?rrank))
   (not (scored ?s ?m ?a))
   ?rec <- (recommendation (major ?m) (raw ?raw) (reasons $?rs))
   =>
   (modify ?rec (raw (+ ?raw ?w)) (reasons (create$ ?rs ?r)))
   (assert (scored ?s ?m ?a)))
```

### `score-partial-match` (salience 0)
- **Purpose:** give partial credit for a near miss (exactly one ordinal level
  below the requirement), **without** citing it as a reason.
- **Condition:** as above but `(test (= ?srank (- ?rrank 1)))`; the `reason` is
  not bound and `reasons` is not touched.
- **Action:** `modify` the recommendation to add `(/ ?w 2)` to `raw`; assert
  `(scored ?s ?m ?a)`.
- **Knowledge source:** spec §4.2 — "if `srank = rrank - 1` → award half the
  weight (partial match) without adding a justification." (A gap of two or more
  levels matches no rule, i.e. awards zero, per the third clause.)

```clips
(defrule score-partial-match
   (requirement (major ?m) (attribute ?a) (level ?rl) (weight ?w))
   (attr (student ?s) (name ?a) (value ?sv))
   (rank ?sv ?srank)
   (rank ?rl ?rrank)
   (test (= ?srank (- ?rrank 1)))
   (not (scored ?s ?m ?a))
   ?rec <- (recommendation (major ?m) (raw ?raw))
   =>
   (modify ?rec (raw (+ ?raw (/ ?w 2))))
   (assert (scored ?s ?m ?a)))
```

### `compute-percent` (salience -10)
- **Purpose:** turn the accumulated `raw` into the final `percent`.
- **Condition:** a `recommendation (major ?m) (raw ?raw) (max ?mx)` with
  `(test (> ?mx 0))` and `(not (percent-done ?m))`.
- **Action:** `modify` the recommendation, setting `percent` to
  `(round (/ (* ?raw 100.0) ?mx))`; assert `(percent-done ?m)`.
- **Knowledge source:** spec §4.3 — `percent = round(raw / max * 100)`, computed
  after scoring stabilises (guaranteed by the lower salience).

```clips
(defrule compute-percent
   (declare (salience -10))
   ?rec <- (recommendation (major ?m) (raw ?raw) (max ?mx))
   (test (> ?mx 0))
   (not (percent-done ?m))
   =>
   (modify ?rec (percent (round (/ (* ?raw 100.0) ?mx))))
   (assert (percent-done ?m)))
```

---

## No-Double-Counting Strategy

**The problem.** The natural scoring rule modifies the major's `recommendation`
fact. In CLIPS a `modify` is a *retract + assert*: it produces a **new** fact
with a new index. The scoring rule's other patterns — the `requirement`, the
`attr`, and the two `rank` facts — are all still present and still match, so they
re-join with the *new* recommendation to form a **new rule instantiation**. Rete
refraction only suppresses re-firing on an *identical* instantiation, so the rule
would fire again on the same requirement, adding the weight a second, third, …
time — an infinite loop that also corrupts every score.

**The solution: a `scored` control marker.** After a requirement is scored we
assert an ordered control fact

```clips
(scored <student> <major> <attribute>)
```

and every scoring rule includes the negated pattern

```clips
(not (scored ?s ?m ?a))
```

The triple *(student, major, attribute)* uniquely identifies a requirement,
because a major never lists the same attribute twice. Once the marker exists, the
`(not (scored …))` condition is false, so neither `score-full-match` nor
`score-partial-match` can fire for that requirement again. This guarantees the
spec's rule that *"each requirement is counted only once per student per major"*
(§4.4). It also makes full and partial mutually exclusive: although their
`test`s are already disjoint, whichever matches first sets the marker and blocks
the other.

**Why a marker rather than `logical`?** The spec offers `logical` support or a
marker fact as alternatives. The marker is explicit, easy to inspect at the CLIPS
prompt (`(facts)` shows exactly which requirements were scored), and keeps the
recommendation fact free of truth-maintenance dependencies, so later phases can
`modify` it (for `percent`) without retraction surprises.

The same one-shot pattern protects the two follow-up rules:
`compute-percent` uses `(not (percent-done ?m))` and `print-report` uses
`(not (reported))`, each asserting its marker in the RHS so it runs exactly once.

**Single-student assumption.** A `recommendation` has no student slot, so scoring
is for one student per run (batch mode loads one profile; the test runner
`(reset)`s between profiles). The `scored` marker still carries the student id so
the guard is correct and the design extends cleanly if recommendations were ever
made per-student.

---

## Ranking & Output Rules

### `rec-worse` (deffunction)
- **Purpose:** ordering predicate for `sort`. CLIPS places `?a` after `?b` when
  the predicate returns TRUE, so returning TRUE for the *worse* recommendation
  produces a best-first order.
- **Logic:** TRUE if `?a`'s `percent` is lower; FALSE if higher; on a tie, TRUE
  if `?a`'s `raw` is lower.
- **Knowledge source:** spec §5 — rank by percentage descending; "if two majors
  tie on percentage, favor the one with the higher `raw`."

```clips
(deffunction rec-worse (?a ?b)
   (bind ?pa (fact-slot-value ?a percent))
   (bind ?pb (fact-slot-value ?b percent))
   (if (< ?pa ?pb) then (return TRUE))
   (if (> ?pa ?pb) then (return FALSE))
   (< (fact-slot-value ?a raw) (fact-slot-value ?b raw)))
```

### `print-recommendations` (deffunction)
- **Purpose:** print the top `?n` recommendations.
- **Logic:** `sort` all `recommendation` facts with `rec-worse`; for the first
  `?n`, look up the major's `name` and `faculty` from its `major` fact and print
  the match percentage, the match score (`raw / max`), and each justification in
  `reasons`. Majors with no matching factors print a clear "no matching factors"
  note.
- **Knowledge source:** spec §5 output format (name, faculty, match percentage,
  list of justifications); top 5.

### `print-report` (salience -100)
- **Purpose:** emit the report once, after all scoring and percentage rules.
- **Condition:** `(not (reported))`.
- **Action:** assert `(reported)`; call `(print-recommendations 5)`.
- **Knowledge source:** spec §5 — print the top 5 after scoring stabilises.

```clips
(defrule print-report
   (declare (salience -100))
   (not (reported))
   =>
   (assert (reported))
   (print-recommendations 5))
```

---

## Consultation Module

The consultation front-end (`src/consultation.clp`) is built from **deffunctions,
not defrules** — a deliberate design choice. Validated input is a re-prompt loop,
which a deffunction expresses naturally (a defrule fires once and cannot easily
re-ask), and using no rules guarantees the front-end shares nothing with, and
cannot perturb, the scoring engine's Rete agenda (spec §6: keep consultation
separate from the engine). Both modes only assert `attr` facts and call `(run)`.

| Function | Purpose |
|----------|---------|
| `academic-attrs`, `interest-attrs`, `skill-attrs` | the attributes asked, in spec order (academics → interests → skills) |
| `academic-values`, `rating-values` | the allowed value sets per scale |
| `ask-attr (?student ?attr ?allowed)` | prompt for one attribute; lower-cases the answer; **re-prompts on any invalid value**; `quit`/EOF abort safely; on success asserts `(attr (student ?student) (name ?attr) (value ?in))` |
| `ask-group (?student ?attrs ?allowed ?title)` | ask every attribute in a group; propagates an abort |
| `consult` | INTERACTIVE mode: `(reset)`, ask all three groups for student `you`, then `(run)` |
| `consult-file (?path)` | BATCH mode: load a profile file by path, `(reset)`, `(run)` |

- **Knowledge source:** spec §6 (interactive ordering, validation against allowed
  values, batch loading of ready-made profiles).
- **Input validation:** an answer must be a member of the group's allowed-value
  multifield (after lower-casing); anything else triggers a message and a repeat
  of the same question.

---

## Logical Unit Tests

These are small fact sets that isolate **one** rule and check it fires
and produces the correct effect (spec §9.4). Each can be pasted at a CLIPS prompt
after loading the system.

**UT-1 — `score-full-match` awards full weight and records the reason.**
A student who meets `medicine`'s `biology = excellent` (weight 3) requirement
exactly should gain 3 raw points and the matching justification.

```clips
(reset)
(assert (attr (student ut) (name biology) (value excellent)))
(run)
; expect: medicine recommendation has raw >= 3 and reasons contains
; "Medicine is grounded in an excellent command of biology and the human body."
(do-for-fact ((?r recommendation)) (eq ?r:major medicine)
   (printout t "raw=" ?r:raw " reasons=" ?r:reasons crlf))
```

**UT-2 — `score-partial-match` awards half weight and NO reason.**
A student one level below a requirement (e.g. `nursing` needs `social = high`;
give `social = medium`) should gain half of that weight and add no justification.

```clips
(reset)
(assert (attr (student ut) (name social) (value medium)))   ; nursing social=high w3
(run)
; expect: nursing raw = 1.5 (half of 3) and reasons does NOT contain the social reason
```

**UT-3 — no double counting.**
With the single fact from UT-1, after `(run)` there must be exactly one
`(scored ut medicine biology)` fact and `medicine`'s raw must be exactly 3, never
6 or more — proving the `(not (scored ...))` guard prevents re-firing.

```clips
(reset)
(assert (attr (student ut) (name biology) (value excellent)))
(run)
(facts)   ; verify a single (scored ut medicine biology); medicine raw = 3
```

**Actual results** (run against the current system):

```
UT-1  medicine raw=3   reasons contains the biology justification   -> PASS
UT-2  nursing  raw=1.5  reasons count=0 (no justification for a near miss) -> PASS
UT-3  medicine raw=3   exactly one (scored ut medicine biology)     -> PASS
```

UT-3 also produces seven `(scored ut <major> biology)` facts in total — one for
each major that has a `biology` requirement (medicine, pharmacy, nursing,
med-lab, chem-sci, bio-sci, psychology) — confirming each requirement is scored
once per major and never twice.

These double as regression checks when editing the scoring rules.
