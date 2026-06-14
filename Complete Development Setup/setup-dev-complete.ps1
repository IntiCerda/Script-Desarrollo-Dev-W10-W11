# Complete Development Setup -- orchestrates setup-dev.ps1 and setup-docker-wsl.ps1.

if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Error "Run this script as Administrator."; exit 1
}

$LogFile = "$env:TEMP\setup-dev-complete-$(Get-Date -Format 'yyyyMMdd-HHmmss').log"
Start-Transcript -Path $LogFile -Append
Write-Host "Log saved to: $LogFile" -ForegroundColor DarkGray

Set-ExecutionPolicy RemoteSigned -Scope Process -Force

$script:Step  = 0
$script:Total = 4
function Write-Step([string]$Msg) {
    $script:Step++
    Write-Host "[$script:Step/$script:Total] $Msg" -ForegroundColor Cyan
}

# When run via iex, $PSScriptRoot is empty -- sub-scripts are downloaded to %TEMP%.
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
    Unblock-File $TempDev
    Unblock-File $TempDocker
    $DevScript    = $TempDev
    $DockerScript = $TempDocker
    $CleanupTemps = $true
}

Write-Host "Starting Complete Development Setup..." -ForegroundColor Cyan

Write-Step "Checking and updating winget..."
if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    Write-Host "  winget not detected. Installing manually..." -ForegroundColor Yellow
    Invoke-WebRequest -UseBasicParsing -Uri "https://aka.ms/getwinget" -OutFile "$env:TEMP\Microsoft.DesktopAppInstaller.appxbundle"
    Add-AppxPackage "$env:TEMP\Microsoft.DesktopAppInstaller.appxbundle"
}
winget source update --accept-source-agreements

Write-Step "Running Basic Development Setup..."
& $DevScript -Orchestrated

Write-Step "Running Docker and WSL Setup..."
& $DockerScript -Orchestrated

Write-Step "Final cleanup..."
Remove-Item "$env:TEMP\Microsoft.DesktopAppInstaller.appxbundle" -Force -ErrorAction SilentlyContinue
if ($CleanupTemps) {
    Remove-Item $TempDev    -Force -ErrorAction SilentlyContinue
    Remove-Item $TempDocker -Force -ErrorAction SilentlyContinue
}

Write-Host "Complete Development Setup finished." -ForegroundColor Green
Write-Host "Restart the system to apply all changes." -ForegroundColor Yellow

Stop-Transcript
