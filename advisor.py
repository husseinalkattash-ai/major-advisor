"""
advisor.py - shared Python wrapper around the CLIPS expert system.

The reasoning core stays pure CLIPS (src/*.clp); this module just embeds the
engine via clipspy and exposes a small API used by the web backend (server.py)
and usable from run.py / notebooks:

    adv = Advisor()
    recs = adv.recommend({"math": "excellent", ...})   # -> ranked list of dicts
"""

import os
from pathlib import Path

import clips

ROOT = Path(__file__).resolve().parent
SRC_MODULES = ["templates", "majors", "requirements", "scoring", "ranking"]

# (attribute id, display label), in the order the spec asks them.
ACADEMIC = [("math", "Mathematics"), ("physics", "Physics"),
            ("chemistry", "Chemistry"), ("biology", "Biology"),
            ("arabic", "Arabic"), ("foreign-lang", "Foreign Language"),
            ("social-studies", "Social Studies"), ("computing", "Computing")]
INTERESTS = [("realistic", "Realistic"), ("investigative", "Investigative"),
             ("artistic", "Artistic"), ("social", "Social"),
             ("enterprising", "Enterprising"), ("conventional", "Conventional")]
SKILLS = [("analytical", "Analytical"), ("creativity", "Creativity"),
          ("communication", "Communication"), ("technical", "Technical"),
          ("leadership", "Leadership"), ("detail", "Detail")]

ACAD_VALUES = ["weak", "average", "good", "excellent"]
RATE_VALUES = ["low", "medium", "high"]
ACAD_DEFAULT = "average"
RATE_DEFAULT = "medium"

ALL_ATTRS = ACADEMIC + INTERESTS + SKILLS
ACADEMIC_KEYS = {k for k, _ in ACADEMIC}


def default_for(attr):
    return ACAD_DEFAULT if attr in ACADEMIC_KEYS else RATE_DEFAULT


class Advisor:
    def __init__(self):
        os.chdir(ROOT)  # so CLIPS relative loads resolve
        self.env = clips.Environment()
        for m in SRC_MODULES:
            self.env.load(f"src/{m}.clp")
        # results are rendered from facts, so silence the console auto-report
        self.env.eval("(undefrule print-report)")
        self.env.reset()
        self.majors = {}
        for f in self.env.facts():
            if f.template.name == "major":
                self.majors[str(f["id"])] = (str(f["name"]), str(f["faculty"]))

    def recommend(self, profile):
        """profile: {attr: value}. Returns recommendations sorted best-first."""
        self.env.reset()
        for name, value in profile.items():
            self.env.assert_string(
                f"(attr (student you) (name {name}) (value {value}))")
        self.env.run()
        recs = []
        for f in self.env.facts():
            if f.template.name == "recommendation":
                mid = str(f["major"])
                name, faculty = self.majors.get(mid, (mid, ""))
                recs.append({
                    "id": mid, "name": name, "faculty": faculty,
                    "raw": float(f["raw"]), "max": int(f["max"]),
                    "percent": int(f["percent"]),
                    "reasons": [str(x) for x in f["reasons"]],
                })
        # percent desc, tie-break raw desc (matches the engine's rec-worse)
        recs.sort(key=lambda r: (-r["percent"], -r["raw"]))
        return recs
