# University Major Recommendation Expert System (CLIPS)

A knowledge-based expert system that recommends a suitable university major from a
student's **academic performance**, **interests** (Holland/RIASEC model), and
**skills**. It is implemented in **pure CLIPS** with **forward chaining** (the
built-in Rete engine) and contains **no machine-learning component** — every
recommendation comes with textual justifications derived from the rules that
fired.

- **28 majors** across **6 faculty groups** (Engineering, Medicine & Health,
  Science, Business, Arts & Humanities, and Other: Law, Education, Media,
  Architecture, Graphic Design).
- Graded scoring with full / half / zero credit, normalised to a match
  percentage, with an explained top-5 ranking.
- A modern Arabic web app, plus an interactive terminal consultation.

---

## Requirements

- **CLIPS 6.4** or newer (the `clips` executable). Download:
  <https://www.clipsrules.net/>.
- No other dependencies. (For environments without the `clips` binary, the
  project also runs under [`clipspy`](https://clipspy.readthedocs.io/), the
  Python binding — see [Running without the CLIPS binary](#running-without-the-clips-binary).)

---

## Project Structure

```
major-advisor/
├── src/
│   ├── templates.clp      ; deftemplates (attr, major, requirement,
│   │                      ;   recommendation) + the ordinal rank scale
│   ├── majors.clp         ; the 28 `major` facts, grouped by faculty
│   ├── requirements.clp   ; the `requirement` facts (core knowledge base)
│   │                      ;   + init-recommendations
│   ├── scoring.clp        ; graded scoring rules (full / half / percent)
│   ├── ranking.clp        ; sort + top-5 report
│   ├── consultation.clp   ; interactive & batch front-ends
│   └── main.clp           ; loads all modules in order
├── docs/
│   ├── design.md                 ; architecture, why KB + forward chaining, RIASEC
│   ├── knowledge-acquisition.md  ; knowledge sources + the decision table
│   ├── majors-knowledge-base.md  ; each major's ideal profile + rationale
│   ├── rules-reference.md        ; every rule: purpose, code, source
│   ├── user-guide.md             ; how to run a consultation
│   └── evaluation-report.md      ; methodology, metrics, error analysis
├── webui/                 ; Major Advisor web UI (Arabic, RTL, desktop)
│   ├── index.html         ;   design shell (React + Babel, from Claude Design)
│   ├── ma-clips.js        ;   wires the UI to the real CLIPS engine
│   └── ma-*.js(x), *.css  ;   design components, data, copy, styles
├── server.py              ; Flask backend: serves webui/ + /api/recommend (CLIPS)
├── advisor.py             ; shared Python wrapper around the CLIPS engine
├── run.py                 ; command-line launcher (embeds CLIPS via clipspy)
├── requirements.txt       ; Python dependencies (clipspy, flask)
├── setup.ps1 / setup.sh   ; one-time virtual-environment setup
└── README.md
```

---

## How to Run

All commands are run from the **project root** (the folder containing `src/`) so
the relative load paths resolve.

### Interactive consultation

```
clips -f2 src/main.clp
```

Then at the `CLIPS>` prompt:

```clips
(consult)
```

Answer each prompt with an allowed value (academics: `weak`/`average`/`good`/
`excellent`; interests & skills: `low`/`medium`/`high`; answers are
case-insensitive; type `quit` to cancel). See [docs/user-guide.md](docs/user-guide.md).

### Run with Python (no CLIPS binary needed)

The reasoning core is plain CLIPS, so the project also runs under
[`clipspy`](https://clipspy.readthedocs.io/) (an embedded CLIPS 6.4 engine). A
launcher (`run.py`) and a setup script create a self-contained virtual
environment with everything needed.

**One-time setup** (creates `.venv/` and installs `clipspy`):

```
# Windows (PowerShell)
./setup.ps1

# Linux / macOS
./setup.sh
```

Or manually:

```
python -m venv .venv
.venv\Scripts\python.exe -m pip install -r requirements.txt   # Windows
# ./.venv/bin/python -m pip install -r requirements.txt        # Linux/macOS
```

**Run it** (after `.\.venv\Scripts\Activate.ps1` or `source .venv/bin/activate`):

```
python run.py                 # interactive menu
python run.py consult         # interactive consultation (20 questions)
python run.py batch p03       # run a ready-made profile
python run.py file <path>     # run a profile from any .clp file
python run.py test            # run the gold-standard suite + metrics
python run.py list            # list available test profiles
```

(All outputs in this repo were verified through this Python path.)

### Web app — Major Advisor (recommended)

A polished **Arabic, RTL, desktop** web app built from a Claude Design hand-off —
a guided multi-screen flow (welcome → academic → interests → skills → review →
processing → ranked results → detail) with a live Tweaks panel (theme, rating
control, match visualisation). The ranking and match percentages are produced by
the **real CLIPS engine** (`server.py` exposes `/api/recommend`, backed by
`advisor.py`).

```
.venv\Scripts\python.exe server.py        # Windows
./.venv/bin/python server.py              # Linux/macOS
# or:  python run.py web
```

Open <http://127.0.0.1:8000>.

---

## Example Session

For a strong science-and-people profile (excellent biology/chemistry, high
investigative and social), the engine produces:

```
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
#2   Chemistry   --   100% match   (13 / 13)
#3   Nursing     --   100% match   (12 / 12)
#4   Economics   --   100% match   (12 / 12)
#5   Biology     --   100% match   (11 / 11)
```

---

## How It Works (in brief)

1. **Knowledge base.** Each major has 4–7 `requirement` facts: an attribute, a
   required level on an ordinal scale, an importance weight (1–3), and a reason.
2. **Working memory.** The student's profile is a set of uniform `attr` facts.
3. **Scoring (forward chaining).** Generic rules compare each requirement's
   required rank against the student's rank: meet-or-exceed → full weight + the
   reason; one level below → half weight; lower → zero. A `scored` marker fact
   prevents any requirement from being counted twice.
4. **Ranking.** Each major's `raw` is normalised to `percent = round(raw/max*100)`;
   majors are sorted by percentage (ties broken by raw) and the top 5 are printed
   with their justifications.

Full detail in [docs/design.md](docs/design.md) and [docs/rules-reference.md](docs/rules-reference.md).

---

## Evaluation Results

Measured over a 20-profile gold standard during development:

| Metric | Result | Target |
|--------|:------:|:------:|
| Top-1 accuracy | **75%** | ≥ 70% ✅ |
| Top-3 hit rate | **95%** | ≥ 90% ✅ |
| Acceptable@3 | **100%** | — |

Both targets were met. Methodology, the confusion matrix, and error analysis are
recorded in [docs/evaluation-report.md](docs/evaluation-report.md).

---

## Documentation

| Document | Contents |
|----------|----------|
| [docs/design.md](docs/design.md) | Architecture, why a knowledge-based approach and forward chaining, the RIASEC model, component diagram |
| [docs/knowledge-acquisition.md](docs/knowledge-acquisition.md) | Knowledge sources, the attribute→major decision table, design assumptions |
| [docs/majors-knowledge-base.md](docs/majors-knowledge-base.md) | Each major's ideal profile and the rationale for every requirement and weight |
| [docs/rules-reference.md](docs/rules-reference.md) | Every rule and helper: purpose, condition, action, code, knowledge source |
| [docs/user-guide.md](docs/user-guide.md) | Running a consultation, allowed inputs, example sessions |
| [docs/evaluation-report.md](docs/evaluation-report.md) | Evaluation methodology, metrics, confusion matrix, error analysis |
