# Design

This document explains the architecture of the University Major Advisor, why it
is built as a knowledge-based system using forward chaining, the RIASEC model it
embeds, and how knowledge is represented.

---

## 1. System Architecture

The system is five logical modules, all inside CLIPS, plus a documented gold
standard. Knowledge (facts) is kept strictly separate from logic (rules) so the
knowledge base can grow without touching the engine (spec §12).

| # | Module | File(s) | Responsibility |
|---|--------|---------|----------------|
| 1 | Knowledge base | `majors.clp`, `requirements.clp` | the ideal profile of every major (`major` + `requirement` facts) |
| 2 | Working memory | `attr` facts (from consultation) | the current student's profile |
| 3 | Scoring engine | `scoring.clp` | compare attributes to requirements; accumulate points + justifications |
| 4 | Ranking & output | `ranking.clp` | normalise to %, sort, print the explained top 5 |
| 5 | Consultation | `consultation.clp` | gather the profile interactively or in batch |
| — | Templates | `templates.clp` | shared `deftemplate`s and the ordinal rank scale |
| — | Evaluation | `tests/` | 20-profile gold standard + runner + metrics |

### Component / data-flow diagram

```
                         ┌─────────────────────────────────────────────┐
                         │              KNOWLEDGE BASE                   │
                         │  majors.clp  +  requirements.clp             │
                         │  (major facts, requirement facts,            │
                         │   init-recommendations)                      │
                         └───────────────────────┬─────────────────────┘
                                                 │ (reset) asserts
                                                 ▼
  ┌──────────────┐   attr facts   ┌──────────────────────────────────┐
  │ CONSULTATION │ ─────────────► │           WORKING MEMORY          │
  │ consultation │                │  attr (student profile)           │
  │   .clp       │                │  major / requirement / rank       │
  │ interactive  │                │  recommendation (raw,max,%)       │
  │   or batch   │                └─────────────────┬────────────────┘
  └──────────────┘                                  │ (run)
                                                     ▼
                          ┌────────────────────────────────────────┐
                          │            SCORING ENGINE                │
                          │ scoring.clp  (salience 0 / -10)          │
                          │  score-full-match  → +weight + reason    │
                          │  score-partial-match → +weight/2         │
                          │  compute-percent → raw/max*100           │
                          └────────────────────┬─────────────────────┘
                                               │ recommendation facts
                                               ▼
                          ┌────────────────────────────────────────┐
                          │          RANKING & OUTPUT                │
                          │ ranking.clp  (salience -100)             │
                          │  sort by % (tie: raw) → print top 5      │
                          │  with faculty + justifications           │
                          └────────────────────────────────────────┘
```

`main.clp` loads the modules in dependency order: templates → majors →
requirements → scoring → ranking → consultation.

---

## 2. Why a Knowledge-Based Approach (not Machine Learning)

The problem is advisory and explanation-critical, which fits a rule/knowledge
system far better than a learned model:

- **Explainability is a requirement, not a bonus.** A student must be told *why*
  a major is recommended. Every recommendation here carries the exact
  justifications of the requirements it met — impossible to guarantee from an
  opaque learned model.
- **No training data needed.** There is no large labelled dataset of
  "student → ideal major". The knowledge is expert heuristics (subject
  prerequisites, the RIASEC model, skill profiles), which encode directly as
  facts and rules.
- **Transparency and trust.** Every weight and reason is human-readable in
  `requirements.clp` and documented in `majors-knowledge-base.md`. Domain experts
  can audit and edit the knowledge without programming.
- **Easy to extend.** Adding a major or adjusting a weight is a data change in
  `requirements.clp`; the generic rules need no modification.
- **Determinism.** The same profile always yields the same explained result —
  important for fairness in guidance.

The spec mandates this: pure CLIPS, no ML component.

---

## 3. Why Forward Chaining (the Rete Engine)

The reasoning is **data-driven**: we start from asserted facts (the student's
attributes and the knowledge base) and let conclusions (recommendation scores)
accumulate. This is the natural shape of forward chaining:

- **Facts drive conclusions.** As soon as the student's `attr` facts and a
  major's `requirement` facts are present, the scoring rules fire and build up
  the `recommendation`. We are not trying to prove a single goal (which would
  suit backward chaining); we are deriving *all* majors' scores at once.
- **Generic pattern matching.** One pair of rules scores every
  (major, attribute) combination by matching on the `requirement`/`attr`/`rank`
  patterns — no per-major code. The Rete network matches these efficiently.
- **Incremental accumulation.** `modify` on the `recommendation` fact lets points
  and reasons build up across many rule firings, with a `scored` marker ensuring
  each requirement contributes exactly once.
- **Phased inference via salience.** Scoring (salience 0) completes before
  percentage computation (-10), which completes before the report prints (-100) —
  a clean pipeline expressed declaratively.

---

## 4. Knowledge Representation

All inputs and knowledge use one small, uniform vocabulary so scoring can be
generic (spec §3). The templates (`src/templates.clp`):

```clips
(deftemplate attr            ; one per student attribute (working memory)
   (slot student) (slot name) (slot value))

(deftemplate major           ; a major's identity
   (slot id) (slot name) (slot faculty))

(deftemplate requirement     ; one line of a major's ideal profile (knowledge)
   (slot major) (slot attribute) (slot level) (slot weight) (slot reason))

(deftemplate recommendation  ; accumulator, one per major
   (slot major) (slot raw (default 0)) (slot max (default 0))
   (slot percent (default 0)) (multislot reasons))
```

Values live on a shared **ordinal scale** so requirements can be compared by
rank:

```clips
(deffacts ordinal-scale
   (rank weak 1) (rank average 2) (rank good 3) (rank excellent 4)
   (rank low 1)  (rank medium 2)  (rank high 3))
```

Attributes fall into three categories:

| Category | Attributes | Scale |
|----------|-----------|-------|
| Academic performance | math, physics, chemistry, biology, arabic, foreign-lang, social-studies, computing | weak…excellent |
| Interests (RIASEC) | realistic, investigative, artistic, social, enterprising, conventional | low…high |
| Skills & aptitudes | analytical, creativity, communication, technical, leadership, detail | low…high |

An example of knowledge as data (`requirements.clp`):

```clips
(deffacts req-comp-eng
   (requirement (major comp-eng) (attribute math) (level excellent) (weight 3)
                (reason "Computer engineering rests on a very strong mathematics foundation, ..."))
   (requirement (major comp-eng) (attribute investigative) (level high) (weight 3)
                (reason "Your strong investigative drive matches the problem-solving heart of engineering."))
   ...)
```

---

## 5. The RIASEC / Holland Model

Six of the attributes are the **RIASEC** interest dimensions from John Holland's
theory of vocational choice (and the U.S. O\*NET Interest Profiler). Holland
proposes that both people and work environments can be described by six types,
and that satisfaction comes from matching them:

| Code | Type | Orientation |
|:----:|------|-------------|
| **R** | Realistic | building, machines, hands-on, outdoors |
| **I** | Investigative | analysing, researching, theorising |
| **A** | Artistic | creating, expressing, designing |
| **S** | Social | helping, teaching, caring |
| **E** | Enterprising | leading, persuading, selling |
| **C** | Conventional | organising, detail, records, procedures |

Each major is tagged with a two-letter RIASEC code (primary + secondary), e.g.
Computer Science = **IR**, Marketing = **EA**, Nursing = **SC**. These interests
appear as `requirement` facts alongside academics and skills, so a student's
interest profile contributes to the match just like grades and aptitudes. The
RIASEC code gives the first, coarse routing toward a faculty; academics and skills
then refine the specific major. See `knowledge-acquisition.md` for the full
mapping.

---

## 6. Scoring Model

For each requirement, the student's value rank `srank` is compared with the
required level rank `rrank` (spec §4):

| Condition | Award | Justification recorded? |
|-----------|-------|:-----------------------:|
| `srank >= rrank` (meets/exceeds) | full `weight` | yes |
| `srank = rrank - 1` (one below) | `weight / 2` | no |
| `srank < rrank - 1` | 0 | no |

Each major's `raw` is normalised: `percent = round(raw / max * 100)`, where `max`
is the sum of the major's weights (set up front by `init-recommendations`).
Normalising means a major with many requirements is not unfairly favoured over a
focused one. Majors are ranked by `percent` descending; ties are broken in favour
of the higher `raw` (spec §5). The exact rules and the no-double-counting
mechanism are in [rules-reference.md](rules-reference.md).

---

## 7. Separation of Knowledge and Logic

A central design principle (spec §12): the rules never name a specific major or
attribute. All domain knowledge is in `majors.clp` and `requirements.clp` as
facts; the scoring rules operate purely on the `requirement`, `attr`, and `rank`
patterns. Consequences:

- Adding a major or tuning a weight is a **data edit** — no rule changes.
- The consultation module is built from deffunctions and shares no rules with the
  engine, so neither mode (interactive or batch) alters scoring.

---

## 8. Known Limitations

- **Single student per run.** A `recommendation` has no student slot; scoring is
  for one profile at a time (the runner `(reset)`s between profiles).
- **Saturation.** Very strong, well-rounded students reach 100% on several
  majors, leaning on the raw tie-break; see `evaluation-report.md` §4/§7.
- **Self-authored gold standard.** An independent expert review would further
  validate the knowledge (spec §9.4).
