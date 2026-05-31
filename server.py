"""
server.py - Flask backend that serves the Major Advisor web UI (webui/) and runs
the real CLIPS expert system behind /api/recommend.

The front-end (webui/) is the exported Claude Design prototype (Arabic-first, RTL,
bilingual, themeable). Its demo scoring heuristic is overridden by ma-clips.js,
which POSTs the student's answers here; this endpoint maps them onto the CLIPS
attribute vocabulary, runs src/*.clp via advisor.Advisor, and returns the real
match percentage per major.

Run:
    .venv\\Scripts\\python.exe server.py        (then open http://127.0.0.1:8000)
or: python run.py web
"""

import os
import threading

from flask import Flask, send_from_directory, request, jsonify

from advisor import Advisor

ROOT = os.path.dirname(os.path.abspath(__file__))
WEBUI = os.path.join(ROOT, "webui")

# --- map the design's attribute keys/values onto the CLIPS vocabulary ---------
# Academic subjects use a 4-point scale; interests & skills use a 3-point scale.
ACADEMIC_MAP = {
    "math": "math", "physics": "physics", "chem": "chemistry", "bio": "biology",
    "arabic": "arabic", "foreign": "foreign-lang", "social": "social-studies",
    "computing": "computing",
}
RATING_MAP = {
    "realistic": "realistic", "investigative": "investigative", "artistic": "artistic",
    "social_i": "social", "enterprising": "enterprising", "conventional": "conventional",
    "analytical": "analytical", "creativity": "creativity", "communication": "communication",
    "technical": "technical", "leadership": "leadership", "detail": "detail",
}
ACADEMIC_VALUES = ["weak", "average", "good", "excellent"]   # index 0..3
RATING_VALUES = ["low", "medium", "high"]                    # index 0..2
ACADEMIC_NEUTRAL = "average"   # used when a subject is skipped
RATING_NEUTRAL = "medium"

app = Flask(__name__, static_folder=WEBUI, static_url_path="")

_lock = threading.Lock()      # CLIPS env is single-student-per-run; serialise calls
_advisor = None


def get_advisor():
    global _advisor
    if _advisor is None:
        _advisor = Advisor()
    return _advisor


def build_profile(answers):
    """Map the design's {key: ordinal-index} answers to {clips-attr: value}."""
    profile = {}
    for dkey, ckey in ACADEMIC_MAP.items():
        idx = answers.get(dkey)
        profile[ckey] = (ACADEMIC_VALUES[idx]
                         if isinstance(idx, int) and 0 <= idx < len(ACADEMIC_VALUES)
                         else ACADEMIC_NEUTRAL)
    for dkey, ckey in RATING_MAP.items():
        idx = answers.get(dkey)
        profile[ckey] = (RATING_VALUES[idx]
                         if isinstance(idx, int) and 0 <= idx < len(RATING_VALUES)
                         else RATING_NEUTRAL)
    return profile


@app.route("/")
def index():
    return send_from_directory(WEBUI, "index.html")


@app.route("/api/recommend", methods=["POST"])
def recommend():
    payload = request.get_json(force=True, silent=True) or {}
    profile = build_profile(payload.get("answers", {}))
    with _lock:
        recs = get_advisor().recommend(profile)
    # percent per CLIPS major id, plus the matched reasons (handy for debugging)
    percents = {r["id"]: r["percent"] for r in recs}
    return jsonify({"percents": percents})


@app.route("/api/health")
def health():
    return jsonify({"ok": True, "majors": len(get_advisor().majors)})


def main(host="127.0.0.1", port=8000):
    print(f"Major Advisor running at http://{host}:{port}  (Ctrl+C to stop)")
    app.run(host=host, port=port, debug=False)


if __name__ == "__main__":
    main()
