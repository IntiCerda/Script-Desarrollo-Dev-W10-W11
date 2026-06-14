# Basic Development Setup — Windows 10/11

## Description

The **Basic Development Setup** PowerShell script automates the installation of a complete development environment on **Windows 10/11** using **Winget** and **VS Code extensions**.

It is designed for backend, frontend, and full-stack developers — focusing on productivity, language tooling, and code quality.

The script installs:

- **Core tools** (Git, VS Code, Windows Terminal, GitHub CLI)
- **Programming languages and runtimes** (Go, Node.js LTS via fnm, Python, Java)
- **Development utilities** (Bruno, jq, make)
- **VSCode extensions** for linting, formatting, and productivity
- **Environment variable setup** to ensure the Go toolchain is properly configured

---

### 1. Core Tools

Installs essential developer tools using **Winget**:

- **Git** — version control system for source code management.
- **Visual Studio Code** — lightweight, powerful source code editor.
- **Windows Terminal** — modern terminal with tabs and customization.
- **GitHub CLI (`gh`)** — manage GitHub repos, PRs, and issues from the command line.

### 2. Language Runtimes

Installs popular programming languages and their runtimes:

- **Go (GoLang)** — compiled language for backend and microservices.
- **fnm + Node.js LTS** — fast Node version manager; installs LTS automatically.
- **Python 3.12** — interpreted language for scripting, automation, and data science.
- **Java (Temurin 21 JDK)** — cross-platform language for enterprise and Android development.

### 3. Development Utilities

Installs additional tools:

- **Bruno** — open-source API client, no account required.
- **jq** — command-line JSON processor.
- **make (GnuWin32)** — build automation tool.

### 4. VSCode Extensions

| Extension                     | ID                                   | Purpose                                                             |
| ----------------------------- | ------------------------------------ | ------------------------------------------------------------------- |
| **Go**                        | `ms-vscode.Go`                       | IntelliSense, debugging, and code navigation for Go.               |
| **ESLint**                    | `dbaeumer.vscode-eslint`             | JavaScript/TypeScript linting.                                      |
| **Prettier**                  | `esbenp.prettier-vscode`             | Auto-formats code across multiple languages.                        |
| **Python**                    | `ms-python.python`                   | Python language support, linting, and debugging.                    |
| **Docker**                    | `ms-azuretools.vscode-docker`        | Dockerfile syntax highlighting and container management.            |
| **MongoDB for VSCode**        | `mongodb.mongodb-vscode`             | MongoDB connections and queries directly in VSCode.                 |
| **GitLens**                   | `eamodio.gitlens`                    | Git history, blame, and authorship inline.                          |
| **REST Client**               | `humao.rest-client`                  | HTTP requests directly in `.http` files.                            |
| **EditorConfig**              | `EditorConfig.EditorConfig`          | Enforces cross-project code formatting rules.                       |

### 5. Environment Configuration

Adds the Go binary path (`%USERPROFILE%\go\bin`) to the user's **PATH** so the `go` command is recognized globally. Skips if already present.

---

## Requirements

- Windows 10 or 11
- **Winget** installed (included by default on recent Windows versions)
- PowerShell 5.1+
- Administrator privileges

---

## How to Run

### One-line execution (recommended)

```powershell
iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/IntiCerda/Script-Dev-W10-W11/main/Basic%20Development%20Setup/setup-dev.ps1'))
```

### Manual download and execution

```powershell
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/IntiCerda/Script-Dev-W10-W11/main/Basic%20Development%20Setup/setup-dev.ps1" -OutFile "$env:USERPROFILE\Downloads\setup-dev.ps1"
powershell -ExecutionPolicy Bypass -File "$env:USERPROFILE\Downloads\setup-dev.ps1"
```

---

## Summary of Installed Components

| Category             | Name               | Installer / Source                               | Description                       |
| -------------------- | ------------------ | ------------------------------------------------ | --------------------------------- |
| **Tool**             | Git                | `winget install Git.Git`                         | Source code version control       |
| **Tool**             | Visual Studio Code | `winget install Microsoft.VisualStudioCode`      | Main development editor           |
| **Tool**             | Windows Terminal   | `winget install Microsoft.WindowsTerminal`       | Modern terminal                   |
| **Tool**             | GitHub CLI         | `winget install GitHub.cli`                      | GitHub from the command line      |
| **Language**         | Go                 | `winget install GoLang.Go`                       | Compiled backend language         |
| **Language**         | fnm + Node.js LTS  | `winget install Schniz.fnm` + `fnm install --lts`| JavaScript runtime                |
| **Language**         | Python 3.12        | `winget install Python.Python.3.12`              | Scripting and automation          |
| **Language**         | Java (Temurin 21)  | `winget install Eclipse.Adoptium.Temurin.21.JDK` | JVM-based language                |
| **Dev Tool**         | Bruno              | `winget install Bruno.Bruno`                     | API testing (no account required) |
| **Dev Tool**         | jq                 | `winget install jqlang.jq`                       | JSON processor                    |
| **Dev Tool**         | make               | `winget install GnuWin32.Make`                   | Build automation                  |
| **VSCode Extension** | Go                 | `ms-vscode.Go`                                   | Go language support               |
| **VSCode Extension** | ESLint             | `dbaeumer.vscode-eslint`                         | JavaScript/TypeScript linting     |
| **VSCode Extension** | Prettier           | `esbenp.prettier-vscode`                         | Code formatting                   |
| **VSCode Extension** | Python             | `ms-python.python`                               | Python support                    |
| **VSCode Extension** | Docker             | `ms-azuretools.vscode-docker`                    | Docker integration                |
| **VSCode Extension** | MongoDB            | `mongodb.mongodb-vscode`                         | MongoDB integration               |
| **VSCode Extension** | GitLens            | `eamodio.gitlens`                                | Git history inline                |
| **VSCode Extension** | REST Client        | `humao.rest-client`                              | HTTP requests in editor           |
| **VSCode Extension** | EditorConfig       | `EditorConfig.EditorConfig`                      | Cross-project formatting          |

---
