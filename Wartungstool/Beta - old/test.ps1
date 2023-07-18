function GenerateForm {
#region Import the Assemblies
[reflection.assembly]::loadwithpartialname("System.Windows.Forms") | Out-Null
[reflection.assembly]::loadwithpartialname("System.Drawing") | Out-Null
#endregion

#region Generated Form Objects
$form1 = New-Object System.Windows.Forms.Form
$label2 = New-Object System.Windows.Forms.Label
$comboBox2 = New-Object System.Windows.Forms.ComboBox
$label1 = New-Object System.Windows.Forms.Label
$comboBox1 = New-Object System.Windows.Forms.ComboBox
$InitialFormWindowState = New-Object System.Windows.Forms.FormWindowState
#endregion Generated Form Objects

$handler_form1_Load= 
{
    $comboBox1.Items.AddRange(@('Max Mustermann','Susanne Musterfrau'))
}

$handler_comboBox1_SelectedIndexChanged= 
{
    if($comboBox1.SelectedIndex -ne -1){
        $comboBox2.Enabled = $true
        switch($comboBox1.SelectedItem){
            'Max Mustermann' {
                $comboBox2.Items.Clear()
                $comboBox2.Items.AddRange(@("test1","test2","test3"))
            }
            'Susanne Musterfrau' {
                $comboBox2.Items.Clear()
                $comboBox2.Items.AddRange(@("test4","test5","test6"))
            }

        }
    }else{
        $comboBox2.Enabled = $false
        $comboBox2.SelectedIndex = -1
    }

}

$handler_comboBox2_SelectedIndexChanged= 
{
    if($comboBox2.SelectedIndex -ne -1){
        [System.Windows.Forms.MessageBox]::Show($comboBox2.SelectedItem)
    }

}

$OnLoadForm_StateCorrection=
{#Correct the initial state of the form to prevent the .Net maximized form issue
	$form1.WindowState = $InitialFormWindowState
}

#----------------------------------------------
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 82
$System_Drawing_Size.Width = 238
$form1.ClientSize = $System_Drawing_Size
$form1.DataBindings.DefaultDataSourceUpdateMode = 0
$form1.FormBorderStyle = 3
$form1.Name = "form1"
$form1.Text = "Dropdown Test"
$form1.add_Load($handler_form1_Load)

$label2.DataBindings.DefaultDataSourceUpdateMode = 0

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 12
$System_Drawing_Point.Y = 42
$label2.Location = $System_Drawing_Point
$label2.Name = "label2"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 23
$System_Drawing_Size.Width = 55
$label2.Size = $System_Drawing_Size
$label2.TabIndex = 3
$label2.Text = "Second"

$form1.Controls.Add($label2)

$comboBox2.DataBindings.DefaultDataSourceUpdateMode = 0
$comboBox2.Enabled = $False
$comboBox2.FormattingEnabled = $True
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 73
$System_Drawing_Point.Y = 39
$comboBox2.Location = $System_Drawing_Point
$comboBox2.Name = "comboBox2"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 21
$System_Drawing_Size.Width = 121
$comboBox2.Size = $System_Drawing_Size
$comboBox2.TabIndex = 2
$comboBox2.DropDownStyle = 2
$comboBox2.add_SelectedIndexChanged($handler_comboBox2_SelectedIndexChanged)

$form1.Controls.Add($comboBox2)

$label1.DataBindings.DefaultDataSourceUpdateMode = 0

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 12
$System_Drawing_Point.Y = 15
$label1.Location = $System_Drawing_Point
$label1.Name = "label1"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 23
$System_Drawing_Size.Width = 42
$label1.Size = $System_Drawing_Size
$label1.TabIndex = 1
$label1.Text = "First"

$form1.Controls.Add($label1)

$comboBox1.DataBindings.DefaultDataSourceUpdateMode = 0
$comboBox1.FormattingEnabled = $True
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 75
$System_Drawing_Point.Y = 12
$comboBox1.Location = $System_Drawing_Point
$comboBox1.Name = "comboBox1"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 21
$System_Drawing_Size.Width = 121
$comboBox1.Size = $System_Drawing_Size
$comboBox1.TabIndex = 0
$comboBox1.DropDownStyle = 2
$comboBox1.add_SelectedIndexChanged($handler_comboBox1_SelectedIndexChanged)

$form1.Controls.Add($comboBox1)

#Save the initial state of the form
$InitialFormWindowState = $form1.WindowState
#Init the OnLoad event to correct the initial state of the form
$form1.add_Load($OnLoadForm_StateCorrection)
#Show the Form
$form1.ShowDialog()| Out-Null

} #End Function

#Call the Function
GenerateForm