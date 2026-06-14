# Docker and WSL Setup

Enables WSL2, installs Ubuntu, sets up Docker Desktop, and installs MongoDB Compass Community on Windows 10/11.
Safe to re-run — Docker Desktop download is skipped if already installed.

## What gets installed

| Component | Source |
|-----------|--------|
| WSL2 (Windows Subsystem for Linux) | `dism.exe` |
| Virtual Machine Platform | `dism.exe` |
| Ubuntu | `wsl --install -d Ubuntu` |
| Docker Desktop (AMD64 or ARM64) | docker.com |
| MongoDB Compass Community | winget `MongoDB.Compass.Community` |

## Steps

1. Enable WSL2 and Virtual Machine Platform via `dism.exe`
2. Update WSL2 kernel (`wsl --update`) and set default version to 2
3. Check for pending reboot — warns before continuing if one is detected
4. Install Ubuntu
5. Check Hyper-V / VMP prerequisites, then install Docker Desktop (skips if already installed)
6. Configure Docker to use the WSL2 backend
7. Install MongoDB Compass Community

---

## How to run

One-line (PowerShell as Administrator):

```powershell
iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/IntiCerda/Script-Dev-W10-W11/main/Docker%20and%20WSL%20Setup/setup-docker-wsl.ps1'))
```

From disk:

```powershell
& ".\Docker and WSL Setup\setup-docker-wsl.ps1"
```

Output is logged to `%TEMP%\setup-docker-wsl-<timestamp>.log`.

---

## Requirements

- Windows 10 or 11
- Administrator privileges
- Virtualization enabled in BIOS (VT-x / AMD-V)

After the script completes, restart your computer, then verify:

```powershell
wsl --status
docker version
```
