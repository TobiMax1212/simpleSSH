# simpleSSH Manager

A lightweight, terminal-based SSH connection manager written entirely in PowerShell. 

**simpleSSH** provides a clean, interactive Command Line Interface (CLI) to store, manage, and quickly connect to your frequently used SSH servers. It's the perfect companion for managing homelab environments (like Proxmox nodes, Raspberry Pis, or Docker hosts) without needing heavy GUI applications.

---

## Features

* **Interactive CLI Menu:** Clean, color-coded terminal interface.
* **CRUD Functionality:** Easily add, list, connect to, or remove SSH connections.
* **Dynamic JSON Storage:** All connection profiles are saved to a local `config.json` file.
* **Custom Port Support:** Define specific ports for each connection to handle non-standard setups.
* **Self-Healing Config:** Automatically generates the required directory structure and configuration files on the first run.

---

## Installation & Usage

1. **Clone the repository:**
   ```powershell
   git clone https://github.com/TobiMax1212/simpleSSH.git
   cd simpleSSH

    Run the script:
    Execute the script in your PowerShell console.
    PowerShell

    .\simpleSSH.ps1

    (Note: Ensure your PowerShell execution policy allows the running of local scripts.)

    Prerequisites:

        PowerShell 5.1 or newer (PowerShell Core 7+ recommended).

        OpenSSH Client installed on your system (usually pre-installed on Windows 10/11 and standard Linux distributions).

Roadmap / To-Do

    [ Shortcut feature for fast SHH connection within the menu ]

    [ Getting the script in a loop ]

    [ Output all available devices within the network ]

    [ Copy / Export the json config within the menu ]


Author

Created by TobiMax1212