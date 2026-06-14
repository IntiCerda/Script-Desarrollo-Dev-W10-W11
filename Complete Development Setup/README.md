# Complete Development Setup

Orchestrates `setup-dev.ps1` and `setup-docker-wsl.ps1` in sequence.
Also ensures winget is installed and refreshes package sources before starting.

## Steps

1. Verify winget is installed; install it if missing, then run `winget source update`
2. Run **Basic Development Setup** (tools, languages, VS Code extensions)
3. Run **Docker and WSL Setup** (WSL2, Ubuntu, Docker Desktop, MongoDB Compass)
4. Remove temporary installer files

See each sub-script's README for the full list of installed packages.

---

## How to run

One-line (PowerShell as Administrator):

```powershell
iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/IntiCerda/Script-Dev-W10-W11/main/Complete%20Development%20Setup/setup-dev-complete.ps1'))
```

From disk:

```powershell
& ".\Complete Development Setup\setup-dev-complete.ps1"
```

Output is logged to `%TEMP%\setup-dev-complete-<timestamp>.log`.

---

## Requirements

- Windows 10 or 11
- Administrator privileges
- Internet connection
- Virtualization enabled in BIOS (required for WSL2 and Docker Desktop)
