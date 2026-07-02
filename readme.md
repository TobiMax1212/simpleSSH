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
   ```

2. **Run the script:**
   Execute the script in your PowerShell console.
   ```powershell
   .\simpleSSH.ps1
   ```
   (Note: Ensure your PowerShell execution policy allows the running of local scripts.)

### Prerequisites

* PowerShell 5.1 or newer (PowerShell Core 7+ recommended).
* OpenSSH Client installed on your system (usually pre-installed on Windows 10/11 and standard Linux distributions).

---

## Usage Example

When you run `simpleSSH.ps1`, the script will display a menu with several options:

```
======================================================================
                           Welcome to the simpleSSH manager!            
======================================================================
                              version: 7.2.5                            
                             Author: TobiMax1212                        
======================================================================

 [i] Info:    This script will help you manage 
              your SSH connections easily.

 [?] Time:    2023-10-15 14:30:00

======================================================================
Please select an option:
1. Add a new SSH connection
2. List all SSH connections
3. Connect to an SSH server
4. Remove an SSH connection
5. Exit
You can exit also by pressing 'strg + c' or 'ctrl + c'.
======================================================================
Shortcuts: (Press the corresponding number to select an option)
======================================================================

[INFO] Config loaded successfully!
```

### Menu Options

1. **Add a new SSH connection**
   - Enter the name, username, host, and optionally a port for the SSH connection.
   
2. **List all SSH connections**
   - Displays all stored SSH connections.

3. **Connect to an SSH server**
   - Select a connection from the list to connect via SSH.
   
4. **Remove an SSH connection**
   - Remove a selected SSH connection from the configuration.

5. **Exit**
   - Exit the script after a short delay.

---

## Roadmap / To-Do

* [ ] Shortcut feature for fast SSH connection within the menu
* [ ] Output all available devices within the network
* [ ] Copy / Export the JSON config within the menu
* [ ] Enhance and refine the GitHub Workflow within the repository

---

## Author

Created by TobiMax1212