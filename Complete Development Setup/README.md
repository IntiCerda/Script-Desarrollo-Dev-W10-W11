# Complete Development Setup — Windows 10/11

## Description

The **Complete Development Setup** script orchestrates `setup-dev.ps1` and `setup-docker-wsl.ps1` in sequence — giving you a full developer environment (tools, languages, WSL2, Docker, and MongoDB Compass) in a single run.

It also ensures **winget** is installed and refreshes package sources before starting.

---

## What the Script Does

1. **Checks for winget** — installs it if missing, then runs `winget source update`.
2. **Runs Basic Development Setup** — installs core tools, languages, dev utilities, and VS Code extensions.
3. **Runs Docker and WSL Setup** — enables WSL2, installs Ubuntu, installs Docker Desktop and MongoDB Compass Community.
4. **Cleans up** — removes temporary installer files.

See each sub-script's README for the full list of installed components:

- [`Basic Development Setup/README.md`](../Basic%20Development%20Setup/README.md)
- [`Docker and WSL Setup/README.md`](../Docker%20and%20WSL%20Setup/README.md)

---

## Requirements

| Requirement    | Details                                    |
|----------------|--------------------------------------------|
| OS             | Windows 10 or Windows 11                  |
| Privileges     | Administrator                              |
| Internet       | Required for package downloads             |
| Virtualization | Required for WSL2 and Docker Desktop       |

> **Before running:** enable virtualization in BIOS.
> Check via **Task Manager → Performance → CPU → Virtualization: Enabled**.

---

## How to Run

### One-line execution (recommended)

Open PowerShell **as Administrator** and run:

```powershell
iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/IntiCerda/Script-Dev-W10-W11/main/Complete%20Development%20Setup/setup-dev-complete.ps1'))
```

### Manual download and execution

```powershell
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/IntiCerda/Script-Dev-W10-W11/main/Complete%20Development%20Setup/setup-dev-complete.ps1" -OutFile "$env:USERPROFILE\Downloads\setup-dev-complete.ps1"
powershell -ExecutionPolicy Bypass -File "$env:USERPROFILE\Downloads\setup-dev-complete.ps1"
```

### From disk (after cloning the repo)

```powershell
& ".\Complete Development Setup\setup-dev-complete.ps1"
```

---

## Notes

- All output is logged to a timestamped file in `%TEMP%`.
- Scripts are idempotent — safe to re-run; already-installed packages are skipped.
- A system restart is required after setup to activate WSL2 and Docker Desktop.
