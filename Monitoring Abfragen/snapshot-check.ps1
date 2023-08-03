try {
    $snapshots = Get-VM | Get-VMSnapshot
    if ($snapshots) {
        Write-Output $snapshots
    } else {
        Write-Output "Keine Snapshots vorhanden"
    }
    return 0
} catch {
    $Errormsg = "`r`n Error(s): " + $_.Exception.Message
    Write-Output $Errormsg
    return 1
}
