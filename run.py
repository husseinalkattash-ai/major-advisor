#!/usr/bin/env python3
"""
run.py - Python launcher for the University Major Recommendation Expert System.

The reasoning core is pure CLIPS (src/*.clp). This script only embeds the CLIPS
engine via the `clipspy` library and drives it, so you can run the project from
Python without installing the standalone `clips` executable.

Usage (after activating the virtual environment, or via .venv/Scripts/python.exe):

    python run.py                 # interactive menu
    python run.py consult         # interactive consultation (asks 20 questions)
    python run.py file <path>     # run a profile from an arbitrary .clp file
    python run.py web             # launch the web UI (Flask + CLIPS) at :8000

All paths are resolved relative to this script's folder (the project root).
"""

import os
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent
os.chdir(ROOT)  # so CLIPS relative loads (src/...) resolve

SRC_MODULES = [
    "templates", "majors", "requirements", "scoring", "ranking", "consultation",
]


def _require_clips():
    try:
        import clips  # noqa: F401
        return clips
    except ImportError:
        sys.exit(
            "ERROR: the 'clipspy' library is not installed.\n"
            "Activate the project virtual environment first, e.g.:\n"
            "  Windows : .venv\\Scripts\\Activate.ps1   (then: python run.py ...)\n"
            "  Linux/Mac: source .venv/bin/activate\n"
            "or install it with:  pip install -r requirements.txt"
        )


def load_system():
    """Create a CLIPS environment and load the expert system (silently)."""
    clips = _require_clips()
    env = clips.Environment()
    for module in SRC_MODULES:
        env.load(f"src/{module}.clp")
    env.reset()
    return env


def cmd_consult():
    """Interactive consultation: CLIPS reads your answers from the terminal."""
    env = load_system()
    env.eval("(consult)")


def cmd_file(path):
    """Run a profile from an arbitrary .clp file path."""
    p = Path(path)
    if not p.exists():
        sys.exit(f"ERROR: file not found: {path}")
    env = load_system()
    # forward slashes are safe for CLIPS on every platform
    env.eval(f'(consult-file "{p.as_posix()}")')


def cmd_web():
    """Launch the web UI (Flask + CLIPS) at http://127.0.0.1:8000."""
    import server
    server.main()


def menu():
    print("=" * 55)
    print("  University Major Advisor - Python launcher")
    print("=" * 55)
    print("  1) Interactive consultation (terminal)")
    print("  2) Launch the web UI")
    print("  3) Quit")
    choice = input("Choose [1-3]: ").strip()
    if choice == "1":
        cmd_consult()
    elif choice == "2":
        cmd_web()
    else:
        print("Bye.")


def main(argv):
    if not argv:
        menu()
        return
    cmd, rest = argv[0], argv[1:]
    if cmd == "consult":
        cmd_consult()
    elif cmd == "file":
        if not rest:
            sys.exit("Usage: python run.py file <path-to-profile.clp>")
        cmd_file(rest[0])
    elif cmd == "web":
        cmd_web()
    elif cmd in ("-h", "--help", "help"):
        print(__doc__)
    else:
        sys.exit(f"Unknown command: {cmd}\n{__doc__}")


if __name__ == "__main__":
    main(sys.argv[1:])
