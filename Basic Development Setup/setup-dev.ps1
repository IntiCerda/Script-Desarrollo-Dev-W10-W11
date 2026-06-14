param([switch]$Orchestrated)
# ----------------------------------------
# Basic Development Setup
# This script installs a basic development environment
# for Windows 10/11 using winget.
# Actions:
# - Install core tools: Git, Visual Studio Code, Windows Terminal, GitHub CLI
# - Install languages: Go, fnm (Node version manager), Python, Java (Temurin JDK)
# - Install tools: Bruno (API client), jq, make
# - Install VS Code extensions: Go, ESLint, Prettier, Python, Docker, MongoDB, GitLens, REST Client, EditorConfig (9 total)
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
Write-Step "Installing languages (Go, fnm, Python $PythonVersion, Java $JavaVersion)..."
Install-WingetPackage "GoLang.Go"
Install-WingetPackage "Schniz.fnm"
Install-WingetPackage "Python.Python.$PythonVersion"
Install-WingetPackage "Eclipse.Adoptium.Temurin.$JavaVersion.JDK"

# Install LTS Node via fnm (refresh PATH first so fnm is available in this session)
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
if (Get-Command fnm -ErrorAction SilentlyContinue) {
    fnm install --lts
    Write-Host "  Node.js LTS installed via fnm." -ForegroundColor DarkGray
} else {
    Write-Host "  fnm installed -- run 'fnm install --lts' after restarting your terminal." -ForegroundColor Yellow
}

# ---- [3/5] Dev tools ----
Write-Step "Installing dev tools (Bruno, jq, make)..."
Install-WingetPackage "Bruno.Bruno"
Install-WingetPackage "jqlang.jq"
Install-WingetPackage "GnuWin32.Make"

# ---- [4/5] VSCode extensions ----
Write-Step "Installing VSCode extensions (9)..."
code --install-extension ms-vscode.Go
code --install-extension dbaeumer.vscode-eslint
code --install-extension esbenp.prettier-vscode
code --install-extension ms-python.python
code --install-extension ms-azuretools.vscode-docker
code --install-extension mongodb.mongodb-vscode
code --install-extension eamodio.gitlens
code --install-extension humao.rest-client
code --install-extension EditorConfig.EditorConfig

# ---- [5/5] Environment variables ----
Write-Step "Configuring Go PATH..."
$goPath      = "$env:USERPROFILE\go\bin"
$currentPath = [Environment]::GetEnvironmentVariable("Path", "User")
if ($currentPath -notlike "*$goPath*") {
    [Environment]::SetEnvironmentVariable("Path", "$currentPath;$goPath", "User")
    Write-Host "  Added $goPath to user PATH." -ForegroundColor DarkGray
} else {
    Write-Host "  Go bin already in PATH, skipping." -ForegroundColor DarkGray
}

Write-Host "✅ Basic Development Setup completed." -ForegroundColor Green

if (-not $Orchestrated) { Stop-Transcript }
