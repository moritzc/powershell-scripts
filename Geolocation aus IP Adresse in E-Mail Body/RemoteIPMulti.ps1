Clear-Content 'UniqueIPs.txt'
Clear-COntent 'finished.csv'
"IP" + "," + "Country" + "," + "Count" + "," + "Confidence" | Out-File -append 'finished.csv'
$counter=0
$enum=Get-ChildItem ".\MSG" -Filter  *.msg
$enum |
	ForEach-Object {
		[regex]$regex = '\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b'
        $outlook = New-Object -comobject outlook.application
        $msg = $outlook.Session.OpenSharedItem($_.FullName) | Select -Expandproperty Body | Out-File 'Message.txt'
		$ms2 = Get-Content 'Message.txt' | select-string -Pattern $regex | ForEach-Object {$_.Matches} | %{$_.Value} | Out-File -append 'UniqueIPs.txt'
			
		Write-Progress -Activity "Processing Messages" -CurrentOperation $counter -PercentComplete (($counter / $enum.count)*100)
		$counter++
    }
$Uniquesorted = Get-Content 'UniqueIPs.txt' | Group-Object -noelement | sort Count -Descending 
Write-Host $Uniquesorted.Count einzigartige IP Adressen gefunden
$counter=0
ForEach($IP in $Uniquesorted)
{
	Write-Progress -Activity "Processing API Calls" -CurrentOperation $IP.Name -PercentComplete (($counter / $Uniquesorted.count)*100)
	$IPname = $IP.Name
	$Response = & '.\APICall.ps1' "$IPname"
	$csvout += [string]$IP.Name + "," + [string]$Response.Country + "," + [string]$IP.Count + "," + [string]$Response.Confidence | Out-File -append 'finished.csv'
	$counter++
}

Write-Output "Fertig"

