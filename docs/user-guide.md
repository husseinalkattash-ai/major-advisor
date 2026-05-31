# User Guide

How a student runs a consultation with the University Major Advisor and reads
its recommendations. The consultation front-end (`src/consultation.clp`) offers
an **interactive** mode (answer questions) and a **batch** mode (load a ready-made
profile). Both feed the same scoring engine.

> **Recommended — the web app.** After setup (`./setup.ps1` or `./setup.sh`), run
> `.venv\Scripts\python.exe server.py` (or `python run.py web`) and open
> <http://127.0.0.1:8000>. It's an Arabic (RTL), desktop guided flow; the ranking
> is computed by the real CLIPS engine.
>
> The sections below cover the CLIPS command-line modes.

---

## 1. Starting the System

You need CLIPS 6.4+ (the `clips` executable). From the **project root** (the
folder containing `src/`):

```
clips -f2 src/main.clp
```

This loads every module and leaves you at the CLIPS prompt (`CLIPS>`). Equivalent
from inside a running CLIPS:

```clips
(batch* "src/main.clp")
```

> Run from the project root so the relative paths in `main.clp` resolve. If you
> see file-not-found errors, `cd` to the project root first.

---

## 2. Running a Consultation

### Interactive mode

```clips
(consult)
```

The advisor asks you to rate yourself on 20 items, in three groups:

1. **Academic performance** (8 subjects) — answer `weak`, `average`, `good`, or
   `excellent`.
2. **Interests (RIASEC)** (6 items) — answer `low`, `medium`, or `high`.
3. **Skills and aptitudes** (6 items) — answer `low`, `medium`, or `high`.

Answers are **case-insensitive** (`Good` = `good`). After the last question the
advisor prints your **top 5 majors** with match percentages and justifications.

Type `quit` at any prompt to cancel.

### Batch mode (load a profile file)

A profile file is a `deffacts` of `attr` facts for one student. To load one from
any path and run it:

```clips
(consult-file "path/to/profile.clp")
```

---

## 3. Allowed Inputs

| Group | Items | Allowed values |
|-------|-------|----------------|
| Academic performance | math, physics, chemistry, biology, arabic, foreign-lang, social-studies, computing | `weak` `average` `good` `excellent` |
| Interests (RIASEC) | realistic, investigative, artistic, social, enterprising, conventional | `low` `medium` `high` |
| Skills and aptitudes | analytical, creativity, communication, technical, leadership, detail | `low` `medium` `high` |

**Invalid entries are handled gracefully.** If you type anything outside the
allowed values, the advisor explains the problem and asks the same question
again — nothing is lost and the consultation continues. End-of-input (Ctrl-D /
Ctrl-Z) also cancels safely.

---

## 4. Example Interactive Session

User input is shown after each `>` prompt. Note the invalid `amazing` (re-asked)
and the capitalised `Excellent` (accepted).

```
CLIPS> (consult)

=======================================================
   UNIVERSITY MAJOR ADVISOR - Interactive Consultation
=======================================================
Rate yourself on each item, then press Enter.
  Academic subjects: weak | average | good | excellent
  Interests & skills: low | medium | high
  (Answers are case-insensitive. Type 'quit' to cancel.)

--- Academic performance ---
   math (weak average good excellent) > amazing
   'amazing' is not allowed. Please type one of: weak average good excellent
   math (weak average good excellent) > good
   physics (weak average good excellent) > good
   chemistry (weak average good excellent) > Excellent
   biology (weak average good excellent) > excellent
   arabic (weak average good excellent) > good
   foreign-lang (weak average good excellent) > good
   social-studies (weak average good excellent) > good
   computing (weak average good excellent) > average

--- Interests (RIASEC) ---
   realistic (low medium high) > medium
   investigative (low medium high) > high
   artistic (low medium high) > low
   social (low medium high) > high
   enterprising (low medium high) > medium
   conventional (low medium high) > medium

--- Skills and aptitudes ---
   analytical (low medium high) > high
   creativity (low medium high) > medium
   communication (low medium high) > high
   technical (low medium high) > medium
   leadership (low medium high) > medium
   detail (low medium high) > high

Thank you. Analysing your profile...

====================================================================
   TOP 5 MAJOR RECOMMENDATIONS FOR YOU
====================================================================

#1   Medicine   --   100% match
     Faculty: Faculty of Medicine & Health Sciences
     Match score: 16 / 16
     Why this fits you:
        - Meticulous attention to detail protects patient safety.
        - Biochemistry and pharmacology make excellent chemistry essential.
        - Medicine is grounded in an excellent command of biology and the human body.
        - Diagnosis is detective work; a high investigative drive is vital.
        - Caring for patients requires genuine, high social motivation.
        - Clinical reasoning depends on strong analytical thinking.
        - Clear communication with patients and teams is part of good care.
--------------------------------------------------------------------

#2   Chemistry   --   100% match
     Faculty: Faculty of Science
     Match score: 13 / 13
     Why this fits you:
        - A chemistry major naturally requires excellent chemistry.
        - Investigative curiosity drives chemical experimentation and discovery.
        - ... (further justifications) ...
--------------------------------------------------------------------
   ... #3 Nursing, #4 Economics, #5 Biology ...
```

### Reading the output

- **Match %** = `match score / max` for that major, where *max* is the sum of the
  major's requirement weights. 100% means every requirement was fully met.
- **Why this fits you** lists the justification for each requirement you fully
  met. Near-misses (one level below) add partial points but no justification.
- Majors are ranked by percentage; ties are broken in favour of the higher raw
  score.

---

## 5. Example Batch Session

Loading a profile file for an enterprising, creative student produces:

```
CLIPS> (consult-file "profile.clp")
Loading profile file profile.clp ...

====================================================================
   TOP 5 MAJOR RECOMMENDATIONS FOR YOU
====================================================================

#1   Marketing   --   100% match
     Faculty: Faculty of Business Administration
     Match score: 12 / 12
     Why this fits you:
        - Marketing is an enterprising field about persuading and creating demand.
        - Persuasive communication is the everyday work of marketing.
        - Creative ideas make campaigns stand out.
        - ...
--------------------------------------------------------------------
   ... #2 Media, #3 Management, ...
```

---

## 6. Cancelling and Errors

- Typing `quit` at any prompt stops the consultation and prints
  `Consultation cancelled.` — no recommendations are produced.
- An invalid value is rejected with a message and the same question is asked
  again; you can never get "stuck" with a bad value recorded.
- To start over, just call `(consult)` again — it resets working memory first.
