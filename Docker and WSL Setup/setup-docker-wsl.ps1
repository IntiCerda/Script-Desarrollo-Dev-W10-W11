param([switch]$Orchestrated)
# Docker and WSL Setup -- enables WSL2, installs Ubuntu, Docker Desktop, and MongoDB Compass.
# Pass -Orchestrated when called from setup-dev-complete.ps1.

$script:Step  = 0
$script:Total = 5
function Write-Step([string]$Msg) {
    $script:Step++
    Write-Host "[$script:Step/$script:Total] $Msg" -ForegroundColor Cyan
}

function Test-RebootPending {
    if (Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\RebootPending") { return $true }
    if (Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\RebootRequired") { return $true }
    $pfro = Get-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager" `
        -Name "PendingFileRenameOperations" -ErrorAction SilentlyContinue
    return ($null -ne $pfro)
}

function Install-WingetPackage {
    param([string]$Id, [string]$Source = "winget")
    $check = winget list --id $Id --exact --accept-source-agreements 2>$null | Select-String ([regex]::Escape($Id))
    if ($check) {
        Write-Host "  $Id already installed, skipping." -ForegroundColor DarkGray
    } else {
        winget install --id $Id -e --source $Source --silent --accept-source-agreements --accept-package-agreements
    }
}

if (-not $Orchestrated) {
    if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
        Write-Error "Run this script as Administrator."; exit 1
    }
    $LogFile = "$env:TEMP\setup-docker-wsl-$(Get-Date -Format 'yyyyMMdd-HHmmss').log"
    Start-Transcript -Path $LogFile -Append
    Write-Host "Log saved to: $LogFile" -ForegroundColor DarkGray
}

Write-Host "Starting Docker and WSL Setup..." -ForegroundColor Cyan

Write-Step "Enabling WSL2 features..."
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart

# wsl --update must run before --set-default-version to avoid kernel errors on older Windows 10 builds
wsl --update
wsl --set-default-version 2

if (Test-RebootPending) {
    Write-Warning "A system restart is pending. WSL2 and Docker may not work correctly until you restart."
    if (-not $Orchestrated) {
        $response = Read-Host "Continue anyway? (y/N)"
        if ($response -notmatch '^[yY]$') {
            Write-Host "Exiting. Restart and run the script again." -ForegroundColor Yellow
            Stop-Transcript; exit 0
        }
    } else {
        Write-Host "  Continuing in orchestrated mode -- restart after the full setup completes." -ForegroundColor Yellow
    }
}

Write-Step "Installing Ubuntu..."
wsl --install -d Ubuntu

Write-Step "Installing Docker Desktop..."
$vmp = Get-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform -ErrorAction SilentlyContinue
if ($vmp -and $vmp.State -ne 'Enabled') {
    Write-Warning "Virtual Machine Platform is not yet enabled (may need a restart). Docker Desktop may fail to start."
}
$hvAll = Get-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V-All -ErrorAction SilentlyContinue
if ($hvAll -and $hvAll.State -ne 'Enabled') {
    Write-Host "  Hyper-V not enabled -- Docker will use WSL2 backend (this is fine)." -ForegroundColor DarkGray
}

$dockerCheck = winget list --id Docker.DockerDesktop --exact --accept-source-agreements 2>$null | Select-String "Docker.DockerDesktop"
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

Write-Step "Configuring Docker for WSL2..."
try {
    & "$env:ProgramFiles\Docker\Docker\DockerCli.exe" -SwitchLinuxEngine
} catch {
    Write-Host "  Could not configure Docker CLI (may require a restart)." -ForegroundColor Yellow
}

Write-Step "Installing MongoDB Compass Community..."
Install-WingetPackage "MongoDB.Compass.Community"

Write-Host "Docker and WSL Setup completed." -ForegroundColor Green
Write-Host "Restart your system to apply all changes." -ForegroundColor Yellow

if (-not $Orchestrated) { Stop-Transcript }
