#############################################################################
#                                     			 		                    #
#   This Sample Code is provided for the purpose of illustration only       #
#   and is not intended to be used in a production environment.  THIS       #
#   SAMPLE CODE AND ANY RELATED INFORMATION ARE PROVIDED "AS IS" WITHOUT    #
#   WARRANTY OF ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT    #
#   LIMITED TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS     #
#   FOR A PARTICULAR PURPOSE.  We grant You a nonexclusive, royalty-free    #
#   right to use and modify the Sample Code and to reproduce and distribute #
#   the object code form of the Sample Code, provided that You agree:       #
#   (i) to not use Our name, logo, or trademarks to market Your software    #
#   product in which the Sample Code is embedded; (ii) to include a valid   #
#   copyright notice on Your software product in which the Sample Code is   #
#   embedded; and (iii) to indemnify, hold harmless, and defend Us and      #
#   Our suppliers from and against any claims or lawsuits, including        #
#   attorneys' fees, that arise or result from the use or distribution      #
#   of the Sample Code.                                                     #
#                                     			 		                    #
#   Author: Koos Botha                                                      #
#   Version 2.0         Date Last modified:      10 June 2019           #
#                                     			 		                    #
#############################################################################

#Requires -version 5
#requires -modules @{ModuleName="AzureRM.Resources"; ModuleVersion="4.0.0"}, @{ModuleName="Azure"; ModuleVersion="4.0.0"}

[void][reflection.assembly]::Load("System.Windows.Forms, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089")
$Form 		= New-Object System.Windows.Forms.Form
$Form.ShowIcon = $false
$Form.Text = 'Azure VM Deployment Tool v2.0'
$Form.Width = 530
$Form.Height = 700
$WarningPreference = 'SilentlyContinue'
#Main Form Controls
$Tabs  = New-Object System.Windows.Forms.TabControl
$Tabpage1 = New-Object System.Windows.Forms.TabPage
$Tabpage2 = New-Object System.Windows.Forms.TabPage
$btnLogin = New-Object System.Windows.Forms.Button
$cmbSubscription  = New-Object System.Windows.Forms.ComboBox
$lblSubscription =  New-Object System.Windows.Forms.Label
[System.Collections.ArrayList]$array = @() 

#region Main Form location

$btnLogin.Location = '20, 30'
$cmbSubscription.Location =  '200,30'
$cmbSubscription.Width = '300'
$btnLogin.Text = 'Login'

$cmbSubscription.Text = "Login and Select Subscription first..."



#endregion


$Tabpage1.Name = "Tabpage1"
$Tabpage2.Name = "Tabpage2"

$Tabpage1.Text = "Deploy from Existing VHD"
$Tabpage2.Text = "Deploy from Customized Image"


$Tabs.Location = '20,70'

$tabs.Size = '480, 580'
$tabs.TabPages.Add($Tabpage1)
$tabs.TabPages.Add($Tabpage2)



#Tap Page 1 - Deploy from Existing VHD
#region Tap Page 1
$lblTP1ResourceGroup = New-Object System.Windows.Forms.Label
$lblTP1OSStorageAccount = New-Object System.Windows.Forms.Label
$lblTP1DataStorageAccount = New-Object System.Windows.Forms.Label
$lblTP1VMName = New-Object System.Windows.Forms.Label
$lblTP1Location = New-Object System.Windows.Forms.Label
$lblTP1Avset = New-Object System.Windows.Forms.Label
$lblTP1NIcName = New-Object System.Windows.Forms.Label
$lblTP1Pip = New-Object System.Windows.Forms.Label
$lblTP1VMSize = New-Object System.Windows.Forms.Label
$lblTP1Network = New-Object System.Windows.Forms.Label
$lblTP1Subnet = New-Object System.Windows.Forms.Label
$lblTP1OSVHD  = New-Object System.Windows.Forms.Label
$lblTP1DataVHD  = New-Object System.Windows.Forms.Label

$cmbTp1OSType = New-Object System.Windows.Forms.ComboBox

$cmbTP1ResourceGroup= New-Object System.Windows.Forms.ComboBox
$cmbTP1OSStorageAccount = New-Object System.Windows.Forms.ComboBox
$cmbTP1DataStorageAccount = New-Object System.Windows.Forms.ComboBox
$cmbTP1VMName = New-Object System.Windows.Forms.TextBox
$cmbTP1Location = New-Object System.Windows.Forms.ComboBox
$cmbTP1Avset = New-Object System.Windows.Forms.ComboBox
$cmbTP1NIcName = New-Object System.Windows.Forms.ComboBox
$cmbTP1MDisks = New-Object System.Windows.Forms.CheckBox
$cmbTP1VMSize = New-Object System.Windows.Forms.ComboBox
$cmbTP1Network = New-Object System.Windows.Forms.ComboBox
$cmbTP1Subnet = New-Object System.Windows.Forms.ComboBox
$cmbTP1OSVHD = New-Object System.Windows.Forms.ComboBox
$cmbTP1DataVHD = New-Object System.Windows.Forms.ComboBox
$cmbTP1DataVHDGrid = New-Object System.Windows.Forms.DataGridView
$btnTP1Add =  New-Object System.Windows.Forms.Button
$btnTP1Deploy =  New-Object System.Windows.Forms.Button


$Splashform = New-Object System.Windows.Forms.Form
$Splashform.MaximizeBox = $false
$Splashform.MinimizeBox = $false
$Splashform.ShowIcon = $false
$Splashform.ControlBox = $false
$Splashform.Width = '350'
$Splashform.Height = '70'
$splashform.Visible = $false
$splashbusy = New-Object System.Windows.Forms.Label
$splashbusy.Width = '300'
$splashbusy.Height = 50
$splashbusy.Text = 'Processing...'
$splashbusy.Location = '20, 10'
$Splashform.Controls.Add($splashbusy)

$Form.Location = '156, 156'
$Splashform.Location = "$($Form.Location.X + 100), $($Form.Location.Y + 200)"

'Lun','DataDisk'| %{$cmbTP1DataVHDGrid.Columns.Add($_,$_)} | Out-Null
$lblTP1ResourceGroup.text = 'Destination Resourcegroup'
$lblTP1OSStorageAccount.text = 'OS Disk Storage Account'
$lblTP1DataStorageAccount.text = 'Data Disk Storage Account'
$lblTP1VMName.text = 'Virtual Machine Name'
$lblTP1Location.text = 'Location'
$lblTP1Avset.text = 'Availibilty Set'
$lblTP1NIcName.text = 'NIC Name'
$lblTP1Pip.text = 'Managed Disk'
$lblTP1VMSize.text = 'Virtual Machine Size'
$lblTP1Network.text = 'Destination Network'
$lblTP1Subnet.text = 'Destination Subnet'
$cmbTP1MDisks.Text = '     Operatingsystem'

$lblTP1OSVHD.Text = 'OS Disk'
$lblTP1DataVHD.Text = 'Data Disk'
$btnTP1Add.Text = '+'
$btnTP1Deploy.Text = 'Deploy VM'

$lblTP1ResourceGroup.Location = '10, 10'
$lblTP1Location.Location = '10, 40'
$lblTP1VMName.Location = '10, 70'
$lblTP1VMSize.Location = '10, 100'
$lblTP1NIcName.Location = '10, 130'
$lblTP1Pip.Location = '10,160'
$cmbTP1MDisks.Location = '200, 160'
$cmbTp1OSType.Location = '330, 160'
$btnTP1Deploy.Location = '375, 525'

$lblTP1OSStorageAccount.Location = '10,190'
$lblTP1DataStorageAccount.Location = '10, 220'
$lblTP1Network.Location = '10, 250'
$lblTP1Subnet.Location = '10, 280'
$lblTP1Avset.Location = '10, 310'
$lblTP1OSVHD.Location = '10, 340'
$lblTP1DataVHD.Location = '10, 370'


$cmbTP1ResourceGroup.Location = '200, 10'
$cmbTP1Location.Location = '200, 40'
$cmbTP1VMName.Location = '200, 70'
$cmbTP1VMSize.Location = '200, 100'
$cmbTP1NIcName.Location = '200, 130'
$cmbTP1OSStorageAccount.Location = '200,190'
$cmbTP1DataStorageAccount.Location = '200, 220'
$cmbTP1Network.Location = '200, 250'
$cmbTP1Subnet.Location = '200, 280'
$cmbTP1Avset.Location = '200, 310'
$cmbTP1OSVHD.Location = '200, 340'
$cmbTP1DataVHD.Location = '200, 370'
$cmbTP1DataVHDGrid.Location = '10, 400'
$btnTP1Add.Location = '425, 370'

$lblTP1ResourceGroup.Width = '180'
$lblTP1VMName.Width = '180'
$lblTP1VMSize.Width = '180'
$lblTP1NIcName.Width = '180'
$lblTP1Pip.Width = '180'
$lblTP1Location.Width = '180'
$lblTP1OSStorageAccount.Width = '180'
$lblTP1DataStorageAccount.Width = '180'
$lblTP1Network.Width = '180'
$lblTP1Subnet.Width = '180'
$lblTP1Avset.Width = '180'
$lblTP1OSVHD.Width = '180'
$lblTP1DataVHD.Width = '180'
$cmbTP1MDisks.Width = '130'

$cmbTP1ResourceGroup.Width = '250'
$cmbTP1VMName.Width = '250'
$cmbTP1VMSize.Width = '250'
$cmbTP1NIcName.Width = '250'
$cmbTP1Location.Width = '250'
$cmbTP1OSStorageAccount.Width = '250'
$cmbTP1DataStorageAccount.Width = '250'
$cmbTP1Network.Width = '250'
$cmbTP1Subnet.Width = '250'
$cmbTP1Avset.Width = '250'
$cmbTP1OSVHD.Width = '250'
$cmbTP1DataVHD.Width = '220'
$cmbTP1DataVHDGrid.Width = '440'
$cmbTP1DataVHDGrid.Height = '120'
$btnTP1Add.Width = 25

#endregion

#region page 2
$lblTP2ResourceGroup = New-Object System.Windows.Forms.Label
$lblTP2VMName = New-Object System.Windows.Forms.Label
$lblTP2Location = New-Object System.Windows.Forms.Label
$lblTP2Avset = New-Object System.Windows.Forms.Label
$lblTP2NIcName = New-Object System.Windows.Forms.Label
$lblTP2Pip = New-Object System.Windows.Forms.Label
$lblTP2VMSize = New-Object System.Windows.Forms.Label
$lblTP2Network = New-Object System.Windows.Forms.Label
$lblTP2Subnet = New-Object System.Windows.Forms.Label
$lblTP2OSVHD  = New-Object System.Windows.Forms.Label
$lblTP2DiskType  = New-Object System.Windows.Forms.Label
$lblTP2DataVHD  = New-Object System.Windows.Forms.Label
$lblTP2DiskSize  = New-Object System.Windows.Forms.Label
$lblTP2FromImage  = New-Object System.Windows.Forms.Label
$lblTp2OSType = New-Object System.Windows.Forms.Label

$cmbTp2OSType = New-Object System.Windows.Forms.ComboBox
$cmbTP2ResourceGroup = New-Object System.Windows.Forms.ComboBox
$cmbTP2VMName = New-Object System.Windows.Forms.TextBox
$cmbTP2Location = New-Object System.Windows.Forms.ComboBox
$cmbTP2Avset = New-Object System.Windows.Forms.ComboBox
$cmbTP2NIcName = New-Object System.Windows.Forms.ComboBox
$cmbTP2VMSize = New-Object System.Windows.Forms.ComboBox
$cmbTP2Network = New-Object System.Windows.Forms.ComboBox
$cmbTP2Subnet = New-Object System.Windows.Forms.ComboBox
$cmbTP2OSVHD = New-Object System.Windows.Forms.TextBox
$cmbTP2DiskType = New-Object System.Windows.Forms.ComboBox
$cmbTP2DataVHD = New-Object System.Windows.Forms.TextBox
$cmbTP2DataVHDGrid = New-Object System.Windows.Forms.DataGridView
$btnTP2Add =  New-Object System.Windows.Forms.Button
$btnTP2Deploy =  New-Object System.Windows.Forms.Button
$txtTP2DiskSize = New-Object System.Windows.forms.TextBox
$cmbTP2FromImage = New-Object System.Windows.Forms.ComboBox   
$cmbTp2OSType = New-Object System.Windows.Forms.ComboBox

'Lun','DataDisk','Size'| %{$cmbTP2DataVHDGrid.Columns.Add($_,$_)} | Out-Null
'PremiumLRS','StandardLRS' | %{$cmbTP2DiskType.Items.Add($_)} | Out-Null
$cmbTP2DiskType.SelectedIndex = 1
'Windows','Linux' |%{$cmbTp1OSType.Items.Add($_);$cmbTp2OSType.Items.Add($_)} |Out-Null
$cmbTp1OSType.SelectedIndex = 0
$cmbTp2OSType.SelectedIndex = 0

$cmbTp2OSType.DropDownStyle = 'DropDownList'
$cmbTP2ResourceGroup.DropDownStyle = 'DropDownList'
$cmbTP2Location.DropDownStyle = 'DropDownList'
$cmbTP2Avset.DropDownStyle = 'DropDownList'
$cmbTP2VMSize.DropDownStyle = 'DropDownList'
$cmbTP2Network.DropDownStyle = 'DropDownList'
$cmbTP2Subnet.DropDownStyle = 'DropDownList'
$cmbTP2DiskType.DropDownStyle = 'DropDownList'
$cmbTP2FromImage.DropDownStyle = 'DropDownList'   
$cmbTp1OSType.DropDownStyle = 'DropDownList'
$cmbTP1ResourceGroup.DropDownStyle = 'DropDownList'
$cmbTP1OSStorageAccount.DropDownStyle = 'DropDownList'
$cmbTP1DataStorageAccount.DropDownStyle = 'DropDownList'
$cmbTP1Location.DropDownStyle = 'DropDownList'
$cmbTP1Avset.DropDownStyle = 'DropDownList'


$cmbTP1VMSize.DropDownStyle = 'DropDownList'
$cmbTP1Network.DropDownStyle = 'DropDownList'
$cmbTP1Subnet.DropDownStyle = 'DropDownList'
$cmbTP1OSVHD.DropDownStyle = 'DropDownList'
$cmbTP1DataVHD.DropDownStyle = 'DropDownList'

$lblTP2FromImage.Text = "Deploy From Image"
$lblTP2ResourceGroup.text = 'Destination Resourcegroup'
$lblTP2VMName.text = 'Virtual Machine Name'
$lblTP2Location.text = 'Location'
$lblTP2Avset.text = 'Availibilty Set'
$lblTP2NIcName.text = 'NIC Name'
$lblTp2OSType.Text = 'Operatingsystem'

$lblTP2VMSize.text = 'Virtual Machine Size'
$lblTP2Network.text = 'Destination Network'
$lblTP2Subnet.text = 'Destination Subnet'

$lblTP2OSVHD.Text = 'OS Disk Name'
$lblTP2DataVHD.Text = 'Data Disk Name'
$btnTP2Add.Text = '+'
$btnTP2Deploy.Text = 'Deploy VM'
$lblTP2DiskSize.Text = 'Size (GB)'
$lblTP2DiskType.Text = 'Type'

$txtTP2DiskSize.Text = 1023

$lblTP2FromImage.Location = '10, 10'
$lblTP2ResourceGroup.Location = '10, 40'
$lblTP2Location.Location = '10, 70'
$lblTP2VMName.Location = '10, 100'
$lblTP2VMSize.Location = '10, 130'
$lblTP2NIcName.Location = '10, 160'
$lblTP2Pip.Location = '10,190'
$lblTp2OSType.Location = '10, 190'
$btnTP2Deploy.Location = '375,500'

$lblTP2Network.Location = '10, 220'
$lblTP2Subnet.Location = '10, 250'
$lblTP2Avset.Location = '10, 280'
$lblTP2OSVHD.Location = '10, 320'
$lblTP2DiskType.Location = '330, 315'
$lblTP2DataVHD.Location = '10, 350'
$lblTP2DiskSize.Location = '305, 345'

$cmbTP2FromImage.Location = '200, 10'
$cmbTP2ResourceGroup.Location = '200, 40'
$cmbTP2Location.Location = '200, 70'
$cmbTP2VMName.Location = '200, 100'
$cmbTP2VMSize.Location = '200, 130'
$cmbTP2NIcName.Location = '200, 160'
$cmbTp2OSType.Location = '200, 190'

$cmbTP2Network.Location = '200, 220'
$cmbTP2Subnet.Location = '200, 250'
$cmbTP2Avset.Location = '200, 280'
$cmbTP2OSVHD.Location = '200, 310'
$cmbTP2DiskType.Location = '360, 310'
$cmbTP2DataVHD.Location = '200, 340'
$cmbTP2DataVHDGrid.Location = '10, 370'
$btnTP2Add.Location = '425, 338'
$txtTP2DiskSize.Location = '360, 340'

$txtTP2DiskSize.MaxLength = 4

$lblTP2FromImage.Width = '180'
$lblTP2ResourceGroup.Width = '180'
$lblTP2VMName.Width = '180'
$lblTP2VMSize.Width = '180'
$lblTP2NIcName.Width = '180'
$lblTP2Pip.Width = '180'
$lblTP2Location.Width = '180'

$lblTP2Network.Width = '180'
$lblTP2Subnet.Width = '180'
$lblTP2Avset.Width = '180'
$lblTP2OSVHD.Width = '180'
$lblTP2DataVHD.Width = '180'
$lblTP2DiskSize.Width = '53'
$cmbTP2DiskType.Width = '90'

$cmbTP2FromImage.Width = '250'
$cmbTP2ResourceGroup.Width = '250'
$cmbTP2VMName.Width = '250'
$cmbTP2VMSize.Width = '250'
$cmbTP2NIcName.Width = '250'

$cmbTP2Location.Width = '250'

$cmbTP2Network.Width = '250'
$cmbTP2Subnet.Width = '250'
$cmbTP2Avset.Width = '250'
$cmbTP2OSVHD.Width = '100'
$cmbTP2DataVHD.Width = '100'
$cmbTP2DataVHDGrid.Width = '440'
$cmbTP2DataVHDGrid.Height = '120'
$btnTP2Add.Width = 25
$txtTP2DiskSize.Width = 60

#endregion
#Adding Controlls to Main Form
$tabs,$btnLogin,$lblSubscription,$cmbSubscription | %{$Form.Controls.Add($_)}
Get-Variable *TP1* | %{$Tabpage1.Controls.Add($_.Value)}

Get-Variable *TP2* | %{$Tabpage2.Controls.Add($_.Value)}
[System.Collections.ArrayList]$AzM_Disks = @()
[System.Collections.ArrayList]$AZ_Nics = @()
$StorageDisks = @{}
$DiskConfig = @{}
$DeployVM = @{}
Function Get-VHDs
{Param($Resource)
        if ($StorageDisks.ContainsKey($Resource) -eq $false)
        {
       
        $StorageAccount = Get-AzureRmStorageAccount -Name $resource -ResourceGroupName ($array |?{$_.Resourcetype -eq 'Microsoft.Storage/storageAccounts' -and $_.Name -eq $Resource}).ResourceGroupName
        $StorageAccountContainers = @(Get-AzureStorageContainer -Context $StorageAccount.Context )
       $hresult = @{}
       Foreach ($StorageAccountContainer in $StorageAccountContainers)
       {            
                    Foreach ($blob in @(Get-AzureStorageBlob -Container $StorageAccountContainer.Name -Context $StorageAccount.Context -Blob "*.vhd"))
                    {
                   
                    $hresult."$($blob.Name)" = $blob.ICloudBlob.StorageUri.PrimaryUri.OriginalString
                    }
                    
       }
       $StorageDisks."$Resource" = $hresult
         
       }
       Return $StorageDisks.$Resource.Keys
}

Function Load-Combos
{Param( [ValidateSet('Microsoft.Compute/availabilitySets', 'Microsoft.Network/virtualNetworks', 'Microsoft.Compute/disks','Microsoft.Storage/storageAccounts','Microsoft.Compute/images')][String[]]$ResourceType,
[ValidateSet('Page1','Page2')]$TabPage)

Switch ($ResourceType)
{
    'Microsoft.Compute/availabilitySets' {
        IF ($TABPAGE -eq 'Page1')
        {
        $cmbTP1Avset.Items.Clear()
        $array |?{$_.Resourcetype -eq 'Microsoft.Compute/availabilitySets' -and $_.ResourceGroupName -eq $cmbTP1ResourceGroup.Text } |%{ $cmbTP1Avset.Items.Add($_.Name)}  | Out-Null
        }
       else {
       $cmbTP2Avset.Items.Clear()
        $array |?{$_.Resourcetype -eq 'Microsoft.Compute/availabilitySets' -and $_.ResourceGroupName -eq $cmbTP2ResourceGroup.Text} |%{ $cmbTP2Avset.Items.Add($_.Name)}  | Out-Null
        }
        
        }
    'Microsoft.Network/virtualNetworks' {
        IF ($TABPAGE -eq 'Page1')
        {
            $array |?{$_.Resourcetype -eq 'Microsoft.Network/virtualNetworks'} |%{ $cmbTP1Network.Items.Add($_.Name)}  | Out-Null
        }Else{
            $array |?{$_.Resourcetype -eq 'Microsoft.Network/virtualNetworks'} |%{ $cmbTP2Network.Items.Add($_.Name)}  | Out-Null
        }
        
    }

    'Microsoft.Compute/disks' {
        IF ($TABPAGE -eq 'Page1')
        {
          if ($cmbTP1MDisks.Checked -eq $true)
          {
           # $AzM_Disks |?{$_.Resourcetype -eq 'Microsoft.Compute/disks'}| %{ $cmbTP1OSVHD.Items.Add($_.Name)}  | Out-Null
           # $AzM_Disks |?{$_.Resourcetype -eq 'Microsoft.Compute/disks'} |%{ $cmbTP1DataVHD.Items.Add($_.Name)}  | Out-Null
            $AzM_Disks  | ?{$_.ManagedBy.Length -lt '1' -and $_.OsType.length -ge '1'}|%{ $cmbTP1OSVHD.Items.Add($_.Name)}  | Out-Null
            $AzM_Disks | ?{$_.ManagedBy.Length -lt '1' }|%{ $cmbTP1DataVHD.Items.Add($_.Name)}  | Out-Null
          }
          Else
          {
            $array |?{$_.Resourcetype -eq 'Microsoft.Compute/disks'}| %{ $cmbTP1OSVHD.Items.Add($_.Name)}  | Out-Null
            $array |?{$_.Resourcetype -eq 'Microsoft.Compute/disks'} |%{ $cmbTP1DataVHD.Items.Add($_.Name)}  | Out-Null
           } 
        }
        }
    'Microsoft.Storage/storageAccounts' {
        IF ($TABPAGE -eq 'Page1')
        {
            $array |?{$_.Resourcetype -eq 'Microsoft.Storage/storageAccounts'} |%{ $cmbTP1OSStorageAccount.Items.Add($_.Name)}  | Out-Null
            $array |?{$_.Resourcetype -eq 'Microsoft.Storage/storageAccounts'} |%{ $cmbTP1DataStorageAccount.Items.Add($_.Name)}  | Out-Null
        
        }

    }
    'Microsoft.Compute/images' {
    $cmbTP2FromImage.Items.Clear()
          $array |?{$_.Resourcetype -eq 'Microsoft.Compute/images'} |%{ $cmbTP2FromImage.Items.Add($_.Name)}  | Out-Null
    }
}
}

Function Validate-Test
{
Param($page)

    $Splashform.Location = "$($Form.Location.X + 100), $($Form.Location.Y + 200)"
    
    $Splashform.Visible = $true
    [string]$return = ''
Switch ($page)
{
1 {
    if ($cmbTP1ResourceGroup.text -eq '') {$return = $return + 'ResourceGroup;' ;} 
    if ($cmbTP1OSStorageAccount.text -eq '') {if ($cmbTP1MDisks.Checked -eq $false) { $return = $return + 'StorageAccount;'} }
    if ($cmbTP1VMName.text -eq '') {$return = $return + 'VM Name;' }
    if ($cmbTP1Location.text -eq '') {$return = $return + 'Location;'  }
    if ($cmbTP1NIcName.text -eq '') {$return = $return + 'Nic Name;' }
    if ($cmbTP1VMSize.text -eq '') {$return = $return + 'VM Size;' }
    if ($cmbTP1Network.text -eq '') {$return = $return + 'Network;' }
    if ($cmbTP1Subnet.text -eq '') {$return = $return + 'Subnet;' }
    if ($cmbTP1OSVHD.text -eq '') {$return = $return + 'OS Disk;' }

}
2 {

    IF ($cmbTP2ResourceGroup.Text -eq '') {$return = $return + 'ResourceGroup;' }
    IF ($cmbTP2VMName.Text -eq '') {$return = $return + 'VM Name;'}
    IF ($cmbTP2Location.Text -eq '') {$return = $return + 'Location;'}
    IF ($cmbTP2NIcName.Text -eq '') {$return = $return + 'Nic Name;'}
    IF ($cmbTP2VMSize.Text -eq '') {$return = $return + 'VM Size;'}
    IF ($cmbTP2Network.Text -eq '') {$return = $return + 'Network;'}
    IF ($cmbTP2Subnet.Text -eq '') {$return = $return + 'Subnet;'}
    IF ($cmbTP2OSVHD.Text -eq '') {$return = $return + 'OS Disk;'}
    
    IF ($txtTP2DiskSize.Text -eq '') {IF ($cmbTP2DataVHD.Text -ne '') {$return = $return + 'Data Disk Size;'}}
    IF ($cmbTP2FromImage.Text -eq '') {$return = $return + 'From Image'}   

}
}
If ($return -ne '')
{
$splashbusy.Text = $return + 'Cannot by Null or Empty'
$Splashform.Visible = $true
Start-Sleep 5
$Splashform.Visible = $false
Return 'Stop'
}
}

$cmbTP1ResourceGroup.add_SelectedValueChanged(
    {
Load-Combos -ResourceType 'Microsoft.Compute/availabilitySets'  -TabPage Page1
})

$cmbTP2ResourceGroup.add_SelectedValueChanged({
Load-Combos -ResourceType 'Microsoft.Compute/availabilitySets'  -TabPage Page2
})

$cmbSubscription.add_SelectedValueChanged({

    $Splashform.Location = "$($Form.Location.X + 100), $($Form.Location.Y + 200)"

    $splashbusy.Text = "Getting your Subscription Details"
    $Splashform.Visible = $true

        Select-AzureRmSubscription -SubscriptionName $cmbSubscription.Text 

            $cmbTP1ResourceGroup.Items.Clear() | Out-Null
            $cmbTP1Location.Items.Clear() | Out-Null
            $cmbTP1OSStorageAccount.Items.Clear()
            $cmbTP1DataStorageAccount.Items.Clear()
            $cmbTP1OSVHD.Items.Clear()
            $cmbTP1DataVHD.Items.Clear()

            $cmbTP2ResourceGroup.Items.Clear() | Out-Null
            $cmbTP2Location.Items.Clear() | Out-Null
            $cmbTP2FromImage.Items.Clear()


                
                Get-AzureRmResourceGroup | select ResourceGroupName -ExpandProperty ResourceGroupName |%{ $cmbTP1ResourceGroup.Items.Add($_);$cmbTP2ResourceGroup.Items.Add($_)}  | Out-Null
                Get-AzureRmLocation | %{$cmbTP1Location.Items.Add($_.Location);$cmbTP2Location.Items.Add($_.Location)}  | Out-Null
                Get-AzureRmDisk |%{$AzM_Disks.Add($_) } |Out-Null
                Get-AzureRmResource |%{$array.Add($_)} |Out-Null
                Get-AzureRmNetworkInterface | ?{$_.VirtualMachine.length -lt 1} |%{$AZ_Nics.add($_)}
                $AZ_Nics |%{$cmbTP2NIcName.Items.Add($_.Name) |Out-Null ;$cmbTP1NIcName.Items.Add($_.Name) |Out-Null }

                Load-Combos -ResourceType  'Microsoft.Compute/disks','Microsoft.Network/virtualNetworks','Microsoft.Storage/storageAccounts' -TabPage Page1
                Load-Combos -ResourceType  'Microsoft.Compute/disks','Microsoft.Network/virtualNetworks','Microsoft.Storage/storageAccounts','Microsoft.Compute/images' -TabPage Page2


    $Splashform.Visible = $false
})

$cmbTP1Network.add_SelectedValueChanged({

        $Splashform.Location = "$($Form.Location.X + 100), $($Form.Location.Y + 200)"

        $splashbusy.Text = "Getting Networking information..."
        $Splashform.Visible = $true

        $cmbTP1Subnet.Items.Clear()
        (Get-AzureRmVirtualNetwork  |?{$_.Name -eq $cmbTP1Network.Text}).Subnets.name | %{$cmbTP1Subnet.Items.Add($_)}
        $Splashform.Visible = $false
})

$cmbTP2Network.add_SelectedValueChanged({

        $Splashform.Location = "$($Form.Location.X + 100), $($Form.Location.Y + 200)"

        $splashbusy.Text = "Getting Networking information..."
        $Splashform.Visible = $true

        $cmbTP2Subnet.Items.Clear()
        (Get-AzureRmVirtualNetwork  |?{$_.Name -eq $cmbTP2Network.Text}).Subnets.name | %{$cmbTP2Subnet.Items.Add($_)}
        $Splashform.Visible = $false
})

$cmbTP1Location.add_SelectedValueChanged({

        $Splashform.Location = "$($Form.Location.X + 100), $($Form.Location.Y + 200)"

        $splashbusy.Text = "Retrieving Azure VM sizes for location..."
        $Splashform.Visible = $true

        Get-AzureRmVMSize -Location $cmbTP1Location.Text | %{$cmbTP1VMSize.items.Add($_.Name)}
        $Splashform.Visible = $false
})

$cmbTP2Location.add_SelectedValueChanged({

        $Splashform.Location = "$($Form.Location.X + 100), $($Form.Location.Y + 200)"

        $splashbusy.Text = "Retrieving Azure VM sizes for location..."
        $Splashform.Visible = $true

        Get-AzureRmVMSize -Location $cmbTP2Location.Text | %{$cmbTP2VMSize.items.Add($_.Name)}
        $Splashform.Visible = $false
})

$btnTP1Add.add_Click({
if ($cmbTP1MDisks.Checked -eq $false)
{
    [int]$LunCNt = "$(($DiskConfig.count) + 1)"
    $DiskConfig.$LunCNt = [PSCustomObject]@{StorageAccount = $cmbTP1DataStorageAccount.Text
                                    Caching =  'None'
                                    VhdUri  = "$($StorageDisks."$($cmbTP1DataStorageAccount.Text)"."$($cmbTP1DataVHD.text)")"
                                    CreateOption = 'attach' 
                                    Lun = "$(($DiskConfig.count) )"
                                    Name = ("$($StorageDisks."$($cmbTP1DataStorageAccount.Text)"."$($cmbTP1DataVHD.text)")" -split '/')[-1]
                                                                }
$cmbTP1DataVHDGrid.rows.Add(($cmbTP1DataVHDGrid.RowCount - 1),$cmbTP1DataVHD.Text)
}else
{
 [int]$LunCNt = "$(($DiskConfig.count) + 1)"
 $DiskConfig.$LunCNt = [PSCustomObject]@{RID =  ($array |?{$_.Resourcetype -eq 'Microsoft.Compute/disks' -and $_.Name -eq $cmbTP1DataVHD.Text}).ResourceId
                                    Caching =  'None'
                                    CreateOption = 'attach' 
                                    Lun = "$(($DiskConfig.count) )"
                                    Name = ( ($array |?{$_.Resourcetype -eq 'Microsoft.Compute/disks' -and $_.Name -eq $cmbTP1DataVHD.Text}).ResourceId -split '/')[-1]
                           }
                           $cmbTP1DataVHDGrid.rows.Add(($cmbTP1DataVHDGrid.RowCount - 1),$cmbTP1DataVHD.Text)  | Out-Null  
}
})

$btnTP2Add.add_Click({

[int]$LunCNt = "$(($DiskConfig.count) + 1)"
 $DiskConfig.$LunCNt = [PSCustomObject]@{
                                    Caching =  'None'
                                    CreateOption = 'Empty' 
                                    Lun = "$(($DiskConfig.count) )"
                                    Name = $cmbTP2DataVHD.Text
                                    AccountType = $cmbTP2DiskType.text 
                                    Location = $cmbTP2Location.Text
                                    DiskSizeGB = $txtTP2DiskSize.Text
                           }
                           $cmbTP2DataVHDGrid.rows.Add(([int]$LunCNt),$cmbTP2DataVHD.Text,$txtTP2DiskSize.text)  | Out-Null  

})

$cmbTP1MDisks.add_CheckedChanged({
    $cmbTP1OSStorageAccount.Items.Clear()
    $cmbTP1DataStorageAccount.Items.Clear()
    $cmbTP1OSVHD.Items.Clear()
    $cmbTP1DataVHD.Items.Clear()

        IF($cmbTP1MDisks.Checked -eq $true)
            {
            $cmbTP1OSStorageAccount.Enabled = $false
            $cmbTP1DataStorageAccount.Enabled = $false
            #$array |?{$_.Resourcetype -eq 'Microsoft.Compute/disks'}| %{ $cmbTP1OSVHD.Items.Add($_.Name)}  | Out-Null
            #$array |?{$_.Resourcetype -eq 'Microsoft.Compute/disks'} |%{ $cmbTP1DataVHD.Items.Add($_.Name)}  | Out-Null
            $AzM_Disks | ?{$_.ManagedBy.Length -lt '1' -and $_.OSType.length -ge '1'}|%{ $cmbTP1OSVHD.Items.Add($_.Name)}  | Out-Null
            $AzM_Disks | ?{$_.ManagedBy.Length -lt '1'}|%{ $cmbTP1DataVHD.Items.Add($_.Name)}  | Out-Null
            
            } else
            {
            $cmbTP1OSStorageAccount.Enabled = $true
            $cmbTP1DataStorageAccount.Enabled = $true
            $array |?{$_.Resourcetype -eq 'Microsoft.Storage/storageAccounts'} |%{ $cmbTP1OSStorageAccount.Items.Add($_.Name)}  | Out-Null
            $array |?{$_.Resourcetype -eq 'Microsoft.Storage/storageAccounts'} |%{ $cmbTP1DataStorageAccount.Items.Add($_.Name)}  | Out-Null
            }


})

$btnLogin.add_click({

        $Splashform.Location = "$($Form.Location.X + 100), $($Form.Location.Y + 200)"

        $splashbusy.Text = "Logging into Azure"
        $Splashform.Visible = $true
        login-AzureRmAccount -ErrorAction Stop 
        Get-AzureRmSubscription -ErrorVariable SubError -ErrorAction SilentlyContinue | %{$cmbSubscription.Items.Add($_.Name)} | Out-Null
        $cmbSubscription.DropDownStyle = 'DropDownList'
        $cmbSubscription.SelectedIndex = 0
        $Splashform.Visible = $false

})

$cmbTP1OSStorageAccount.add_SelectedValueChanged(
    {
        $Splashform.Location = "$($Form.Location.X + 100), $($Form.Location.Y + 200)"
        $splashbusy.Text = "Getting Possible VHDs from storage account..."
        $Splashform.Visible = $true
        $cmbTP1OSVHD.Items.Clear()
        Get-VHDs -Resource $cmbTP1OSStorageAccount.Text | Sort-Object |%{$cmbTP1OSVHD.Items.Add($_)} |Out-Null
        $Splashform.Visible = $false
}
)

$cmbTP1DataStorageAccount.add_SelectedValueChanged(
    {
        $Splashform.Location = "$($Form.Location.X + 100), $($Form.Location.Y + 200)"
        $splashbusy.Text = "Getting Possible VHDs from storage account..."
        $Splashform.Visible = $true
        $cmbTP1DataVHD.Items.Clear()
        Get-VHDs -Resource $cmbTP1DataStorageAccount.Text | Sort-Object |%{$cmbTP1DataVHD.Items.Add($_)} |Out-Null
        $Splashform.Visible = $false

})

$btnTP1Deploy.add_Click({

if ((Validate-Test -page 1) -ne 'Stop')
{
    $Splashform.Location = "$($Form.Location.X + 100), $($Form.Location.Y + 200)"

    $splashbusy.Text = "Deploying Virtual Machine, this might take a while..."
    $Splashform.Visible = $true
    try{
        $splashbusy.Text = "Starting VM Deployment...Getting Network..."
        $Network = Get-AzureRmVirtualNetwork -Name $cmbTP1Network.Text -ResourceGroupName ($array |?{$_.Resourcetype -eq 'Microsoft.Network/virtualNetworks' -and $_.Name -eq $cmbTP1Network.Text}).ResourceGroupName 
        $splashbusy.Text = "Starting VM Deployment...Getting Subnet..."
        $Subnet = Get-AzureRmVirtualNetworkSubnetConfig -VirtualNetwork $Network -Name $cmbTP1Subnet.Text
         $splashbusy.Text = "Starting VM Deployment...Creating Network Card..."
        
            If (@($AZ_Nics.Name) -contains $cmbTP1NIcName.Text)
            {
            $Nic = Get-AzureRmNetworkInterface |?{$_.Name -eq $cmbTP1NIcName.Text}
             }
             Else
            {
            $Nic= New-AzureRmNetworkInterface -ResourceGroupName $cmbTP1ResourceGroup.Text -Name $cmbTP1NIcName.Text -Subnet $Subnet -Location $cmbTP1Location.Text
            }
        
        $avSet = ($array |?{$_.Resourcetype -eq 'Microsoft.Compute/availabilitySets' -and $_.Name -eq $cmbTP1Avset.Text}).ResourceId
        $splashbusy.Text = "Starting VM Deployment...Checking Availabiltiy Set..."
        $Params = @{VMName = $cmbTP1VMName.Text 
                VMSize  = $cmbTP1VMSize.Text
                }
        
        IF ($avSet -ne $null)
        {$Params.AvailabilitySetId = $avSet}
        

        if ($cmbTP1MDisks.Checked -eq $true)
        {
        $OSVhdUri = ($array |?{$_.Resourcetype -eq 'Microsoft.Compute/disks' -and $_.Name -eq $cmbTP1OSVHD.Text}).ResourceId
        #New-AzureRmVMConfig –VMName $cmbTP1VMName.Text	-VMSize $cmbTP1VMSize.Text  -AvailabilitySetId $avSet
        $DeployVM."$($cmbTP1VMName.Text)" = New-AzureRmVMConfig @Params #| `
        Set-AzureRmVMOSDisk -VM $DeployVM."$($cmbTP1VMName.Text)" -ManagedDiskId $OSVhdUri -CreateOption Attach -Windows
        foreach ($Dsk in $DiskConfig.Keys)
            {
            $data = $DiskConfig.$dsk
            $DeployVM."$($cmbTP1VMName)" = Add-AzureRmVMDataDisk -VM $DeployVM."$($cmbTP1VMName.Text)" -Name $data.Name -ManagedDiskId $data.RID -Lun $data.Lun -Caching $data.Caching -CreateOption $data.CreateOption
            }
        
        }Else
        {
        $OSVhdUri = $StorageDisks."$($cmbTP1OSStorageAccount.text)"."$($cmbTP1OSVHD.text)"
        

        IF ($cmbTp1OSType.Text -eq 'Windows')
                { 
                        $DeployVM."$($cmbTP1VMName.Text)" = New-AzureRmVMConfig @Params | `
                        Set-AzureRmVMOSDisk -VhdUri $OSVhdUri -Caching ReadWrite -CreateOption Attach -Name ($OSVhdUri.Split('/')[-1] -replace('.vhd','')) -Windows 
                }
                Else
                {
                        $DeployVM."$($cmbTP1VMName.Text)" = New-AzureRmVMConfig @Params | `
                        Set-AzureRmVMOSDisk -VhdUri $OSVhdUri -Caching ReadWrite -CreateOption Attach -Name ($OSVhdUri.Split('/')[-1] -replace('.vhd','')) -Linux
                }


            
            
            foreach ($Dsk in $DiskConfig.Keys)
            {
            $splashbusy.Text = "Starting VM Deployment...Adding data disks..."
            $data = $DiskConfig.$dsk
            
            $DeployVM."$($cmbTP1VMName)" = Add-AzureRmVMDataDisk -VM $DeployVM."$($cmbTP1VMName.Text)" -Name $data.Name -VhdUri $data.VhdUri -Lun $data.Lun -Caching $data.Caching -CreateOption $data.CreateOption 
            }
        }
    
        Add-AzureRmVMNetworkInterface -Id $nic.Id -VM $DeployVM."$($cmbTP1VMName.Text)"
        #create the VM
        New-AzureRmVM -ResourceGroupName $cmbTP1ResourceGroup.Text -Location $cmbTP1Location.Text -VM $DeployVM."$($cmbTP1VMName.Text)" -ErrorVariable vmresult
            
    }
    Catch{$_.Exception
        $splashbusy.Text = "An error occured $($_.Message)"
        Start-Sleep 10
    }

    if ($vmresult -ne $null)
    {
    $splashbusy.Text = "Deployment Failed!"
    }Else{
    $DiskConfig.Clear()
    $cmbTP1DataVHDGrid.Rows.Clear()
    $splashbusy.Text = "Deployment Done - Successfull!"
    
    }
    Start-Sleep 5
    $Splashform.Visible = $False
}
})

$btnTP2Deploy.add_Click({
if ((Validate-Test -page 2) -ne 'Stop')
{
    $Splashform.Location = "$($Form.Location.X + 100), $($Form.Location.Y + 200)"

    $splashbusy.Text = "Starting VM Deployment..."
    $Splashform.Visible = $true
try{
    $splashbusy.Text = "Starting VM Deployment...Getting Network..."
    $Network = Get-AzureRmVirtualNetwork -Name $cmbTP2Network.Text -ResourceGroupName ($array |?{$_.Resourcetype -eq 'Microsoft.Network/virtualNetworks' -and $_.Name -eq $cmbTP2Network.Text}).ResourceGroupName 
    $splashbusy.Text = "Starting VM Deployment...Getting Subnet..."
    $Subnet = Get-AzureRmVirtualNetworkSubnetConfig -VirtualNetwork $Network -Name $cmbTP2Subnet.Text
    $splashbusy.Text = "Starting VM Deployment...Creating Network Card..."
    
    If (@($AZ_Nics.Name) -contains $cmbTP2NIcName.Text)
    {
    $Nic = Get-AzureRmNetworkInterface |?{$_.Name -eq $cmbTP2NIcName.Text}
    }
    Else
    {
    $Nic= New-AzureRmNetworkInterface -ResourceGroupName $cmbTP2ResourceGroup.Text -Name $cmbTP2NIcName.Text -Subnet $Subnet -Location $cmbTP2Location.Text
    }
    $splashbusy.Text = @"
    Checking Availabiltiy Set...Starting VM Deployment...
    Please wait... This will take a few minutes.
"@
    $avSet = ($array |?{$_.Resourcetype -eq 'Microsoft.Compute/availabilitySets' -and $_.Name -eq $cmbTP2Avset.Text}).ResourceId
    
    $Params = @{VMName = $cmbTP2VMName.Text 
               VMSize  = $cmbTP2VMSize.Text
               }
    
    IF ($avSet -ne $null)
    {$Params.AvailabilitySetId = $avSet}
    
    #manage disk deployment
    $splashbusy.Text = "Starting VM Deployment...Creating VM Config..."
        $DeployVM."$($cmbTP2VMName.Text)" = New-AzureRmVMConfig @Params | `
                Set-AzureRmVMOperatingSystem -Windows -ComputerName $cmbTP2VMName.Text -Credential (Get-Credential -Message 'Please Provide the local Admin Credentials') 
                Set-AzureRmVMSourceImage -VM $DeployVM."$($cmbTP2VMName.Text)" -Id (Get-AzureRmImage -ImageName $cmbTP2FromImage.Text).Id 
                
                
                IF ($cmbTp2OSType.Text -eq 'Windows')
                {
                Set-AzureRmVMOSDisk -vm $DeployVM."$($cmbTP2VMName.Text)" -Caching ReadWrite -CreateOption FromImage -Name $cmbTP2OSVHD.Text -Windows -StorageAccountType $cmbTP2DiskType.Text
                }
                Else
                {
                Set-AzureRmVMOSDisk -vm $DeployVM."$($cmbTP2VMName.Text)" -Caching ReadWrite -CreateOption FromImage -Name $cmbTP2OSVHD.Text -Linux -StorageAccountType $cmbTP2DiskType.Text
                }

                
                foreach ($Dsk in $DiskConfig.Keys)
                    {
                    $splashbusy.Text = "Starting VM Deployment...Adding Data Disks..."
                    $data = $DiskConfig.$dsk
                    $dskcfg = New-AzureRmDiskConfig -AccountType $data.AccountType  -Location $data.Location -CreateOption $data.CreateOption -DiskSizeGB $data.DiskSizeGB
                    $dataDisk = New-AzureRmDisk -DiskName $data.Name -Disk $dskcfg -ResourceGroupName $cmbTP2ResourceGroup.Text
                    $DeployVM."$($cmbTP2VMName)" = Add-AzureRmVMDataDisk -VM $DeployVM."$($cmbTP2VMName.Text)" -Name $data.Name -ManagedDiskId $dataDisk.Id -Lun $data.Lun -Caching $data.Caching -CreateOption Attach
                    }

    Add-AzureRmVMNetworkInterface -Id $nic.Id -VM $DeployVM."$($cmbTP2VMName.Text)"
    #create the VM
    $splashbusy.Text = "Starting VM Deployment...Deploying..."
    New-AzureRmVM -ResourceGroupName $cmbTP2ResourceGroup.Text -Location $cmbTP2Location.Text -VM $DeployVM."$($cmbTP2VMName.Text)" -errorvariable vmresult2
        
}
    Catch{$_.Message
    $splashbusy.Text = "An error occured $($_.Message)"
    Start-Sleep 10
    }


    if ($vmresult2 -ne $null)
        {
        $splashbusy.Text = "Deployment Failed!"
        }Else{
        $DiskConfig.Clear()
        $cmbTP2DataVHDGrid.Rows.Clear()
        $splashbusy.Text = "Deployment Done - Successfull!"
    
        }

    Start-Sleep 5
    $Splashform.Visible = $False
}
})

$form.ShowDialog()