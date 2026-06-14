# Basic Development Setup

Installs core tools, languages, dev utilities, and VS Code extensions on Windows 10/11.
Safe to re-run — already-installed packages are skipped.

## What gets installed

**Core tools** (winget)

| Package | winget ID |
|---------|-----------|
| Git | `Git.Git` |
| Visual Studio Code | `Microsoft.VisualStudioCode` |
| Windows Terminal | `Microsoft.WindowsTerminal` |
| GitHub CLI | `GitHub.cli` |

**Languages**

| Package | winget ID |
|---------|-----------|
| Go | `GoLang.Go` |
| fnm (Node version manager) | `Schniz.fnm` |
| Node.js LTS | `fnm install --lts` |
| Python 3.12 | `Python.Python.3.12` |
| Java 21 (Temurin JDK) | `Eclipse.Adoptium.Temurin.21.JDK` |

**Dev utilities**

| Package | winget ID |
|---------|-----------|
| Bruno (API client) | `Bruno.Bruno` |
| jq | `jqlang.jq` |
| make | `GnuWin32.Make` |

**VS Code extensions**

`ms-vscode.Go` · `dbaeumer.vscode-eslint` · `esbenp.prettier-vscode` · `ms-python.python` · `ms-azuretools.vscode-docker` · `mongodb.mongodb-vscode` · `eamodio.gitlens` · `humao.rest-client` · `EditorConfig.EditorConfig`

**Environment**

Adds `%USERPROFILE%\go\bin` to the user PATH if not already present.

---

## How to run

One-line (PowerShell as Administrator):

```powershell
iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/IntiCerda/Script-Dev-W10-W11/main/Basic%20Development%20Setup/setup-dev.ps1'))
```

From disk:

```powershell
& ".\Basic Development Setup\setup-dev.ps1"
```

Output is logged to `%TEMP%\setup-dev-<timestamp>.log`.
