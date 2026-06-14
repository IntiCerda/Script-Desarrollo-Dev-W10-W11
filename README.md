# Dev Environment Setup — Windows 10/11

Automated PowerShell scripts to provision a complete developer environment on Windows 10/11. Idempotent and modular — safe to re-run, installs only what is missing.

---

## Quick start

Open PowerShell **as Administrator** and run:

```powershell
iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/IntiCerda/Script-Dev-W10-W11/main/Complete%20Development%20Setup/setup-dev-complete.ps1'))
```

Or run individual scripts from disk after cloning:

```powershell
& ".\Basic Development Setup\setup-dev.ps1"
& ".\Docker and WSL Setup\setup-docker-wsl.ps1"
& ".\Complete Development Setup\setup-dev-complete.ps1"
```

---

## What gets installed

| Category        | Package                                                     |
|-----------------|-------------------------------------------------------------|
| Version control | Git                                                         |
| Editor          | Visual Studio Code                                          |
| Terminal        | Windows Terminal                                            |
| CLI             | GitHub CLI                                                  |
| Languages       | Go · Node.js LTS (via fnm) · Python 3.12 · Java 21 Temurin |
| API client      | Bruno                                                       |
| Utilities       | jq · make (GnuWin32)                                        |
| Database GUI    | MongoDB Compass Community                                   |
| Containers      | Docker Desktop (WSL2 backend)                               |
| Linux           | WSL2 + Ubuntu                                               |

VS Code extensions: Go, ESLint, Prettier, Python, Docker, MongoDB, GitLens, REST Client, EditorConfig.

---

## Scripts

| Script | Description |
|--------|-------------|
| `Basic Development Setup/setup-dev.ps1` | Tools, languages, and VS Code extensions |
| `Docker and WSL Setup/setup-docker-wsl.ps1` | WSL2, Ubuntu, Docker Desktop, MongoDB Compass |
| `Complete Development Setup/setup-dev-complete.ps1` | Orchestrates both scripts above |

All scripts log output to a timestamped file in `%TEMP%`. Requires administrator privileges and an internet connection. Virtualization must be enabled in BIOS for WSL2 and Docker.

---

**Inti Cerda** · [github.com/IntiCerda](https://github.com/IntiCerda)
