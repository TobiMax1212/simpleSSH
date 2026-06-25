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

#The Test-Path checks if the config file exists
if (Test-Path $configPath) {
    $config = Get-Content $configPath | ConvertFrom-Json
    Write-Host "Config file loaded successfully." -ForegroundColor Green
} else {
    Write-Host "Config file not found. Creating a new one..." -ForegroundColor Yellow

    $jsonTemplate = @"
{
    "Connections": []
    "Settings": []
}
"@

    $config = $jsonTemplate | ConvertFrom-Json
    $config | ConvertTo-Json -Depth 10 | Set-Content $configPath -Encoding UTF8
}
# End config file handling

Write-Host ""

#Backend contents

function add-ssh {
    Write-Host "Name of the SSH connection:" -ForegroundColor Yellow
    $cName = Read-Host "Enter the name"
    Write-Host "Host of the SSH connection:" -ForegroundColor Yellow
    $cHost = Read-Host "Enter the host"
    Write-Host "Port of the SSH connection (default is 22):" -ForegroundColor Yellow
    $cPort = Read-Host "Enter the port (or press Enter for default)"

    if (-not [string]::IsNullOrWhiteSpace($cHost) -and -not [string]::IsNullOrWhiteSpace($cName)) {

        $newConnection = [PSCustomObject]@{
            cName = $cName
            cHost = $cHost
            cPort = if ([string]::IsNullOrWhiteSpace($cPort)) { 22 } else { [int]$cPort }
        }
        $config.Connections += $newConnection

        $config | ConvertTo-Json -Depth 10 | Set-Content $configPath -Encoding UTF8

        Write-Host "SSH connection '$cName' added successfully!" -ForegroundColor Green
    }else {
        Write-Host "Name and Host cannot be empty. Please try again." -ForegroundColor Red
    }

}

function show-ssh {
    if ($config.Connections.Count -eq 0) {
        Write-Host "No SSH connections found or the config file is empty." -ForegroundColor Yellow
    } else {
        Write-Host "List of SSH connections:" -ForegroundColor Green
        foreach ($connection in $config.Connections) {
            Write-Host "Name: $($connection.cName), Host: $($connection.cHost), Port: $($connection.cPort)" -ForegroundColor White
        }
    }
}

function connect-ssh {
    if ($config.Connections.Count -eq 0) {
        Write-Host "No SSH connections found. Please add a connection first." -ForegroundColor Yellow
        return
    }
    
    Write-Host "Available SSH connections:" -ForegroundColor Green
    for ($i = 0; $i -lt $config.Connections.Count; $i++) {
        $connection = $config.Connections[$i]
        Write-Host "$($i + 1). Name: $($connection.cName), Host: $($connection.cHost), Port: $($connection.cPort)" -ForegroundColor White
    }

    $select = Read-Host "Enter the number of the connection. Please select a number between 1 and $($config.Connections.Count): "

    if ($select -match '^\d+$' -and $select -ge 1 -and $select -le $config.Connections.Count) {
        $selectedConnection = $config.Connections[$select - 1]
        Write-Host "`n[OK] Connecting to $($selectedConnection.cName) at $($selectedConnection.cHost) on port $($selectedConnection.cPort)..." -ForegroundColor Green
        # Command for ssh connection in powershell
        ssh -p $
    }
}

$userInput = Read-Host "Enter your choice (1-6)"

switch ($userInput) {
    "1" {
        Write-Host "You selected: Add a new SSH connection" -ForegroundColor Green
        # Call the function or script to add a new SSH connection
        add-ssh
    }
    "2" {
        Write-Host "You selected: List all SSH connections" -ForegroundColor Green
        # Call the function or script to list all SSH connections
        show-ssh
    }
    "3" {
        Write-Host "You selected: Connect to an SSH server" -ForegroundColor Green
        # Call the function or script to connect to an SSH server
        connect-ssh
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



