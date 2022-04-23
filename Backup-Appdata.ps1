# Backup appdata local+roaming+locallow to Documents folder

$RoamingAppDataLocation = $env:APPDATA
$LocalAppDataLocation = $env:LOCALAPPDATA
$LocalLowLocation =  (Get-Item "$($ENV:AppData)\..\LocalLow").FullName


$DocumentsFolderLocation = [Environment]::GetFolderPath("MyDocuments")
$BackupDestination = "$DocumentsFolderLocation\AppData\$(Get-Date -Format 'yyyy-MM-dd HH-mm')\"

Write-Host "Getting folders to backup..."
# Roaming files
$RoamingFiles = Get-ChildItem -Path $RoamingAppDataLocation | Where-Object {$_.Name -notlike 'Package*'}

# Local appdata files - excluding various folders
$LocalFiles = Get-ChildItem -Path $LocalAppDataLocation | Where-Object {$_.Name -notlike 'Package*' -And $_.Name -notlike 'Microsoft*' -And $_.Name -notlike 'Duplicati*' -And $_.Name -ne 'Programs' -And $_.Name -ne 'NVIDIA'}

# LocalLow files
$LocalLowFiles = Get-ChildItem -Path $LocalLowLocation

# Create destination folders

if (-not (Test-Path $BackupDestination)) {
    Write-Host "Creating destination folders..."
    New-Item -ItemType "directory" -Path $BackupDestination -Force
    New-Item -ItemType "directory" -Path $BackupDestination\Roaming -Force
    New-Item -ItemType "directory" -Path $BackupDestination\Local -Force
    New-Item -ItemType "directory" -Path $BackupDestination\LocalLow -Force
}

# Copy files to backup destination
Write-Host "Copying files to backup destination..."
foreach ($item in $LocalFiles) {
    if ($item.PSIsContainer) {
        Copy-Item -Recurse -Path $item.FullName -Destination "$BackupDestination\Local\$($item.Name)" -Force -ErrorAction SilentlyContinue
    } else {
        Copy-Item -Path $item.FullName -Destination "$BackupDestination\Local\$($item.Name)" -Force -ErrorAction SilentlyContinue
    }
}

foreach ($item in $RoamingFiles) {
    if ($item.PSIsContainer) {
        Copy-Item -Recurse -Path $item.FullName -Destination "$BackupDestination\Roaming\$($item.Name)" -Force -ErrorAction SilentlyContinue
    } else {
        Copy-Item -Path $item.FullName -Destination "$BackupDestination\Roaming\$($item.Name)" -Force -ErrorAction SilentlyContinue
    }
}

foreach ($item in $LocalLowFiles) {
    if ($item.PSIsContainer) {
        Copy-Item -Recurse -Path $item.FullName -Destination "$BackupDestination\LocalLow\$($item.Name)" -Force
    } else {
        Copy-Item -Path $item.FullName -Destination "$BackupDestination\LocalLow\$($item.Name)" -Force
    }
}

Write-Host "Script finished."
