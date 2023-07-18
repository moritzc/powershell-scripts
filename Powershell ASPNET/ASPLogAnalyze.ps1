$days = 2
if($args[0]){ $days = $args[0]}


Get-EventLog -LogName Application -After (((Get-Date).addDays(-$days)).date) -Before  (Get-Date) | Where-Object {$_.EventID -eq 1309} | Format-Table Message -wrap | Out-File 'Dummy.txt'
[regex]$regex = '\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b'
Get-Content 'Dummy.txt' | select-string -Pattern $regex | ForEach-Object {$_.Matches} | %{$_.Value} | Out-File -append 'IPs.txt'
Remove-Item 'Dummy.txt'

$Uniquesorted = Get-Content 'IPs.txt' | Group-Object -noelement | sort Count -Descending 
Write-Host $Uniquesorted.Count IP Adressen gefunden
$counter=0
ForEach($IP in $Uniquesorted)
{
	Write-Progress -Activity "Processing API Calls" -CurrentOperation $IP.Name -PercentComplete (($counter / $Uniquesorted.count)*100)
	$IPname = $IP.Name
	$Response = & '.\APICall.ps1' "$IPname"
	$csvout += [string]$IP.Name + "," + [string]$Response.Country + "," + [string]$IP.Count | Out-File -append 'finished.csv'
	$counter++
}
Remove-Item 'IPs.txt'

Write-Output "Fertig"