# ----------------------------------------
# Complete Development Setup
# Orchestrates setup-dev.ps1 and setup-docker-wsl.ps1 in sequence.
# Actions:
# - Verify administrator privileges
# - Log all output to a timestamped file in %TEMP%
# - Install winget if missing and refresh package sources
# - Run Basic Development Setup   (setup-dev.ps1)
# - Run Docker and WSL Setup      (setup-docker-wsl.ps1)
# - Clean temporary files
#
# Can be run from disk OR via iex from URL — both work.
# ----------------------------------------

# ---- Admin check ----
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Error "Run this script as Administrator."; exit 1
}

# ---- Transcript ----
$LogFile = "$env:TEMP\setup-dev-complete-$(Get-Date -Format 'yyyyMMdd-HHmmss').log"
Start-Transcript -Path $LogFile -Append
Write-Host "Log saved to: $LogFile" -ForegroundColor DarkGray

Set-ExecutionPolicy RemoteSigned -Scope Process -Force

# ---- Step counter ----
$script:Step  = 0
$script:Total = 4
function Write-Step([string]$Msg) {
    $script:Step++
    Write-Host "[$script:Step/$script:Total] $Msg" -ForegroundColor Cyan
}

# ---- Resolve sub-script paths (disk or iex/URL) ----
# When run via iex, $PSScriptRoot is empty — download sub-scripts to %TEMP%.
$BaseUrl      = "https://raw.githubusercontent.com/IntiCerda/Script-Dev-W10-W11/main"
$TempDev      = "$env:TEMP\setup-dev.ps1"
$TempDocker   = "$env:TEMP\setup-docker-wsl.ps1"
$CleanupTemps = $false

if ($PSScriptRoot) {
    $DevScript    = "$PSScriptRoot\..\Basic Development Setup\setup-dev.ps1"
    $DockerScript = "$PSScriptRoot\..\Docker and WSL Setup\setup-docker-wsl.ps1"
} else {
    Write-Host "  Running from URL -- downloading sub-scripts to TEMP..." -ForegroundColor DarkGray
    Invoke-WebRequest -UseBasicParsing -Uri "$BaseUrl/Basic%20Development%20Setup/setup-dev.ps1"      -OutFile $TempDev
    Invoke-WebRequest -UseBasicParsing -Uri "$BaseUrl/Docker%20and%20WSL%20Setup/setup-docker-wsl.ps1" -OutFile $TempDocker
    $DevScript    = $TempDev
    $DockerScript = $TempDocker
    $CleanupTemps = $true
}

Write-Host "Starting Complete Development Setup..." -ForegroundColor Cyan

# ---- [1/4] Winget ----
Write-Step "Checking and updating winget..."
if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    Write-Host "  winget not detected. Installing manually..." -ForegroundColor Yellow
    Invoke-WebRequest -UseBasicParsing -Uri "https://aka.ms/getwinget" -OutFile "$env:TEMP\Microsoft.DesktopAppInstaller.appxbundle"
    Add-AppxPackage "$env:TEMP\Microsoft.DesktopAppInstaller.appxbundle"
}
winget source update

# ---- [2/4] Basic development setup ----
Write-Step "Running Basic Development Setup..."
& $DevScript -Orchestrated

# ---- [3/4] Docker and WSL setup ----
Write-Step "Running Docker and WSL Setup..."
& $DockerScript -Orchestrated

# ---- [4/4] Cleanup ----
Write-Step "Final cleanup..."
Remove-Item "$env:TEMP\Microsoft.DesktopAppInstaller.appxbundle" -Force -ErrorAction SilentlyContinue
if ($CleanupTemps) {
    Remove-Item $TempDev    -Force -ErrorAction SilentlyContinue
    Remove-Item $TempDocker -Force -ErrorAction SilentlyContinue
}

Write-Host "✅ Complete Development Setup finished." -ForegroundColor Green
Write-Host "Restart the system to apply all changes." -ForegroundColor Yellow

Stop-Transcript
