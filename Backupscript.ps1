# Defining paths for my original folder and where to create my backup folder
$sourceFolder = "C:\Myproject\df-mod3-sdm\OriginalEvidenceFolder"
$backupFolder = "C:\Myproject\df-mod3-sdm\df-mod3-sdm\BackupEvidenceFolder"

# Display source and backup folder paths
Write-Output "Source Folder Path: $sourceFolder"
Write-Output "Backup Folder Path: $backupFolder"

# Copy the contents from the source folder to the backup folder
if (Test-Path -Path $sourceFolder) {
    Write-Output "Source folder exists. Proceeding with backup."

    # Creating the backup folder
    if (!(Test-Path -Path $backupFolder)) {
        New-Item -ItemType Directory -Path $backupFolder -Force
        Write-Output "Created backup folder at $backupFolder."
    } else {
        Write-Output "Backup folder already exists. Proceeding to copy files."
    }

    # Copying the contents from the original folder to the backup folder
    try {
        Copy-Item -Path "$sourceFolder\*" -Destination $backupFolder -Recurse -Force
        Write-Output "Copied contents from $sourceFolder to $backupFolder."
    } catch {
        Write-Output ("Error occurred while copying contents: " + $_)
        exit
    }
} else {
    Write-Output "Source folder does not exist. Exiting script."
    exit
}

# Set backup folder to read-only
try {
    $acl = Get-Acl -Path $backupFolder
    $rule = New-Object System.Security.AccessControl.FileSystemAccessRule("Everyone", "ReadAndExecute", "ContainerInherit, ObjectInherit", "None", "Allow")
    $acl.SetAccessRule($rule)
    Set-Acl -Path $backupFolder -AclObject $acl
    Write-Output "Set permissions on $backupFolder to read-only for all users."
} catch {
    Write-Output ("Error setting permissions on " + $backupFolder + ": " + $_)
}
