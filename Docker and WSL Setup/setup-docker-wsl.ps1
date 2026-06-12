param([switch]$Orchestrated)
# ----------------------------------------
# Docker and WSL Setup
# This script installs and configures WSL2 and Docker Desktop
# on Windows 10/11.
# Actions:
# - Turn on WSL2 features (Windows Subsystem for Linux and Virtual Machine Platform)
# - Set WSL2 as the default version
# - Install Ubuntu under WSL
# - Download and install Docker Desktop (detects AMD64 or ARM64), skips if already installed
# - Try to set Docker to use WSL2 (may need restart)
# Pass -Orchestrated when called from setup-dev-complete.ps1 to skip admin check and transcript.
# ----------------------------------------

# ---- Step counter ----
$script:Step  = 0
$script:Total = 4
function Write-Step([string]$Msg) {
    $script:Step++
    Write-Host "[$script:Step/$script:Total] $Msg" -ForegroundColor Cyan
}

# ---- Helper: detect pending reboot ----
function Test-RebootPending {
    if (Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\RebootPending") { return $true }
    if (Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\RebootRequired") { return $true }
    $pfro = Get-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager" `
        -Name "PendingFileRenameOperations" -ErrorAction SilentlyContinue
    return ($null -ne $pfro)
}

# ---- Admin check + transcript (standalone only) ----
if (-not $Orchestrated) {
    if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
        Write-Error "Run this script as Administrator."; exit 1
    }
    $LogFile = "$env:TEMP\setup-docker-wsl-$(Get-Date -Format 'yyyyMMdd-HHmmss').log"
    Start-Transcript -Path $LogFile -Append
    Write-Host "Log saved to: $LogFile" -ForegroundColor DarkGray
}

Write-Host "Starting Docker and WSL Setup..." -ForegroundColor Cyan

# ---- [1/4] WSL2 features ----
Write-Step "Enabling WSL2 features..."
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
wsl --set-default-version 2

# Reboot check after dism — WSL2 may not activate until restarted
if (Test-RebootPending) {
    Write-Warning "A system restart is pending. WSL2 and Docker may not work correctly until you restart."
    if (-not $Orchestrated) {
        $response = Read-Host "Continue anyway? (y/N)"
        if ($response -notmatch '^[yY]$') {
            Write-Host "Exiting. Restart and run the script again." -ForegroundColor Yellow
            Stop-Transcript; exit 0
        }
    } else {
        Write-Host "  Continuing in orchestrated mode — restart after the full setup completes." -ForegroundColor Yellow
    }
}

# ---- [2/4] Ubuntu ----
Write-Step "Installing Ubuntu..."
wsl --install -d Ubuntu

# ---- [3/4] Docker Desktop ----
Write-Step "Installing Docker Desktop..."
$dockerCheck = winget list --id Docker.DockerDesktop --exact 2>$null | Select-String "Docker.DockerDesktop"
if ($dockerCheck) {
    Write-Host "  Docker Desktop already installed, skipping download." -ForegroundColor DarkGray
} else {
    $arch      = (Get-CimInstance Win32_Processor).Architecture
    $dockerUrl = if ($arch -eq 12) {
        "https://desktop.docker.com/win/main/arm64/Docker%20Desktop%20Installer.exe"
    } else {
        "https://desktop.docker.com/win/main/amd64/Docker%20Desktop%20Installer.exe"
    }
    Write-Host "  Architecture: $(if ($arch -eq 12) { 'ARM64' } else { 'AMD64' })" -ForegroundColor DarkGray
    $dockerInstaller = "$env:TEMP\DockerDesktopInstaller.exe"
    Invoke-WebRequest -UseBasicParsing -Uri $dockerUrl -OutFile $dockerInstaller
    Start-Process -Wait -FilePath $dockerInstaller -ArgumentList "install", "--quiet"
    Remove-Item $dockerInstaller -Force
}

# ---- [4/4] Configure Docker for WSL2 ----
Write-Step "Configuring Docker for WSL2..."
try {
    & "$env:ProgramFiles\Docker\Docker\DockerCli.exe" -SwitchLinuxEngine
} catch {
    Write-Host "  Could not configure Docker CLI (may require a restart)." -ForegroundColor Yellow
}

Write-Host "✅ Docker and WSL Setup completed." -ForegroundColor Green
Write-Host "Restart your system to apply all changes." -ForegroundColor Yellow

if (-not $Orchestrated) { Stop-Transcript }
