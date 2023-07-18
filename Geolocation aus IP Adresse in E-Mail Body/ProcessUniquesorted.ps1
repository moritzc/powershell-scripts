Clear-COntent 'finished.csv'
"IP" + "," + "Country" + "," + "Count" + "," + "Confidence" | Out-File -append 'finished.csv'
$Uniquesorted = Get-Content 'UniqueIPs.txt' | Group-Object -noelement | sort Count -Descending 
Write-Host $Uniquesorted.Count IP Adressen gefunden
$counter=0
ForEach($IP in $Uniquesorted)
{
	Write-Progress -Activity "Processing API Calls" -CurrentOperation $IP.Name -PercentComplete (($counter / $Uniquesorted.count)*100)
	$IPname = $IP.Name
	$Response = & '.\APICall.ps1' "$IPname"
	$csvout += [string]$IP.Name + "," + [string]$Response.Country + "," + [string]$IP.Count + "," + [string]$Response.Confidence	| Out-File -append 'finished.csv'
	$counter++
}

Write-Output "Fertig"