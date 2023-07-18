#Load System Windows Forms (PreReqs)  https://prosystech.nl/powershell-service-desk-ict-tool-gui/
[reflection.assembly]::LoadWithPartialName("System.Windows.Forms") | Out-Null
[reflection.assembly]::LoadWithPartialName("Microsoft.UpdateServices.Administration") | out-null


#für WSUS 
Set-StrictMode -Version Latest

#[int], weil wir Strings nicht vergleichen können.
$winversion = [int](Get-WmiObject -class Win32_OperatingSystem).BuildNumber

#wsuscheck
$wsuscheck = Get-WindowsFeature | Where-Object {$_.name -eq "UpdateServices"}
$adcheck = Get-WindowsFeature | Where-Object {$_.name -eq "AD-Domain-Services"}

$network = [System.DirectoryServices.ActiveDirectory.Domain]::GetComputerDomain()
$hostname = hostname


#ProgrammHeader und Oberer Text
$guiForm = New-Object System.Windows.Forms.Form
$guiForm.Text = "Wartungstool"
$guiForm.Size = New-Object System.Drawing.Size (880,710)

$guiLabel = New-Object System.Windows.Forms.Label
$guiLabel.Location = New-Object System.Drawing.Size (10,10)
$guiLabel.Size = New-Object System.Drawing.Size (800,30)
$guiLabel.Text = "Wartungs Toolbox auf " + $hostname +" in "+ $network.name
$guiLabel.Font = New-Object System.Drawing.Font ("Verdana",9)

#Textbox
$guiLabel3 = New-Object system.windows.Forms.TextBox
$guiLabel3.Location = New-Object System.Drawing.Size (10,400)
$guiLabel3.Size = New-Object System.Drawing.size (740,400)
$guiLabel3.Location = '10,200'
$guiLabel3.ScrollBars = "Vertical"
$guiLabel3.Multiline = $true
$guiLabel3.Text = ""
$guiLabel3.Font = New-Object System.Drawing.Font ("Verdana",9)

#Buttons
	
$selectCMD = New-Object System.Windows.Forms.Button
$selectCMD.Size = New-Object System.Drawing.Size (150,40)
$selectCMD.Text = 'Export to wtlog.txt'
$selectCMD.Location = '10,40'
$selectCMD.Add_Click({
    $guilabel3.Text > wtlog.txt
	$notif = New-Object -ComObject Wscript.Shell
	$notif.Popup("Ausgabe in wtlog.txt Gespeichert!")
    }
)


$selectContentsize = New-Object System.Windows.Forms.Button
$selectContentsize.Size = New-Object System.Drawing.Size (150,40)
$selectContentsize.Text = 'WSUS Content'
$selectContentsize.Location = '10,90'

$selectContentsize.Add_Click({
if($winversion -lt 9601){
	if($winversion -gt 9599)
	{
		$location = (Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Update Services\Server\Setup').ContentDir
	}
	else {guilabel3.Text += "Nur Kompatibel für Server 2012 R2+" + "`r`n"}
}
else
{
		$location = Get-ItemPropertyValue -Path 'HKLM:\SOFTWARE\Microsoft\Update Services\Server\Setup' -Name ContentDir
		
}
		$guiLabel3.Text += "ContentFolder: " + $location + "`r`n"
		$contentsize = (gci $location\WsusContent -Recurse| measure Length -s).sum / 1Gb
		$guiLabel3.Text += "WSUSContent Size (GB): " + $contentsize.ToString('N2') + " `r`n"
}
)


$selectCfree = New-Object System.Windows.Forms.Button
$selectCfree.Size = New-Object System.Drawing.Size (150,40)
$selectCfree.Text = 'C: Free'
$selectCfree.Location = '170,40'
$selectCfree.Add_Click({
	    $guiLabel3.Text += "C: Free(GB): " + ((Get-Volume C).SizeRemaining / 1Gb).ToString('N2') + "`r`n"
		
    }
)

$selectUptime = New-Object System.Windows.Forms.Button
$selectUptime.Size = New-Object System.Drawing.Size (150,40)
$selectUptime.Text = 'Uptime'
$selectUptime.Location = '170,90'
$selectUptime.Add_Click({
	$lastboottime = (Get-WMIObject -Class Win32_OperatingSystem).LastBootUpTime
	
	$sysuptime = (Get-Date) - [System.Management.ManagementDateTimeconverter]::ToDateTime($lastboottime)
    $guiLabel3.Text += "Uptime: " + $sysuptime.days + " Tage " + $sysuptime.hours + " Stunden " + "`r`n"
    }
)

$selectClear = New-Object System.Windows.Forms.Button
$selectClear.Size = New-Object System.Drawing.Size (150,40)
$selectClear.Text = 'Clear'
$selectClear.Location = '170,140'
$selectClear.Add_Click(
{
	$guilabel3.Text = ''
}
)


#Alle Anderen Properties können auch angezeigt werden.

$selectGETAD = New-Object System.Windows.Forms.Button
$selectGETAD.Size = New-Object System.Drawing.Size (150,40)
$selectGETAD.Text = 'Get AD Computers'
$selectGETAD.Location = '330,40'
$selectGETAD.Add_click({
	$adcomputers = Get-ADComputer -Filter {OperatingSystem -Like "Windows 10*"} -Property * | Sort-Object OperatingSystemVersion -Descending
	ForEach($pc in $adcomputers)
	{
		$guilabel3.Text += $pc.OperatingSystem + " " + $pc.OperatingSystemVersion + "`t" + "Name: " + $pc.Name  +  "`r`n" 
	}
}
)

$selectSRVUP  = New-Object System.Windows.Forms.Button
$selectSRVUP.Size = New-Object System.Drawing.Size (150,40)
$selectSRVUP.Text = 'Get Server Uptimes'
$selectSRVUP.Location = '330,140'
$selectSRVUP.Add_click({
		$servernames = Get-ADComputer -Filter {OperatingSystem -Like "*Server*"} | Sort-Object OperatingSystemVersion -Descending
		foreach($server in $servernames){
		$Bootupdate = (Get-CimInstance -ClassName Win32_OperatingSystem -ComputerName $server.name).LastBootUpTime
		$Bootuptime = (Get-WMIObject -Class Win32_OperatingSystem -ComputerName $server.Name).LastBootUpTime
		$uptime = (Get-Date) - [System.Management.ManagementDateTimeconverter]::ToDateTime($Bootuptime)
		$guilabel3.Text += $server.Name + "`t" + " Last Boot: " + $Bootupdate + " Uptime: " + $uptime.days + " Tag(e)" + "`r`n" 
}}
)

$selectClientUP  = New-Object System.Windows.Forms.Button
$selectClientUP.Size = New-Object System.Drawing.Size (150,40)
$selectClientUP.Text = 'Get Client Uptimes'
$selectClientUP.Location = '490,140'
$selectClientUP.Add_click({
		$clients = Get-ADComputer -Filter {OperatingSystem -Like "Windows 10*"} -Properties *
		#ComputerName in PS5.1 evtl. Targetname für ältere
		foreach($client in $clients){
		if(Test-Connection -ComputerName $client.name -Count 1 -TimeToLive 1 -Quiet)
			{
				$Bootupdate = (gwmi win32_operatingsystem -computer $client.name).LastBootUpTime
				$Bootuptime = (Get-WMIObject -Class Win32_OperatingSystem -ComputerName $client.Name).LastBootUpTime
				$uptime = (Get-Date) - [System.Management.ManagementDateTimeconverter]::ToDateTime($Bootuptime)
				$guilabel3.Text += $Client.Name + "`t"  + "Uptime: " + $uptime.days + " Tag(e)" + "`r`n" 
			}
		else{$guilabel3.Text += $Client.Name + "`t"  + "nicht erreichbar" + "`r`n" }
		
}
$guilabel3.Text += "`r`n" + "------------------------------------" + "`r`n"
}
)	

$selectUpdatetimes = New-Object System.Windows.Forms.Button
$selectUpdatetimes.Size = New-Object System.Drawing.Size (150,40)
$selectUpdatetimes.Text = 'Get Last updates'
$selectUpdatetimes.Location = '330,90'
$selectUpdatetimes.Add_click({
		$lastupdates = Get-HotFix | ?{$_.InstalledOn -gt ((Get-Date).AddDays(-40))} | sort installedon -desc
		Foreach($updt in $lastupdates)
		{
			$guilabel3.Text += " Installdate: " + $updt.InstalledOn + " Description: " + $updt.Description + " Name: " + $updt.Name + "`r`n"
		}
}
)

#TEMPORÄR
$selectWSUSErrors = New-Object System.Windows.Forms.Button
$selectWSUSErrors.Size = New-Object System.Drawing.Size (150,40)
$selectWSUSErrors.Text = 'WSUS Errors (Admin)'
$selectWSUSErrors.Location = '10,140'
$selectWSUSErrors.Add_Click(
{	
	$HeaderChars = 0
	$wsus = [Microsoft.UpdateServices.Administration.AdminProxy]::GetUpdateServer()
	$computerScope = New-Object Microsoft.UpdateServices.Administration.ComputerTargetScope
	$updateScope = New-Object Microsoft.UpdateServices.Administration.UpdateScope
	$summariesComputerFailed = $wsus.GetSummariesPerComputerTarget($updateScope,$computerScope) | Where-Object FailedCount -NE 0 | Sort-Object FailedCount, UnknownCount, NotInstalledCount -Descending
	$computers = Get-WsusComputer
	$computersErrorEvents = $wsus.GetUpdateEventHistory([System.DateTime]::Today.AddDays(-7), [System.DateTime]::Today) | Where-Object ComputerId -ne Guid.Empty | Where-Object IsError -eq True
	$outputText = ""
	
	If ($summariesComputerFailed -EQ 0 -or $summariesComputerFailed -EQ $null){
		$guiLabel3.Text += "No computers were found on the WSUS server (" + $wsus.ServerName + ") with updates in error!" + "`r`n"
    }
	
	Else {
	$guiLabel3.Text += "Computers were found on the WSUS server (" + $wsus.ServerName + ") with failed updates!" +"`r`n"
	}
	
	ForEach ($computerFailed In $summariesComputerFailed) {
  $computer = $computers | Where-Object Id -eq $computerFailed.ComputerTargetId

  
  # FullDomainName e IP
  $outputText = $computer.FullDomainName + " (IP:" + $computer.IPAddress + " - Wsus Id:" + $computerFailed.ComputerTargetId + ")"
  $guiLabel3.Text += ("`r`n" + $outputText)

  # Hardware info
  $outputText = " Hardware info".PadRight($HeaderChars) + ": " + $computer.Make + " " + $computer.Model
  $guiLabel3.Text += $outputText + "`r`n"
 

  # Operating system
  $outputText = " Operating system".PadRight($HeaderChars) + ": " + $computer.OSDescription
  $guiLabel3.Text += $outputText + "`r`n"
 


  # Update failed
  $outputText = " Update failed".PadRight($HeaderChars) + ": " + $computerFailed.FailedCount
  $guiLabel3.Text += $outputText + "`r`n"
 

  # Update unknown
  $outputText = " Update unknown".PadRight($HeaderChars) + ": " + $computerFailed.UnknownCount
  $guiLabel3.Text += $outputText + "`r`n"
 

  # Update not installed
  $outputText = " Update not installed".PadRight($HeaderChars) + ": " + $computerFailed.NotInstalledCount
  $guiLabel3.Text += $outputText + "`r`n"
 

  # Update installed pending reboot
  $outputText = " Update installed pending reboot".PadRight($HeaderChars) + ": " + $computerFailed.InstalledPendingRebootCount
  $guiLabel3.Text += $outputText + "`r`n"
 

  # Last sync result
  $outputText = " Last sync result".PadRight($HeaderChars) + ": " + $computer.LastSyncResult
  $guiLabel3.Text += $outputText + "`r`n"
  

  # Last sync time
  $outputText = " Last sync time".PadRight($HeaderChars) + ": " + ($computer.LastSyncTime).ToString()
  If ($computer.LastSyncTime -LE [System.DateTime]::Today.AddDays(-7)){
      $guiLabel3.Text += $outputText + "`r`n"
  }
  Else {
    $guiLabel3.Text += $outputText + "`r`n"
  }


  # Last updated
  $outputText = " Last update".PadRight($HeaderChars) + ": " + ($computerFailed.LastUpdated).ToString()
  $guiLabel3.Text += $outputText + "`r`n"

  # Failed Updates
  $computerUpdatesFailed = ($wsus.GetComputerTargets($computerScope) | Where-Object Id -EQ $computerFailed.ComputerTargetId).GetUpdateInstallationInfoPerUpdate($updateScope) | Where UpdateInstallationState -EQ Failed

  $computerUpdateFailedIndex=0
  ForEach ($update In $computerUpdatesFailed) {
    If ($computerUpdateFailedIndex -EQ 0){
      $outputText = " Failed updates".PadRight($HeaderChars) + ": " + "`r`n"
    }
    Else{
      $outputText = "".PadRight($HeaderChars+2)
    }

    $outputText += "-" + $wsus.GetUpdate($update.UpdateId).Title + "`r`n"
    $guiLabel3.Text += $outputText
 
    $computerUpdateFailedIndex += 1
  }


}	}
)
	
	
#Buttons platzieren
$guiForm.Controls.Add($guiLabel)
$guiForm.Controls.Add($guiLabel3)
$guiForm.Controls.Add($selectCMD)
$guiForm.Controls.Add($selectCfree)
$guiForm.Controls.Add($selectUptime)
#WSUS Features nur für WSUS Server
if($wsuscheck.InstallState -eq "Installed")
{
$guiForm.Controls.Add($selectContentsize)
$guiForm.Controls.Add($selectWSUSErrors)
}

$guiForm.Controls.Add($selectClear)
#AD Features nur für AD Server
if($adcheck.InstallState -eq "Installed")
{
$guiForm.Controls.Add($selectGETAD)
$guiForm.Controls.Add($selectSRVUP)
$guiForm.Controls.Add($selectClientUP)
}
$guiForm.Controls.Add($selectUpdatetimes)

#Starting the GUI
$guiForm.ShowDialog() 