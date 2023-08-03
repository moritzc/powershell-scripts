	try {
    $snapshots = Get-VM | Get-VMSnapshot
    if ($snapshots) {
        Write-Output $snapshots
    } else {
        Write-Output "No Snapshots found"
    }

    # Automatically get the Virtual Machines path for the Hyper-V host
    $vmHost = Get-VMHost | Select-Object -ExpandProperty VirtualMachinePath
    $vmFolderPath = $vmHost.TrimEnd('\')

    # Check for AVHDX files in all VM folders
    $vmFolders = Get-ChildItem -Path $vmFolderPath -Recurse -Directory -ErrorAction Stop
    $avhdxFilesFound = $false
    foreach ($folder in $vmFolders) {
        $avhdxFiles = Get-ChildItem -Path $folder.FullName -Recurse -Filter "*.avhdx" -File -ErrorAction Stop
        if ($avhdxFiles) {
            $avhdxFilesFound = $true
            Write-Output "AVHDX files found in VM folder: $($folder.FullName)"
            foreach ($avhdxFile in $avhdxFiles) {
                Write-Output "AVHDX file: $($avhdxFile.FullName)"
            }
        }
    }

    if (!$avhdxFilesFound) {
        Write-Output "No AVHDX files found in any VM folder."
    }

    return 0
} catch {
    $Errormsg = "`r`n Error(s): " + $_.Exception.Message
    Write-Output $Errormsg
    return 1
}
