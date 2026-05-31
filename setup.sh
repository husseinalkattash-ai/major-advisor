#!/usr/bin/env bash
# setup.sh - one-time setup of the Python virtual environment (Linux/macOS)
# Usage:  ./setup.sh
# Then:   source .venv/bin/activate
#         python run.py
set -e
cd "$(dirname "$0")"

if [ ! -d ".venv" ]; then
  echo "Creating virtual environment in .venv ..."
  python3 -m venv .venv
fi

echo "Installing dependencies ..."
./.venv/bin/python -m pip install --upgrade pip >/dev/null
./.venv/bin/python -m pip install -r requirements.txt

echo
echo "Done. To run the project:"
echo "  source .venv/bin/activate"
echo "  python run.py            # interactive menu"
echo "  python run.py test       # run the test suite"
echo "  python run.py batch p03  # run a profile"
