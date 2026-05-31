# setup.ps1 - one-time setup of the Python virtual environment (Windows PowerShell)
# Usage:  ./setup.ps1
# Then:   .\.venv\Scripts\Activate.ps1
#         python run.py

$ErrorActionPreference = "Stop"
Set-Location $PSScriptRoot

if (-not (Test-Path ".venv")) {
    Write-Host "Creating virtual environment in .venv ..."
    python -m venv .venv
}

Write-Host "Installing dependencies ..."
& .\.venv\Scripts\python.exe -m pip install --upgrade pip | Out-Null
& .\.venv\Scripts\python.exe -m pip install -r requirements.txt

Write-Host ""
Write-Host "Done. To run the project:"
Write-Host "  .\.venv\Scripts\Activate.ps1"
Write-Host "  python run.py            # interactive menu"
Write-Host "  python run.py test       # run the test suite"
Write-Host "  python run.py batch p03  # run a profile"
