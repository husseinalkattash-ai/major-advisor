# Evaluation Report

This report evaluates the major-recommendation expert system against the
expert-defined gold standard, using the metrics required by spec §9.3: **Top-1
accuracy**, **Top-3 hit rate**, and a **faculty-level confusion matrix**. It
also records the error analysis and the tuning decision.

> **Headline result:** Top-1 = **75%** (target ≥ 70% ✅), Top-3 = **95%**
> (target ≥ 90% ✅), Acceptable@3 = **100%**. Both targets are met, so the
> "iterate if below target" condition was not triggered; see §6 for the analysis
> behind that decision.

---

## 1. Methodology

The project follows the test-driven approach mandated by the spec: the
expert-expected outputs (`tests/expected-results.csv`) and the 20 diverse student
profiles (`tests/profiles/`) were authored **first** (Task 1), before the scoring
rules, so the rules are measured against a fixed, independent gold standard
rather than tuned to flatter themselves.

**Test runner (`tests/run-tests.clp`, pure CLIPS).** For each profile the runner:

1. `load*`s the profile's `deffacts` (silent load).
2. `(reset)` — re-asserts the knowledge base (majors, requirements, the
   `init-recommendations`, the rank scale) *plus* this one profile's `attr`
   facts. Because a `recommendation` has no student slot, exactly one student may
   be in working memory at a time.
3. `(run)` — the scoring and percentage rules fire.
4. Ranks the `recommendation` facts with the same `rec-worse`/`sort` helpers the
   live engine uses (percent descending, tie-break on raw), and captures the
   top-1 and top-3 major ids.
5. `(undeffacts profile-<id>)` — removes the profile so it cannot leak into the
   next test. This guarantees clean isolation between profiles.

The interactive auto-report rule (`print-report`) is `undefrule`d in the runner
so batch output stays compact; the ranking logic itself is unchanged.

The runner reads `expected-results.csv` directly. The first three columns
(`profile_id`, `expected_top1`, `acceptable_top3`) never contain commas, so the
line is split on `,` and only fields 1–3 are used — robust even though the 4th
column (`notes`) is quoted and may contain commas.

**Metric definitions.**

- **Top-1 accuracy** — fraction of profiles whose system top-1 equals the
  expert `expected_top1`.
- **Top-3 hit rate** — fraction whose `expected_top1` appears anywhere in the
  system's top-3 (the spec's "Top-3 Hit Rate").
- **Acceptable@3** — fraction where *any* major from the expert
  `acceptable_top3` set appears in the system top-3. This is the most
  domain-meaningful measure, since the expert deliberately listed several
  reasonable majors per profile.
- **Faculty-level confusion matrix** — counts of expected vs. predicted top-1
  by the six faculty groups of spec §8 (Engineering, Medicine & Health, Science,
  Business, Arts & Humanities, Other).

---

## 2. The Gold-Standard Set

20 archetypal profiles spanning all six faculty groups, each specifying all 20
attributes (8 academic, 6 RIASEC interests, 6 skills). For each, the expert
recorded the single best major and a 2–3 major acceptable set drawn from
adjacent fields. Full data: [`tests/expected-results.csv`](../tests/expected-results.csv)
and [`tests/profiles/`](../tests/profiles). The construction rationale is in
[`knowledge-acquisition.md`](knowledge-acquisition.md) §5.

---

## 3. Results

### 3.1 Per-profile outcomes

```
PID   EXPECTED_TOP1   SYSTEM_TOP1     T1 T3 A3  SYSTEM_TOP3
----------------------------------------------------------------------
p01   comp-eng        mech-eng         .  Y  Y  mech-eng civil-eng comp-eng
p02   cs              comp-eng         .  Y  Y  comp-eng cs math-sci
p03   medicine        medicine         Y  Y  Y  medicine chem-sci nursing
p04   civil-eng       mech-eng         .  Y  Y  mech-eng civil-eng comp-eng
p05   elec-eng        mech-eng         .  .  Y  mech-eng civil-eng comp-eng
p06   mech-eng        mech-eng         Y  Y  Y  mech-eng elec-eng physics-sci
p07   pharmacy        pharmacy         Y  Y  Y  pharmacy chem-sci accounting
p08   nursing         nursing          Y  Y  Y  nursing sociology education
p09   med-lab         med-lab          Y  Y  Y  med-lab pharmacy accounting
p10   math-sci        math-sci         Y  Y  Y  math-sci comp-eng cs
p11   physics-sci     physics-sci      Y  Y  Y  physics-sci math-sci comp-eng
p12   bio-sci         bio-sci          Y  Y  Y  bio-sci med-lab medicine
p13   accounting      accounting       Y  Y  Y  accounting mis economics
p14   marketing       marketing        Y  Y  Y  marketing media management
p15   economics       economics        Y  Y  Y  economics history mis
p16   psychology      psychology       Y  Y  Y  psychology sociology education
p17   english-lang    sociology        .  Y  Y  sociology english-lang education
p18   law             law              Y  Y  Y  law management sociology
p19   architecture    architecture     Y  Y  Y  architecture graphic-design mis
p20   graphic-design  graphic-design   Y  Y  Y  graphic-design architecture media
```

### 3.2 Aggregate metrics

| Metric | Result | Target | Status |
|--------|:------:|:------:|:------:|
| Top-1 accuracy | **15/20 = 75%** | ≥ 70% | ✅ |
| Top-3 hit rate | **19/20 = 95%** | ≥ 90% | ✅ |
| Acceptable@3 | **20/20 = 100%** | — | ✅ |

### 3.3 Faculty-level confusion matrix

Rows = expected faculty, columns = predicted faculty (system top-1).

```
exp\pred  Eng  Med  Sci  Bus  Art  Oth
Eng         4    0    0    0    0    0
Med         0    4    0    0    0    0
Sci         1    0    3    0    0    0
Bus         0    0    0    3    0    0
Art         0    0    0    0    2    0
Oth         0    0    0    0    0    3
```

The matrix is almost perfectly diagonal. **Faculty-level Top-1 accuracy =
19/20 = 95%** (diagonal sum 4+4+3+3+2+3). The single off-diagonal cell is
**Science → Engineering** (one profile), discussed below.

---

## 4. Error Analysis

Five of twenty profiles miss at the *major* level. Crucially, **all five land
inside the expert acceptable set** (Acceptable@3 = 100%), and **four of the five
stay within the correct faculty**.

| Profile | Expected | System top-1 | Faculty-level |
|---------|----------|--------------|---------------|
| p01 | comp-eng | mech-eng | within Engineering |
| p04 | civil-eng | mech-eng | within Engineering |
| p05 | elec-eng | mech-eng | within Engineering |
| p02 | cs | comp-eng | **Science → Engineering** (cross) |
| p17 | english-lang | sociology | within Arts & Humanities |

**Single root cause — saturation + the raw tie-break.** For a student who is
strong across many attributes, several specialised majors all reach 100%
(`raw = max`). The spec's mandated tie-break — "if two majors tie on percentage,
favour the one with the higher `raw`" (§5) — then resolves the tie toward the
major with the **larger total weight** (larger `max`). Concretely:

- *Engineering cluster (p01, p04, p05).* `mech-eng` has the largest Engineering
  max (16), and a strong, hands-on STEM student satisfies every one of its
  requirements (math, physics, realistic, technical, analytical, investigative,
  creativity). It therefore reaches 16/16 and wins the raw tie-break over the
  intended comp/civil/elec, which also reach ~100% but at lower raw.
- *cs → comp-eng (p02).* Both reach 100%; `comp-eng` (max 14) edges `cs`
  (max 13) on raw. The cs archetype is genuinely an excellent computer-engineer
  too, which is why the expert acceptable set lists comp-eng.
- *english-lang → sociology (p17).* Both reach 100%; `sociology` (max 10) beats
  `english-lang` (max 9) on raw.

In short, the confusions are **genuine profile overlaps between adjacent fields**,
not engine defects — the engine's scores were verified to match an independent
recomputation exactly on all 560 recommendations (see Task 3). The acceptable
sets were authored precisely because an expert would also endorse these neighbours.

**Determinism note (exact ties).** When two majors tie on *both* percent and raw
(p07, p13, p16 each have such a tie at the top), CLIPS's stable merge `sort`
breaks the tie by working-memory order, which is knowledge-base declaration
order. Here that happened to favour the expected major in all three cases, but it
is an implementation detail, not a semantic rule — see §6 limitations.

---

## 5. Improvements Applied

**None.** Both required targets (Top-1 ≥ 70%, Top-3 ≥ 90%) are already met, so the
spec's and the task's "iterate only if below target" condition was not triggered.
No weights or rules were changed for tuning purposes during Task 4, which keeps
the knowledge base and the gold standard exactly as authored and independently
validated.

---

## 6. Why Not Tune Further (and How We Would)

It is tempting to push Top-1 higher, but with only 20 gold-standard points the
risk of **overfitting** is real, and the residual errors are not engine bugs.
Three considerations:

1. **The tie-break is spec-mandated.** The behaviour that produces the
   Engineering and Arts confusions follows directly from "favour the higher
   `raw`" (§5). Changing it would deviate from the specification.
2. **The confusions are domain-valid.** Every miss is an expert-endorsed
   neighbour (Acceptable@3 = 100%); 19/20 are faculty-correct. Forcing a
   particular sibling to win would require either editing the gold-standard
   profiles to pass the test (circular) or distorting weights away from their
   real-world importance.
3. **Knowledge integrity.** The weights encode genuine relative importance
   (documented in `majors-knowledge-base.md`); bending them to flip a within-
   faculty tie would degrade that.

**Principled refinements considered (not applied; available on request).** If a
higher Top-1 is desired and a small, *defensible* knowledge change is acceptable:

- *Separate CS from Computer Engineering (fixes p02).* Raise `comp-eng`'s
  `physics` requirement from `good` to `excellent`. A hardware-oriented computer
  engineer genuinely needs stronger physics than a computer scientist; the cs
  archetype (physics = good) would then only partially match comp-eng, dropping
  it below 100% and letting `cs` win. This is arguably better domain knowledge,
  not overfitting, and would raise Top-1 to 80% without affecting any other
  profile.
- *Add a deterministic, meaningful tertiary tie-break* for exact (percent, raw)
  ties — e.g. prefer the major with the more specific (fewer-requirement)
  profile — so results no longer depend on declaration order. This improves
  robustness rather than headline accuracy.

We recommend the first only with explicit sign-off, since it edits the knowledge
base after the gold standard was frozen.

---

## 7. Threats to Validity / Limitations

- **Sample size.** 20 profiles is enough to exercise every faculty but small for
  stable percentages; each profile is worth 5 points of Top-1.
- **Self-authored profiles.** The same author wrote the profiles and the
  knowledge base; an independent expert review would strengthen the gold
  standard (spec §9.4 documented human review).
- **Single-student assumption.** Scoring is per run; the runner enforces this
  with `(reset)` + `(undeffacts)` isolation.
- **Saturation.** Versatile students reach 100% on several majors, compressing
  the top of the ranking and leaning heavily on the raw tie-break. A future
  model could temper normalisation so breadth-of-match counts more.

---

## 8. Reproducing These Results

From the project root:

```
clips -f2 tests/run-tests.clp
```

(or `(batch* "tests/run-tests.clp")` inside CLIPS). The runner prints the
per-profile table, the three metrics, and the confusion matrix shown above.
