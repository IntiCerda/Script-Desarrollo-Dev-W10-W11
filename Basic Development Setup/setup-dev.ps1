param([switch]$Orchestrated)
# ----------------------------------------
# Basic Development Setup
# This script installs a basic development environment
# for Windows 10/11 using winget.
# Actions:
# - Install core tools: Git, Visual Studio Code, Windows Terminal, GitHub CLI
# - Install languages: Go, Node.js (LTS), Python, Java (Temurin JDK)
# - Install tools: Postman, MongoDB Compass (Community)
# - Install VS Code extensions: Go, ESLint, Prettier, Python, Docker, MongoDB, GitLens, REST Client, EditorConfig, themes, bracket helpers
# - Add %USERPROFILE%\go\bin to the user PATH (only if not already present)
# Pass -Orchestrated when called from setup-dev-complete.ps1 to skip admin check and transcript.
# ----------------------------------------

# ---- Versions (edit here to upgrade) ----
$PythonVersion = "3.12"
$JavaVersion   = "21"

# ---- Step counter ----
$script:Step  = 0
$script:Total = 5
function Write-Step([string]$Msg) {
    $script:Step++
    Write-Host "[$script:Step/$script:Total] $Msg" -ForegroundColor Cyan
}

# ---- Admin check + transcript (standalone only) ----
if (-not $Orchestrated) {
    if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
        Write-Error "Run this script as Administrator."; exit 1
    }
    $LogFile = "$env:TEMP\setup-dev-$(Get-Date -Format 'yyyyMMdd-HHmmss').log"
    Start-Transcript -Path $LogFile -Append
    Write-Host "Log saved to: $LogFile" -ForegroundColor DarkGray
}

Write-Host "Starting Basic Development Setup..." -ForegroundColor Cyan

# ---- Helper: install only if not already present ----
function Install-WingetPackage {
    param([string]$Id, [string]$Source = "winget")
    $check = winget list --id $Id --exact 2>$null | Select-String ([regex]::Escape($Id))
    if ($check) {
        Write-Host "  $Id already installed, skipping." -ForegroundColor DarkGray
    } else {
        winget install --id $Id -e --source $Source --accept-source-agreements --accept-package-agreements
    }
}

# ---- [1/5] Core tools ----
Write-Step "Installing core tools (Git, VSCode, Windows Terminal, GitHub CLI)..."
Install-WingetPackage "Git.Git"
Install-WingetPackage "Microsoft.VisualStudioCode"
Install-WingetPackage "Microsoft.WindowsTerminal"
Install-WingetPackage "GitHub.cli"

# ---- [2/5] Languages ----
Write-Step "Installing languages (Go, Node.js LTS, Python $PythonVersion, Java $JavaVersion)..."
Install-WingetPackage "GoLang.Go"
Install-WingetPackage "OpenJS.NodeJS.LTS"
Install-WingetPackage "Python.Python.$PythonVersion"
Install-WingetPackage "Eclipse.Adoptium.Temurin.$JavaVersion.JDK"

# ---- [3/5] Dev tools ----
Write-Step "Installing dev tools (Postman, MongoDB Compass)..."
Install-WingetPackage "Postman.Postman"
Install-WingetPackage "MongoDB.Compass.Community"

# ---- [4/5] VSCode extensions ----
Write-Step "Installing VSCode extensions (13)..."
code --install-extension ms-vscode.Go
code --install-extension dbaeumer.vscode-eslint
code --install-extension esbenp.prettier-vscode
code --install-extension ms-python.python
code --install-extension ms-azuretools.vscode-docker
code --install-extension mongodb.mongodb-vscode
code --install-extension SirTori.indenticator
code --install-extension PKief.material-icon-theme
code --install-extension whizkydee.material-palenight-theme
code --install-extension rafamel.subtle-brackets
code --install-extension eamodio.gitlens
code --install-extension humao.rest-client
code --install-extension EditorConfig.EditorConfig

# ---- [5/5] Environment variables ----
Write-Step "Configuring Go PATH..."
$goPath     = "$env:USERPROFILE\go\bin"
$currentPath = [Environment]::GetEnvironmentVariable("Path", "User")
if ($currentPath -notlike "*$goPath*") {
    [Environment]::SetEnvironmentVariable("Path", "$currentPath;$goPath", "User")
    Write-Host "  Added $goPath to user PATH." -ForegroundColor DarkGray
} else {
    Write-Host "  Go bin already in PATH, skipping." -ForegroundColor DarkGray
}

Write-Host "✅ Basic Development Setup completed." -ForegroundColor Green

if (-not $Orchestrated) { Stop-Transcript }
