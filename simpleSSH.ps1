# ===========================================
# 1. Global variable // Config init
# ===========================================

# Config file handling
$configPath = ".\data\config.json"
$configSuccess = $false

#The Test-Path checks if the config file exists
if (Test-Path $configPath) {
    $config = Get-Content $configPath | ConvertFrom-Json
    $configSuccess = $true
} else {
    Write-Host "Config file not found. Creating a new one..." -ForegroundColor Yellow

    $jsonTemplate = @"
{
    "Connections": [],
    "Menu-Settings": []
}
"@

function save-config {
    param (
        [Parameter(Mandatory = $true)]
        [string]$Path,
        
        [Parameter(Mandatory = $true)]
        [object]$Config
    )

    try {
        $Config | ConvertTo-Json -Depth 10 | Set-Content -Path $Path -Encoding UTF8
        Write-Host "`n[OK] Configuration saved successfully to $Path." -ForegroundColor Green
    } catch {
        Write-Host "`n[Error] Error saving configuration: $_" -ForegroundColor Red
    }
}

save-config -Path $configPath -Config ($jsonTemplate | ConvertFrom-Json)
}
# End config file handling

$line = "=" * 70
$zeit = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
$bold = "`e[1m"
$reset = "`e[0m"

$pwshVersion = $PSVersionTable.PSVersion


# ==========================================
# 2. Main-functions
# ==========================================
function add-ssh {
    Write-Host "Name of the SSH connection:" -ForegroundColor Yellow
    $cName = Read-Host "Enter the name"
    Write-Host "Username for the SSH connection:" -ForegroundColor Yellow
    $cUname = Read-Host "Enter the username"
    Write-Host "Host of the SSH connection:" -ForegroundColor Yellow
    $cHost = Read-Host "Enter the host"
    Write-Host "Port of the SSH connection (default is 22):" -ForegroundColor Yellow
    $cPort = Read-Host "Enter the port (or press Enter for default)"

# ====================================================================
# [INFO] BEGINN: MAINTENANCE NEEDED: Add shortcut feature for SSH connections
# ====================================================================    
    #Write-Host "Would you like to add an menu shortcut for this connection? (y/n)" -ForegroundColor Yellow
    #$addShortcut = Read-Host "Enter 'y' for yes or 'n' for no"

    if ($addShortcut -eq 'y') {
        Write-Host "Choose a shortcut number (6-9) for this connection:" -ForegroundColor Yellow
        $shortcutNumber = Read-Host "Enter a number between 6 and 9"
        if ($shortcutNumber -match '^[6-9]$') {
            $config."Menu-Settings" += [PSCustomObject]@{
                Shortcut = $shortcutNumber
                ConnectionName = $cName
            }
            Write-Host "`n[OK] Shortcut '$shortcutNumber' assigned to connection '$cName'." -ForegroundColor Green
        } else {
            Write-Host "`n[Error] Invalid shortcut number. Please enter a number between 6 and 9." -ForegroundColor Red
        }
    }else {
        Write-Host "`n[Info] No shortcut assigned to connection '$cName'." -ForegroundColor Yellow
    }

# ====================================================================
# [INFO] END: MAINTENANCE NEEDED: Add shortcut feature for SSH connections
# ==================================================================== 

    if (-not [string]::IsNullOrWhiteSpace($cHost) -and -not [string]::IsNullOrWhiteSpace($cName)) {

        $newConnection = [PSCustomObject]@{
            cName = $cName
            cUname = $cUname
            cHost = $cHost
            cPort = if ([string]::IsNullOrWhiteSpace($cPort)) { 22 } else { [int]$cPort }
        }
        $config.Connections += $newConnection

        save-config -Path $configPath -Config $config
        
        Write-Host "`n[OK] SSH connection '$cName' added successfully!" -ForegroundColor Green
    }else {
        Write-Host "`n[Error] Name and Host cannot be empty. Please try again." -ForegroundColor Red
    }

    

}

function show-ssh {
    if ($config.Connections.Count -eq 0) {
        Write-Host "`n[Error] No SSH connections found or the config file is empty." -ForegroundColor Red
    } else {
        Write-Host "`n[OK] List of SSH connections:" -ForegroundColor Green
        foreach ($connection in $config.Connections) {
            Write-Host "Name: $($connection.cName), Host: $($connection.cHost), Port: $($connection.cPort)" -ForegroundColor White
        }
    }
}

function connect-ssh {
    if ($config.Connections.Count -eq 0) {
        Write-Host "`n[Error] No SSH connections found. Please add a connection first." -ForegroundColor Red
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
        ssh -p $($selectedConnection.CPort) "$($selectedConnection.cUname)@$($selectedConnection.cHost)"
    } else {
        Write-Host "`n[Error] Invalid selection. Please select a valid number between 1 and $($config.Connections.Count)." -ForegroundColor Red
    }
}

function remove-ssh {
    if ($config.Connections.Count -eq 0) {
        Write-Host "`n[Error] No SSH connections found. Please add a connection first." -ForegroundColor Red
        return
    }
    
    Write-Host "`n[OK] Available SSH connections for deletion:" -ForegroundColor Green
    for ($i = 0; $i -lt $config.Connections.Count; $i++) {
        $connection = $config.Connections[$i]
        Write-Host "$($i + 1). Name: $($connection.cName), Host: $($connection.cHost), Port: $($connection.cPort)" -ForegroundColor White
    }

    $select = Read-Host "Enter the number of the connection, that you want to delete. Please select a number between 1 and $($config.Connections.Count): "

    if ($select -match '^\d+$' -and $select -ge 1 -and $select -le $config.Connections.Count) {
        $selectedConnection = $config.Connections[$select - 1]
        Write-Host "`n[OK] Deleting connection $($selectedConnection.cName)..." -ForegroundColor Green

        $config.Connections = $config.Connections | Where-Object { $_.cName -ne $selectedConnection.cName }
        
        save-config -Path $configPath -Config $config


        Write-Host "`n[OK] Connection '$($selectedConnection.cName)' deleted successfully!" -ForegroundColor Green #<-- Maybe wont work
    } else {
        Write-Host "`n[Error] Invalid selection. Please select a valid number between 1 and $($config.Connections.Count)." -ForegroundColor Red
    }

}

# ==========================================
# 3. Mainloop -- Section |
# ========================================== 

Clear-Host

while($true) {

    if ($pwshVersion -lt [Version]"7.0") {
        Write-Host "[WARNING] You are using PowerShell version $pwshVersion. `n          It is recommended to use PowerShell 7 or higher `n          for better compatibility." -ForegroundColor yellow
        # Obere Trennlinie
        Write-Host $line -ForegroundColor Cyan

        # Haupttitel: "Welcome to the simpleSSH manager!" (33 Zeichen)
        # (70 - 33) / 2 = 18.5 -> 18 Leerzeichen
        Write-Host (" " * 18 + "Welcome to the simpleSSH manager!" + " ") -ForegroundColor White

        # Version: "version " + $pwshVersion (ca. 13-14 Zeichen)
        # (70 - 14) / 2 = 28 -> 28 Leerzeichen
        Write-Host (" " * 28 + "version $pwshVersion") -ForegroundColor Gray

        # Autor: "Author: TobiMax1212" (19 Zeichen)
        # (70 - 19) / 2 = 25.5 -> 25 Leerzeichen
        Write-Host (" " * 25 + "Author: TobiMax1212" + " ") -ForegroundColor Gray

        Write-Host $line -ForegroundColor Cyan
    } else {

        # Obere Trennlinie
        Write-Host $line -ForegroundColor Cyan
    
        # Haupttitel: "Welcome to the simpleSSH manager!" (33 Zeichen)
        # (70 - 33) / 2 = 18.5 -> 18 Leerzeichen
        Write-Host (" " * 18 + "$bold" + "Welcome to the simpleSSH manager!" + "$reset") -ForegroundColor White
    
        # Version: "version " + $pwshVersion (ca. 13-14 Zeichen)
        # (70 - 14) / 2 = 28 -> 28 Leerzeichen
        Write-Host (" " * 28 + "version $pwshVersion") -ForegroundColor Gray
    
        # Autor: "Author: TobiMax1212" (19 Zeichen)
        # (70 - 19) / 2 = 25.5 -> 25 Leerzeichen
        Write-Host (" " * 25 + "$bold" + "Author: TobiMax1212" + "$reset") -ForegroundColor Gray
    
        Write-Host $line -ForegroundColor Cyan

    }
    
    # Infoblock (Sauber strukturiert)
    Write-Host " [i] Info:    " -ForegroundColor Cyan -NoNewline
    Write-Host "This script will help you manage `n              your SSH connections easily. `n" -ForegroundColor White
    
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
    Write-Host "5. Exit" -ForegroundColor White
    Write-Host "You can exit also by pressing 'strg + c' or 'ctrl + c'." -ForegroundColor Red
    
    Write-Host $line -ForegroundColor Cyan
    Write-Host "Shortcuts: (Press the corresponding number to select an option)" -ForegroundColor Green
    Write-Host $line -ForegroundColor Cyan
    
    if ($configSuccess -eq $true) {
        Write-Host "[INFO] Config loaded successfully!" -ForegroundColor Green
    } else {
        Write-Host "[INFO] Config not found! Creating new one..." -ForegroundColor Yellow
    }
    
    Write-Host ""
    
    # ==========================================
    # 3. Mainloop -- Section ||
    # ==========================================
    
    $userInput = Read-Host "Enter your choice (1-5)"
    
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
            remove-ssh
        }
    
        "5" {
    
            Write-Host "`n[OK] Exiting the simpleSSH manager. Goodbye!" -ForegroundColor Red
            $timeout = 2
            for ($i = $timeout; $i -gt 0; $i--) {
                Write-Host "Exiting in $i seconds..." -ForegroundColor DarkGray
                Start-Sleep -Seconds 1
            }
            exit
        }
        default {
            Write-Host "Invalid choice. Please select a valid option (1-6)." -ForegroundColor Red
        }
    }

    Read-Host "`nPress Enter to return to the main menu..." | Out-Null
    Clear-Host

}

