#Load System Windows Forms (PreReqs)  https://prosystech.nl/powershell-service-desk-ict-tool-gui/
[reflection.assembly]::LoadWithPartialName("System.Windows.Forms") | Out-Null
[reflection.assembly]::LoadWithPartialName("Microsoft.UpdateServices.Administration") | out-null


#für WSUS 
Set-StrictMode -Version Latest


#Here I define the GUI, the title above and the size
$guiForm = New-Object System.Windows.Forms.Form
$guiForm.Text = "Wartungstool"
$guiForm.Size = New-Object System.Drawing.Size (380,410)

$guiLabel = New-Object System.Windows.Forms.Label
$guiLabel.Location = New-Object System.Drawing.Size (10,10)
$guiLabel.Size = New-Object System.Drawing.Size (400,30)
$guiLabel.Text = "Wartungs Toolbox"
$guiLabel.Font = New-Object System.Drawing.Font ("Verdana",9)

$guiLabel3 = New-Object system.windows.Forms.TextBox
$guiLabel3.Location = New-Object System.Drawing.Size (10,400)
$guiLabel3.Size = New-Object System.Drawing.size (340,200)
$guiLabel3.Location = '10,200'
$guiLabel3.Multiline = $true
$guiLabel3.Text = ""
$guiLabel3.Font = New-Object System.Drawing.Font ("Verdana",9)


$selectCMD = New-Object System.Windows.Forms.Button
$selectCMD.Size = New-Object System.Drawing.Size (150,40)
$selectCMD.Text = 'CMD'
$selectCMD.Location = '10,40'
$selectCMD.Add_Click({
    Start-Process cmd.exe
    }
)

$selectContentsize = New-Object System.Windows.Forms.Button
$selectContentsize.Size = New-Object System.Drawing.Size (150,40)
$selectContentsize.Text = 'Calc'
$selectContentsize.Location = '10,90'
$selectContentsize.Add_Click({
		$guiLabel3.Text += "C:\Temp Size(GB): " + ((gci c:\Temp | measure Length -s).sum / 1Gb).ToString('N2') + " `r`n"
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

#TEMPORÄR
$selectWSUSErrors = New-Object System.Windows.Forms.Button
$selectWSUSErrors.Size = New-Object System.Drawing.Size (150,40)
$selectWSUSErrors.Text = 'WSUS Errors'
$selectWSUSErrors.Location = '10,140'
$selectWSUSErrors.Add_Click({
	$wsus = [Microsoft.UpdateServices.Administration.AdminProxy]::GetUpdateServer()
	$computerScope = New-Object Microsoft.UpdateServices.Administration.ComputerTargetScope
	$updateScope = New-Object Microsoft.UpdateServices.Administration.UpdateScope
	$summariesComputerFailed = $wsus.GetSummariesPerComputerTarget($updateScope,$computerScope) | Where-Object FailedCount -NE 0 | Sort-Object FailedCount, UnknownCount, NotInstalledCount -Descending
	$computers = Get-WsusComputer
	$computersErrorEvents = $wsus.GetUpdateEventHistory([System.DateTime]::Today.AddDays(-7), [System.DateTime]::Today) | Where-Object ComputerId -ne Guid.Empty | Where-Object IsError -eq True
	$outputText = ""
	
	If ($summariesComputerFailed -EQ 0 -or $summariesComputerFailed -EQ $null){
		$outputText = "No computers were found on the WSUS server (" + $wsus.ServerName + ") with updates in error!"
    }
	

	$guiLabel3.Text += $outputText
	}	
)
	
	
#Putting all labels and buttons in the GUI
$guiForm.Controls.Add($guiLabel)
$guiForm.Controls.Add($selectContentsize)
$guiForm.Controls.Add($guiLabel3)
$guiForm.Controls.Add($selectCMD)
$guiForm.Controls.Add($selectCfree)
$guiForm.Controls.Add($selectUptime)
$guiForm.Controls.Add($selectWSUSErrors)

#Starting the GUI
$guiForm.ShowDialog() 