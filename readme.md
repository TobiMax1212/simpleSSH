# simpleSSH

A lightweight, terminal-based SSH connection manager written in PowerShell. Store, list, connect to, and remove SSH connections through an interactive CLI menu, with profiles persisted to a local JSON config file.

## Description

simpleSSH provides a menu-driven interface for managing frequently used SSH connections, aimed at homelab environments such as Proxmox nodes, Raspberry Pis, or Docker hosts. Connection profiles (name, username, host, port) are stored in `data/config.json`, which is created automatically on first run.

## Prerequisites

- PowerShell 5.1 or newer (PowerShell Core 7+ recommended)
- OpenSSH client installed and available on `PATH`

## Installation

```powershell
git clone https://github.com/TobiMax1212/simpleSSH.git
cd simpleSSH
```

Ensure your PowerShell execution policy allows local scripts to run:

```powershell
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
```

## Usage

Run the script from the project root:

```powershell
.\simpleSSH.ps1
```

On first run, the script creates `data/config.json` with an empty connection list.

### Menu options

```
1. Add a new SSH connection
2. List all SSH connections
3. Connect to an SSH server
4. Remove an SSH connection
5. Exit
```

- **Add**: prompts for name, username, host, and optional port (default 22). Optionally assigns a menu shortcut (6-9) for quick access.
- **List**: displays all stored connections.
- **Connect**: select a stored connection to open an SSH session.
- **Remove**: select a stored connection to delete it from the config.
- **Exit**: exits the script. `Ctrl+C` also exits at any time.

## Configuration

Connections are stored in `data/config.json`:

```json
{
  "Connections": [],
  "Menu-Settings": []
}
```

This file is excluded from version control via `.gitignore`. Use `data/example_config.json` as a reference for the expected structure.

## Project structure

```
simpleSSH/
├── simpleSSH.ps1          # Main script
├── data/
│   ├── config.json        # Local connection profiles (gitignored)
│   └── example_config.json
├── .github/                # Workflow definitions
└── .vscode/                 # Editor settings (gitignored)
```

## Roadmap

- Shortcut feature for fast SSH connection within the menu
- Output all available devices within the network
- Copy / export the JSON config from within the menu
- Refine the GitHub Actions workflow
- Fix backend save function for SSH connections

## Author

TobiMax1212
