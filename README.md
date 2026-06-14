# Dev Environment Setup — Windows 10/11

![PowerShell](https://img.shields.io/badge/PowerShell-5.1%2B-blue?logo=powershell&logoColor=white)
![Windows](https://img.shields.io/badge/Windows-10%20%7C%2011-0078D6?logo=windows&logoColor=white)
![winget](https://img.shields.io/badge/winget-required-informational)
![License](https://img.shields.io/badge/license-MIT-green)

> Automated PowerShell scripts to provision a complete developer environment on Windows 10/11 in a single run — idempotent, modular, and admin-safe.

---

## Quick Start

Open PowerShell **as Administrator** and run:

```powershell
# Full setup (tools + languages + Docker + WSL2) — recommended
iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/IntiCerda/Script-Dev-W10-W11/main/Complete%20Development%20Setup/setup-dev-complete.ps1'))
```

Or run individual scripts from disk:

```powershell
# Tools and languages only
& ".\Basic Development Setup\setup-dev.ps1"

# Docker + WSL2 only
& ".\Docker and WSL Setup\setup-docker-wsl.ps1"

# Full setup from disk
& ".\Complete Development Setup\setup-dev-complete.ps1"
```

Each script logs everything to a timestamped file in `%TEMP%`.

---

## What Gets Installed

### Tools & Languages

| Category        | Package                                                |
|-----------------|--------------------------------------------------------|
| Version Control | Git                                                    |
| Editor          | Visual Studio Code                                     |
| Terminal        | Windows Terminal                                       |
| CLI             | GitHub CLI (`gh`)                                      |
| Languages       | Go · Node.js LTS (via fnm) · Python 3.12 · Java 21 (Temurin) |
| API Testing     | Bruno (no account required)                            |
| Utilities       | jq · make (GnuWin32)                                   |
| Database GUI    | MongoDB Compass Community                              |
| Containers      | Docker Desktop (WSL2 backend)                          |
| Linux           | WSL2 + Ubuntu                                          |

### VSCode Extensions

| Extension         | Purpose                        |
|-------------------|--------------------------------|
| Go                | Go language support            |
| Python            | Python language support        |
| ESLint + Prettier | Linting and formatting         |
| Docker            | Container management           |
| MongoDB           | Database explorer              |
| GitLens           | Git history inline             |
| REST Client       | HTTP requests inside VSCode    |
| EditorConfig      | Cross-project code consistency |

---

## Scripts

### `setup-dev.ps1` — Basic Development Setup

Installs core tools, languages, dev utilities, and all VSCode extensions. Safe to re-run — skips anything already installed.

```
Basic Development Setup/
└── setup-dev.ps1
```

### `setup-docker-wsl.ps1` — Docker and WSL Setup

Enables WSL2 features, installs Ubuntu, and sets up Docker Desktop with the WSL2 backend. Detects architecture (AMD64/ARM64) and skips the Docker download if already installed. Also installs MongoDB Compass Community.

```
Docker and WSL Setup/
└── setup-docker-wsl.ps1
```

> **Before running:** verify that virtualization is enabled in BIOS.
> Check via **Task Manager → Performance → CPU → Virtualization: Enabled**.

### `setup-dev-complete.ps1` — Complete Setup ✦ Recommended

Orchestrates both scripts above in sequence. Also checks for winget and refreshes package sources before starting.

```
Complete Development Setup/
└── setup-dev-complete.ps1
```

---

## Requirements

| Requirement    | Details                                    |
|----------------|--------------------------------------------|
| OS             | Windows 10 or Windows 11                  |
| Privileges     | Administrator                              |
| Internet       | Required for package downloads             |
| Virtualization | Required for WSL2 and Docker Desktop       |

---

## Design

- **Idempotent** — re-running never breaks or duplicates an existing install
- **Modular** — run only what you need
- **Safe** — installs from official sources only (winget, Docker, Microsoft)
- **Logged** — full transcript saved to `%TEMP%` on every run
- **Arch-aware** — Docker installer auto-selects AMD64 or ARM64
- **Reboot detection** — warns if a pending restart may affect WSL2 activation

---

## Author

**Inti Cerda** · [github.com/IntiCerda](https://github.com/IntiCerda)
