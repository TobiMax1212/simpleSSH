$line = "=" * 70
$zeit = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
$bold = "`e[1m"
$reset = "`e[0m"

Clear-Host

# Obere Trennlinie
Write-Host $line -ForegroundColor Cyan

# Haupttitel (Zentriert durch Leerzeichen)
Write-Host "                  $bold Welcome to the simpleSSH manager! $reset" -ForegroundColor White
Write-Host "                                v1.0" -ForegroundColor Gray
Write-Host "                        $bold Author: TobiMax1212 $reset" -ForegroundColor Gray

Write-Host $line -ForegroundColor Cyan

# Infoblock (Sauber strukturiert)
Write-Host " [i] Info:    " -ForegroundColor Cyan -NoNewline
Write-Host "This script will help you manage your SSH connections easily." -ForegroundColor White

Write-Host " [?] Time:    " -ForegroundColor Yellow -NoNewline
Write-Host "$zeit" -ForegroundColor Gray

# Untere Trennlinie
Write-Host $line -ForegroundColor Cyan
Write-Host ""

# Menu
Write-Host "Please select an option:" -ForegroundColor Green
Write-Host "1. Add a new SSH connection" -ForegroundColor White
Write-Host "2. List all SSH connections" -ForegroundColor White
Write-Host "3. Connect to an SSH server" -ForegroundColor White
Write-Host "4. Remove an SSH connection" -ForegroundColor White
Write-Host "5. Add an shortcut for an SSH connection" -ForegroundColor White
Write-Host "6. Exit" -ForegroundColor White
Write-Host "You can exit also by pressing 'strg + c' or 'ctrl + c'." -ForegroundColor Red

Write-Host $line -ForegroundColor Cyan
Write-Host "Shortcuts: (Press the corresponding number to select an option)" -ForegroundColor Green
Write-Host $line -ForegroundColor Cyan

# Config file handling
$configPath = ".\data\config.json"

if (Test-Path $configPath) {
    $config = Get-Content $configPath | ConvertFrom-Json
    Write-Host "Config file loaded successfully." -ForegroundColor Green
} else {
    Write-Host "Config file not found. Creating a new one..." -ForegroundColor Yellow
    $config = @{}
    $config | ConvertTo-Json | Set-Content $configPath
}
# End config file handling

Write-Host ""

#Backend contents
$userInput = Read-Host "Enter your choice (1-6)"

switch ($userInput) {
    "1" {
        Write-Host "You selected: Add a new SSH connection" -ForegroundColor Green
        # Call the function or script to add a new SSH connection
        .\add-ssh.ps1
    }
    "2" {
        Write-Host "You selected: List all SSH connections" -ForegroundColor Green
        # Call the function or script to list all SSH connections
        .\list-ssh.ps1
    }
    "3" {
        Write-Host "You selected: Connect to an SSH server" -ForegroundColor Green
        # Call the function or script to connect to an SSH server
        .\connect-ssh.ps1
    }
    "4" {
        Write-Host "You selected: Remove an SSH connection" -ForegroundColor Green
        # Call the function or script to remove an SSH connection
        .\remove-ssh.ps1
    }
    "5" {
        Write-Host "You selected: Add a shortcut for an SSH connection" -ForegroundColor Green
        # Call the function or script to add a shortcut for an SSH connection
        .\add-shortcut.ps1
    }
    "6" {

        Write-Host "Exiting the simpleSSH manager. Goodbye!" -ForegroundColor Red
        Start-Sleep -Seconds 2
        exit
    }
    default {
        Write-Host "Invalid choice. Please select a valid option (1-6)." -ForegroundColor Red
    }
}



function add-ssh {
    Write-Host "Name of the SSH connection:" -ForegroundColor Yellow
    $name = Read-Host "Enter the name"
    Write-Host "Host of the SSH connection:" -ForegroundColor Yellow
    $host = Read-Host "Enter the host"
    Write-Host "Port of the SSH connection (default is 22):" -ForegroundColor Yellow
    $port = Read-Host "Enter the port (or press Enter for default)"

}