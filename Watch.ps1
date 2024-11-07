# Script to see Log in file changes
# Define the folder to monitor
$folderToMonitor = "C:\Myproject\Project-case Folder\Evidence-Files"

# Define the log file to store the results
$logFile = "C:\Myproject\Project-case Folder\LogFile.txt"

# Define the file that stores the timestamp of the last login time
$lastLoginFile = "C:\Myproject\Project-case Folder\Evidence-Files\LastLoginTime.txt"

# Get the current date and time
$currentTime = Get-Date

# Function to write log results to the log file
function Write-Log {
    param (
        [string]$logMessage
    )
    Add-Content -Path $logFile -Value "$(Get-Date) - $logMessage"
}

# Function to check for changes in the folder since the last login
function Check-FileChanges {
    # Check if the last login time file exists
    if (Test-Path $lastLoginFile) {
        # Read the last login timestamp from the file
        $lastLoginTime = Get-Content $lastLoginFile | Out-String
        $lastLoginTime = [datetime]::Parse($lastLoginTime.Trim())

        Write-Log "Checking for changes since last login at $lastLoginTime"

        # Get a list of all files in the folder (including subfolders)
        $files = Get-ChildItem -Path $folderToMonitor -Recurse

        # Filter files that were modified since the last login time
        $modifiedFiles = $files | Where-Object { $_.LastWriteTime -gt $lastLoginTime }

        # Check if any files were modified
        if ($modifiedFiles.Count -gt 0) {
            Write-Log "Changes detected in the folder. Modified files:"
            $modifiedFiles | ForEach-Object { Write-Log "Modified File: $($_.FullName) at $($_.LastWriteTime)" }
        } else {
            Write-Log "No changes detected in the folder since last login."
        }
    } else {
        Write-Log "Last login time file not found. No changes to check."
    }
}

# Function to update the last login timestamp
function Update-LastLoginTime {
    $currentTime | Out-File -FilePath $lastLoginFile
    Write-Log "Last login time updated to $currentTime"
}

# Run the function to check for changes
Check-FileChanges

# Update the last login time for future checks
Update-LastLoginTime
