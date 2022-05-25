$FolderToCorrect = "C:\Temp\FolderOfBadlyExtractedArchives\"

$Folders = Get-ChildItem -Path $FolderToCorrect | Where-Object { $_.PSIsContainer -eq $true }
$DeleteDirs = $false

foreach ($folder in $Folders) {
    Write-Host "checking $($folder.Name)"
    $items = Get-ChildItem -Path $folder.FullName
    if (($items | Measure-Object).count -eq 1) {
        if($items.PSIsContainer -eq $true) {
            $subfolderContents = Get-ChildItem -Path $items.FullName
            $upper = $folder.FullName
            $subfolderContents | ForEach-Object { 
                Write-Host "Moving $($_.FullName) to $upper"
                Move-Item -Path $_.FullName -Destination $upper
            }
            if ($DeleteDirs) {
              Remove-Item -Path $items.FullName
            }
        }
    }
}

