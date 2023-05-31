function New-AvdAadSessionHost {
    <#
    .SYNOPSIS
    Deploys session hosts into a hostpool
    .DESCRIPTION
    Deploys new session hosts into the provided hostpool
    .PARAMETER HostpoolName
    Enter the AVD Hostpool name
    .PARAMETER HostpoolResourceGroup
    Enter the AVD Hostpool resourcegroup name
    .PARAMETER SessionHostCount
    Integer value how many session hosts will be deployed
    .PARAMETER InitialNumber
    The start number of the sessionhost (use Get-AvdLatestSessionhost -numonly)
    .PARAMETER ResourceGroupName
    The session hosts resource group
    .PARAMETER imageVersionId
    The image resourceId, from existing image or image version
    .PARAMETER Publisher
    In case of an Azure Markeplace image, provide the publisher
    .PARAMETER Offer
    In case of an Azure Markeplace image, provide the offer
    .PARAMETER Sku
    In case of an Azure Markeplace image, provide the sku
    .PARAMETER Version
    In case of an Azure Markeplace image, provide the version (default latest)
    .PARAMETER Location
    Enter the session host location
    .PARAMETER DiskType
    Enter the session host diskType
    .PARAMETER LocalAdmin
    Enter the session host local admin account
    .PARAMETER LocalPass
    Enter the session host local admins password
    .PARAMETER Prefix
    Enter the session host prefix
    .PARAMETER SubnetId
    Enter the subnet resource ID where the session host is in
    .PARAMETER Intune
    Switch parameter if you want to add the session host into Intune
    .EXAMPLE
    New-AvdAadSessionHost -HostpoolName avd-hostpool -HostpoolResourceGroup rg-avd-01 -sessionHostCount 1 -ResourceGroupName rg-sessionhosts-01 -Publisher "MicrosoftWindowsDesktop" -Offer "windows-10" -Sku "21h1-ent-g2" -VmSize "Standard_D2s_v3"
    -Location "westeurope" -diskType "Standard_LRS" -LocalAdmin "ladmin" -LocalPass "lpass" -Prefix "AVD" -SubnetId "/subscriptions/../resourceGroups/../providers/Microsoft.Network/virtualNetworks/../subnets/../" -Intune
    .EXAMPLE
    New-AvdAadSessionHost -HostpoolName avd-hostpool -HostpoolResourceGroup rg-avd-01 -sessionHostCount 1 -ResourceGroupName rg-sessionhosts-01 -imageVersionId "/subscriptions/..galleries/../images/../version/21.0.0" -VmSize "Standard_D2s_v3"
    -Location "westeurope" -diskType "Standard_LRS" -LocalAdmin "ladmin" -LocalPass "lpass" -Prefix "AVD" -SubnetId "/subscriptions/../resourceGroups/../providers/Microsoft.Network/virtualNetworks/../subnets/../"
    #>
    [CmdletBinding(DefaultParameterSetName = 'MarketPlace')]
    param
    (
        [parameter(Mandatory)]
        [string]$HostpoolName,
         
        [parameter(Mandatory)]
        [string]$ResourceGroupName,

        [parameter(Mandatory, ParameterSetName = 'Sig')]
        [string]$ImageVersionId,
        
        [parameter(Mandatory)]
        [int]$SessionHostCount,

        [parameter()]
        [int]$InitialNumber,

        [parameter(Mandatory)]
        [string]$Prefix,

        [parameter(Mandatory, ParameterSetName = 'MarketPlace')]
        [string]$Publisher,
    
        [parameter(Mandatory, ParameterSetName = 'MarketPlace')]
        [string]$Offer,

        [parameter(Mandatory, ParameterSetName = 'MarketPlace')]
        [string]$Sku,

        [parameter(ParameterSetName = 'MarketPlace')]
        [string]$Version = "latest",

        [parameter(Mandatory)]
        [string]$VmSize,

        [parameter(Mandatory)]
        [string]$Location,

        [parameter(Mandatory)]
        [ValidateSet("Premium_LRS", "Premium_ZRS", "StandardSSD_LRS", "StandardSSD_ZRS", "Standard_LRS", "UltraSSD_LRS")]
        [string]$DiskType,

        [parameter(Mandatory)]
        [string]$LocalAdmin,

        [parameter(Mandatory)]
        [string]$LocalPass,

        [parameter(Mandatory)]
        [string]$SubnetId,

        [parameter()]
        [switch]$Intune,

        [parameter()]
        [switch]$TrustedLaunch
    )
    Begin {
        Write-Verbose "Start creating session hosts"
        AuthenticationCheck
        $global:token = GetAuthToken -resource $global:AzureApiUrl
        $registrationToken = Update-AvdRegistrationToken -HostpoolName $Hostpoolname $resourceGroupName -HoursActive 4 | Select-Object -ExpandProperty properties
    }
    Process {
        switch ($PsCmdlet.ParameterSetName) {
            Sig {
                $imageReference = @{
                    id = $ImageVersionId
                }
            }
            MarketPlace {
                $imageReference = @{
                    "sku"       = $Sku
                    "publisher" = $Publisher
                    "version"   = $Version
                    "offer"     = $Offer
                }           
            }
            Default {
                Throw "No source for image provided. Please provide a compute imageId or marketplace sources (publisher, offer, sku, version)"
            }
        }
        Do {
            if ($null -eq $InitialNumber) {
                $InitialNumber = Get-AvdLatestSessionHost -HostpoolName $HostpoolName -ResourceGroupName $ResourceGroupName -NumOnly
            }
            $vmName = "{0}-{1}" -f $Prefix, $InitialNumber
            $nicName = "{0}-nic" -f $vmName
            $nicBody = @{
                "properties" = @{
                    "enableAcceleratedNetworking" = $true
                    "ipConfigurations"            = @(
                        @{
                            "name"       = "ipconfig1"
                            "properties" = @{
                                "subnet" = @{
                                    id = $SubnetId
                                }
                            }
                        }
                    )
                }
                "location"   = $Location
            }
            $nicJson = $nicBody | ConvertTo-Json -Depth 15
            $nicUrl = "{0}/subscriptions/{1}/resourceGroups/{2}/providers/Microsoft.Network/networkInterfaces/{3}?api-version=2021-03-01" -f $global:AzureApiUrl, $global:subscriptionId, $ResourceGroupName, $nicName
            $NIC = Invoke-RestMethod -Method PUT -Uri $nicUrl -Headers $global:token -Body $nicJson
            
            try {
                $vmBody = @{
                    location     = $Location
                    identity     = @{
                        type = "SystemAssigned"
                    }
                    "properties" = @{
                        licenseType       = "Windows_Client"
                        "hardwareProfile" = @{
                            "vmSize" = $VmSize
                        }
                        "storageProfile"  = @{
                            "imageReference" = $imageReference
                            "osDisk"         = @{
                                "caching"      = "ReadWrite"
                                "managedDisk"  = @{
                                    "storageAccountType" = $diskType
                                }
                                "name"         = "{0}-os" -f $vmName
                                "createOption" = "FromImage"
                            }
                        }
                        "osProfile"       = @{
                            "adminUsername" = $LocalAdmin
                            "computerName"  = $vmName
                            "adminPassword" = $LocalPass
                        }
                        "networkProfile"  = @{
                            "networkInterfaces" = @(
                                @{
                                    "id"         = $NIC.Id
                                    "properties" = @{
                                        "primary" = $true
                                    }
                                }
                            )
                        }
                    }
                }
                if ($TrustedLaunch.IsPresent) {
                    $securityProfile = @{
                        securityType = "TrustedLaunch"
                        uefiSettings = @{
                            secureBootEnabled = $true
                            vTpmEnabled       = $true  
                        }
                    }
                    $vmBody.properties.Add("securityProfile", $securityProfile)
                }
                $vmUrl = "{0}/subscriptions/{1}/resourceGroups/{2}/providers/Microsoft.Compute/virtualMachines/{3}?api-version={4}" -f $global:AzureApiUrl, $global:subscriptionId, $ResourceGroupName, $vmName, '2021-11-01'
                $vmJsonBody = $vmBody | ConvertTo-Json -Depth 99
                Invoke-RestMethod -Method PUT -Uri $vmUrl -Headers $global:token -Body $vmJsonBody
            }
            catch {
                "VM $vmName not created, $_"
                Throw
            }
            Do {
                $status = Invoke-RestMethod -Method GET -Uri $vmUrl -Headers $global:token
                Start-Sleep 5
            }
            While ($status.properties.provisioningState -ne "Succeeded") {
                Write-Verbose "Host $vmName is ready"
            }          
            try {
                $extensionName = "AADLoginForWindows"
                $domainJoinUrl = "{0}/subscriptions/{1}/resourceGroups/{2}/providers/Microsoft.Compute/virtualMachines/{3}/extensions/{4}?api-version={5}" -f $global:AzureApiUrl, $global:subscriptionId, $ResourceGroupName, $vmName, $extensionName , '2021-11-01'
                $domainJoinExtension = @{
                    properties = @{
                        Type               = "AADLoginForWindows"
                        Publisher          = "Microsoft.Azure.ActiveDirectory"
                        typeHandlerVersion = "1.0"
                    }
                    location   = $Location
                }
                if ($Intune.isPresent) {
                    $settings = @{
                        mdmId = "0000000a-0000-0000-c000-000000000000"
                    }
                    $domainJoinExtension.properties.Add("Settings", $settings)
                }
                $domainJoinBody = $domainJoinExtension | ConvertTo-Json -Depth 99
                Invoke-RestMethod -Method PUT -Uri $domainJoinUrl -Headers $global:token -Body $domainJoinBody
                Do {
                    $status = Invoke-RestMethod -Method GET -Uri $domainJoinUrl -Headers $global:token
                    Start-Sleep 5
                }
                While ($status.properties.provisioningState -ne "Succeeded") {
                    Write-Verbose "Extension $domainJoinName is ready"
                }

                $extensionName = "Microsoft.PowerShell.DSC"
                $avdUrl = "{0}/subscriptions/{1}/resourceGroups/{2}/providers/Microsoft.Compute/virtualMachines/{3}/extensions/{4}?api-version={5}" -f $global:AzureApiUrl, $global:subscriptionId, $ResourceGroupName, $vmName, $extensionName , '2021-11-01'
                $avdDscExtension = @{
                    properties = @{
                        Type               = "DSC"
                        Publisher          = "Microsoft.Powershell"
                        typeHandlerVersion = "2.73"
                        Settings           = @{
                            modulesUrl            = $global:AvdModuleLocation
                            ConfigurationFunction = "Configuration.ps1\AddSessionHost"
                            Properties            = @{
                                hostPoolName          = $HostpoolName
                                registrationInfoToken = $registrationToken.registrationInfo.token
                                aadJoin               = 1
                            }
                        }
                    }
                    location   = $Location
                }
                $avdExtensionBody = $avdDscExtension | ConvertTo-Json -Depth 99
                Invoke-RestMethod -Method PUT -Uri $avdUrl -Headers $global:token -Body $avdExtensionBody
                Do {
                    $status = Invoke-RestMethod -Method GET -Uri $avdUrl -Headers $global:token
                    Start-Sleep 5
                }
                While ($status.properties.provisioningState -ne "Succeeded") {
                    Write-Verbose "Extension for AVD is ready"
                }
            }
            catch {
                Throw $_
            }
            
            $InitialNumber++
            $sessionHostCount--

            Write-Output "$($vmName) deployed"
        }
        while ($sessionHostCount -ne 0) {
            Write-Verbose "Session hosts are created"
        }
        
    }
}