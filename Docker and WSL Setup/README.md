# Docker and WSL Setup — Windows 10/11

## Description

This PowerShell script automates the full installation and configuration of **WSL2** and **Docker Desktop** on Windows 10 or 11, along with **MongoDB Compass Community**.

---

## What the Script Does

1. **Enables WSL2 features** — activates Windows Subsystem for Linux and Virtual Machine Platform via `dism.exe`, and runs `wsl --update` to install the latest kernel.
2. **Sets WSL2 as default** — ensures new Linux distros use WSL2.
3. **Installs Ubuntu** — installs the latest Ubuntu from the Microsoft Store.
4. **Reboot check** — warns if a pending restart may prevent WSL2 from activating.
5. **Installs Docker Desktop** — detects architecture (AMD64 or ARM64) and downloads the correct installer. Skips if already installed.
6. **Configures Docker for WSL2** — switches Docker to the Linux/WSL2 engine.
7. **Installs MongoDB Compass Community** — GUI for MongoDB management.

---

## Installed Components

| Component                             | Description                                             | Source          |
| ------------------------------------- | ------------------------------------------------------- | --------------- |
| **Windows Subsystem for Linux (WSL)** | Enables running Linux directly on Windows.              | Microsoft       |
| **Virtual Machine Platform**          | Required for WSL2 virtualization.                       | Microsoft       |
| **Ubuntu**                            | Default Linux distribution installed under WSL2.        | Microsoft Store |
| **Docker Desktop**                    | Container management platform with WSL2 backend.        | Docker Inc.     |
| **MongoDB Compass Community**         | GUI for managing and querying MongoDB databases.        | winget          |

---

## Requirements

- Windows 10 or 11
- Administrator privileges
- Virtualization enabled in BIOS (VT-x / AMD-V)
- Internet connection

> Check via **Task Manager → Performance → CPU → Virtualization: Enabled**.

---

## How to Run

### One-line execution (recommended)

Open PowerShell **as Administrator** and run:

```powershell
iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/IntiCerda/Script-Dev-W10-W11/main/Docker%20and%20WSL%20Setup/setup-docker-wsl.ps1'))
```

### Manual download and execution

```powershell
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/IntiCerda/Script-Dev-W10-W11/main/Docker%20and%20WSL%20Setup/setup-docker-wsl.ps1" -OutFile "$env:USERPROFILE\Downloads\setup-docker-wsl.ps1"
powershell -ExecutionPolicy Bypass -File "$env:USERPROFILE\Downloads\setup-docker-wsl.ps1"
```

### From disk (after cloning the repo)

```powershell
& ".\Docker and WSL Setup\setup-docker-wsl.ps1"
```

---

## Post-Installation

After the script completes, **restart your computer**, then verify:

```powershell
wsl --status
docker version
```

Once restarted, Docker Desktop and Ubuntu will be available from the Start Menu.
