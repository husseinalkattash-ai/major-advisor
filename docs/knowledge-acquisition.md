# Knowledge Acquisition

This document records **where the knowledge in the system comes from**, the
**decision table** that maps student attributes to majors (the conceptual core
of the knowledge base), and the **design assumptions** behind it.

It is written *before* the rules and the `requirement` facts so that the gold
standard (the test profiles and their expected recommendations) can be derived
from the same expert model that the knowledge base will later encode. The
per-major `requirement` blocks in `src/requirements.clp` (Task 2) are a direct
transcription of the decision table below.

---

## 1. Knowledge Sources

The knowledge is **rule/heuristic based**, not learned from data. Its sources:

1. **Holland's RIASEC / Career-Interest model** (Holland, *Making Vocational
   Choices*, 1997; and the U.S. O\*NET Interest Profiler). This supplies the six
   interest dimensions (Realistic, Investigative, Artistic, Social,
   Enterprising, Conventional) and the canonical interest codes for occupational
   families. Each major is assigned a primary (and often secondary) RIASEC code.
2. **Academic prerequisite mapping** — the school subjects that university
   faculties traditionally require or weight for admission (e.g. medicine
   weights biology + chemistry; engineering weights mathematics + physics). This
   is standard university admission-guidance knowledge.
3. **Skill/aptitude profiles** — the working skills a practitioner of each field
   relies on (analytical reasoning, creativity, communication, technical/manual
   aptitude, leadership, attention to detail), drawn from occupational role
   descriptions.
4. **Domain reasoning by the knowledge engineer** to assign relative
   **weights** (1–3) expressing how decisive each attribute is for each major.

These sources are combined into one **ideal-profile** per major: a small set of
attributes, each with a required ordinal level and an importance weight.

---

## 2. Attribute Vocabulary and Ordinal Scale

Every student fact and every major requirement is expressed in one shared
vocabulary so that scoring can be generic (see `docs/design.md`).

| Category | Attributes | Allowed values (low → high) |
|----------|------------|------------------------------|
| Academic performance | `math` `physics` `chemistry` `biology` `arabic` `foreign-lang` `social-studies` `computing` | `weak` `average` `good` `excellent` |
| Interests (RIASEC) | `realistic` `investigative` `artistic` `social` `enterprising` `conventional` | `low` `medium` `high` |
| Skills / aptitudes | `analytical` `creativity` `communication` `technical` `leadership` `detail` | `low` `medium` `high` |

Ordinal ranks used for graded comparison:

```
weak=1  average=2  good=3  excellent=4
low=1   medium=2   high=3
```

A requirement is **fully met** when the student's rank ≥ the required rank,
**partially met** when it is exactly one rank below, and **unmet** otherwise
(scoring details live in the spec §4 and are implemented in Task 3).

---

## 3. RIASEC → Faculty Orientation

The dominant interest code gives the first, coarse routing of a student toward a
faculty; academics and skills then refine it.

| RIASEC code | Orientation | Typical faculties / majors |
|-------------|-------------|----------------------------|
| **R** Realistic | building, machines, hands-on | Engineering (mechanical, civil, electrical) |
| **I** Investigative | analyzing, researching | Science, Medicine, Computer Eng/Sci |
| **A** Artistic | creating, expressing | Architecture, Graphic Design, Media, Languages |
| **S** Social | helping, teaching, caring | Nursing, Education, Psychology, Sociology |
| **E** Enterprising | leading, persuading, selling | Management, Marketing, Law, Economics |
| **C** Conventional | organizing, detail, records | Accounting, MIS, Medical Lab, Pharmacy |

Most majors are a **two-letter code** (primary + secondary), e.g. Computer
Science = **IR**, Marketing = **EA**, Nursing = **SC**.

---

## 4. Decision Table — Attributes → Majors

This is the authoritative mapping. For each major it lists every **requirement**
as `attribute=level·weight`, where the level is on the shared ordinal scale and
the weight (1–3) expresses how decisive that attribute is for the major. Each
major has **4–7 requirements**, as required by spec §8. These rows are the exact
`requirement` facts in `src/requirements.clp` (this table and that file are
generated from one source so they cannot drift apart), and the rationale for
each is expanded in `docs/majors-knowledge-base.md` (Task 2).

Requirements are listed in descending weight order; the first one or two are the
major's defining attributes. The RIASEC code is the major's primary + secondary
interest type.

| Major | Faculty | RIASEC | Requirements (attribute=level·weight) |
|-------|---------|:------:|--------------------------------------------|
| Computer Engineering (`comp-eng`) | Engineering | IR | math=excellent·3; investigative=high·3; computing=good·2; analytical=high·2; technical=high·2; physics=good·1; realistic=medium·1 |
| Electrical Engineering (`elec-eng`) | Engineering | IR | math=excellent·3; physics=excellent·3; analytical=high·2; technical=high·2; investigative=high·2; realistic=high·1 |
| Civil Engineering (`civil-eng`) | Engineering | RI | math=excellent·3; physics=excellent·3; realistic=high·3; technical=high·2; analytical=high·2; investigative=high·1; detail=high·1 |
| Mechanical Engineering (`mech-eng`) | Engineering | RI | math=excellent·3; physics=excellent·3; realistic=high·3; technical=high·2; analytical=high·2; investigative=high·2; creativity=medium·1 |
| Medicine (`medicine`) | Medicine & Health | IS | biology=excellent·3; chemistry=excellent·3; investigative=high·3; social=high·2; analytical=high·2; detail=high·2; communication=high·1 |
| Pharmacy (`pharmacy`) | Medicine & Health | IC | chemistry=excellent·3; detail=high·3; biology=good·2; analytical=high·2; conventional=high·2; investigative=high·1 |
| Nursing (`nursing`) | Medicine & Health | SC | social=high·3; communication=high·3; biology=good·3; detail=high·2; conventional=medium·1 |
| Medical Laboratory Sciences (`med-lab`) | Medicine & Health | CI | chemistry=good·3; biology=good·3; detail=high·3; technical=high·2; conventional=high·2; analytical=high·1; investigative=medium·1 |
| Computer Science (`cs`) | Science | IR | math=excellent·3; computing=excellent·3; investigative=high·3; analytical=high·3; detail=high·1 |
| Mathematics (`math-sci`) | Science | IC | math=excellent·3; investigative=high·3; analytical=high·3; physics=good·1; detail=high·1 |
| Physics (`physics-sci`) | Science | IR | physics=excellent·3; math=excellent·3; investigative=high·3; analytical=high·2 |
| Chemistry (`chem-sci`) | Science | IC | chemistry=excellent·3; investigative=high·3; math=good·2; analytical=high·2; detail=high·2; biology=good·1 |
| Biology (`bio-sci`) | Science | IS | biology=excellent·3; investigative=high·3; chemistry=good·2; analytical=high·2; detail=high·1 |
| Accounting (`accounting`) | Business | CE | conventional=high·3; detail=high·3; math=good·3; analytical=high·2; computing=average·1 |
| Management (`management`) | Business | EC | enterprising=high·3; leadership=high·3; communication=high·2; social=high·2; conventional=medium·1 |
| Marketing (`marketing`) | Business | EA | enterprising=high·3; communication=high·3; creativity=high·3; social=high·2; artistic=medium·1 |
| Economics (`economics`) | Business | IE | math=good·3; analytical=high·3; investigative=high·2; social-studies=good·2; enterprising=medium·1; communication=high·1 |
| Management Information Systems (`mis`) | Business | CE | computing=good·3; conventional=high·2; math=good·2; analytical=high·2; enterprising=medium·2; communication=medium·1 |
| Arabic Language (`arabic-lang`) | Arts & Humanities | AS | arabic=excellent·3; communication=high·2; artistic=high·2; creativity=high·1; social-studies=good·1 |
| English Language (`english-lang`) | Arts & Humanities | AS | foreign-lang=excellent·3; communication=high·3; artistic=medium·1; social=medium·1; social-studies=average·1 |
| History (`history`) | Arts & Humanities | IA | social-studies=excellent·3; investigative=high·2; communication=medium·1; arabic=good·1 |
| Psychology (`psychology`) | Arts & Humanities | IS | social=high·3; investigative=high·2; biology=good·2; communication=high·2; analytical=high·1 |
| Sociology (`sociology`) | Arts & Humanities | SE | social=high·3; social-studies=good·3; communication=high·2; investigative=medium·1; enterprising=medium·1 |
| Law (`law`) | Law | ES | social-studies=excellent·3; enterprising=high·3; communication=high·3; leadership=high·2; detail=high·1; analytical=high·1; arabic=good·1 |
| Education (`education`) | Education | SC | social=high·3; communication=high·3; social-studies=good·2; leadership=medium·1; conventional=medium·1 |
| Media (`media`) | Media | AE | communication=high·3; artistic=high·2; enterprising=high·2; creativity=high·2; social=medium·1 |
| Architecture (`architecture`) | Architecture | AR | artistic=high·3; creativity=high·3; math=good·2; technical=high·2; realistic=medium·1; analytical=high·1; detail=high·1 |
| Graphic Design (`graphic-design`) | Fine Arts & Design | AR | artistic=high·3; creativity=high·3; technical=high·2; computing=good·1; social=medium·1; detail=high·1 |

---

## 5. How the Decision Table Drives the Gold Standard

The gold-standard profiles in `tests/profiles/` are constructed as *archetypes*:
for a target major, the student is given attribute values that **meet or exceed**
that major's high-weight requirements, while neighbouring majors are only
partially satisfied. The expected `top1` is the target major; the
`acceptable_top3` set lists the target plus its **adjacent majors** (same or
neighbouring faculty) that a domain expert would also consider reasonable for
that profile. This makes the later **faculty-level confusion matrix** (spec §9.3)
meaningful: confusions are expected to fall *within* the acceptable set.

See `tests/expected-results.csv` for the 20 profiles and their expert-expected
recommendations.

---

## 6. Design Assumptions

1. **One shared ordinal vocabulary.** Academic, interest, and skill values are
   placed on comparable ordinal scales (1–4 and 1–3). We assume cross-category
   comparison is *not* required — a requirement only ever compares like with
   like (a `math` requirement against the student's `math`).
2. **Missing attribute = not demonstrated.** If a profile omits an attribute, no
   points are awarded for requirements on it (treated as the lowest rank). Test
   profiles therefore specify **all 20 attributes** to avoid accidental zeros.
3. **Weights are relative within a major**, not absolute across majors. The
   final score is normalised to a percentage (`raw / max * 100`), so a major
   with many requirements is not penalised against one with few.
4. **Partial credit** (one rank below) rewards near-misses without justifying
   them in the explanation, reflecting an expert's "close, but I wouldn't cite
   this as a reason" judgement.
5. **A major is a single archetype.** Real majors have sub-specialisations; we
   model each as one ideal profile, which is sufficient for first-choice
   guidance.
6. **The student is honest and self-aware.** Inputs are taken at face value;
   the system advises, it does not assess or verify ability.
7. **Closed list of majors.** Recommendations are limited to the majors in the
   knowledge base (spec §8); the system never invents a major.
