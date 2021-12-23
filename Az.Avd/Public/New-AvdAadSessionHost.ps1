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
    .PARAMETER diskType
    Enter the session host diskType
    .PARAMETER LocalAdmin
    Enter the session host local admin account
    .PARAMETER LocalPass
    Enter the session host local admins password
    .EXAMPLE
    New-AvdAadSessionHost -HostpoolName avd-hostpool -HostpoolResourceGroup rg-avd-01 -sessionHostCount 1 -ResourceGroupName rg-sessionhosts-01 -Publisher "MicrosoftWindowsDesktop" -Offer "windows-10" -Sku "21h1-ent-g2" -VmSize "Standard_D2s_v3"
    -Location "westeurope" -diskType "Standard_LRS" -LocalAdmin "ladmin" -LocalPass "lpass"
    .EXAMPLE
    New-AvdAadSessionHost -HostpoolName avd-hostpool -HostpoolResourceGroup rg-avd-01 -sessionHostCount 1 -ResourceGroupName rg-sessionhosts-01 -imageVersionId "/subscriptions/..galleries/../images/../version/21.0.0" -VmSize "Standard_D2s_v3"
    -Location "westeurope" -diskType "Standard_LRS" -LocalAdmin "ladmin" -LocalPass "lpass"
    #>
    [CmdletBinding(DefaultParameterSetName = 'MarketPlace')]
    param
    (
        [parameter(Mandatory)]
        [string]$HostpoolName,
        
        [parameter(Mandatory)]
        [string]$HostpoolResourceGroup,
    
        [parameter(Mandatory, ParameterSetName = 'Sig')]
        [string]$imageVersionId,
        
        [parameter(Mandatory)]
        [int]$sessionHostCount,

        [parameter(Mandatory)]
        [string]$ResourceGroupName,

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
        [ValidateSet("Premium_LRS", "Premium_ZRS","StandardSSD_LRS","StandardSSD_ZRS","Standard_LRS","UltraSSD_LRS")]
        [string]$diskType,

        [parameter(Mandatory)]
        [string]$LocalAdmin,

        [parameter(Mandatory)]
        [string]$LocalPass
    )
    Begin {
        Write-Verbose "Start searching session hosts"
        AuthenticationCheck
        $token = GetAuthToken -resource $Script:AzureApiUrl
        $apiVersion = "?api-version=2021-07-01"
        $registrationToken = Update-AvdRegistrationToken -HostpoolName $Hostpoolname $resourceGroupName -HoursActive 4 | Select-Object -ExpandProperty properties
    }
    Process {
        switch ($PsCmdlet.ParameterSetName) {
            Sig {
                $imageReference = @{
                    sharedGalleryImageId = $imageVersionId
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
            $script:InitialNumber = 0
            $vmName = "{0}-{1}" -f $Prefix, $script:InitialNumber
            $nicName = "nic-{0}" -f $vmName
            $nicBody = @{
                "properties" = @{
                    "enableAcceleratedNetworking" = $true
                    "ipConfigurations"            = @(
                        @{
                            "name"       = "ipconfig1"
                            "properties" = @{
                                "subnet" = @{
                                    id = $subnetId
                                }
                            }
                        }
                    )
                }
                "location"   = $Location
            }
            $nicJson = $nicBody | ConvertTo-Json -Depth 15
            $nicUrl = "{0}/subscriptions/{1}/resourceGroups/{2}/providers/Microsoft.Network/networkInterfaces/{3}?api-version=2021-03-01" -f $Script:AzureApiUrl, $script:subscriptionId, $ResourceGroupName, $nicName
            $NIC = Invoke-RestMethod -Method PUT -Uri $nicUrl -Headers $script:token -Body $nicJson
            
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
                                "name"         = "disk-{0}" -f $vmName
                                "createOption" = "FromImage"
                            }
                        }
                        "osProfile"       = @{
                            "adminUsername" = $localAdmin
                            "computerName"  = $vmName
                            "adminPassword" = $localPass
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
                $vmUrl = "{0}/subscriptions/{1}/resourceGroups/{2}/providers/Microsoft.Compute/virtualMachines/{3}?api-version={4}" -f $Script:AzureApiUrl, $script:subscriptionId, $ResourceGroupName, $vmName, $apiVersion
                $vmJsonBody = $vmBody | ConvertTo-Json -Depth 99
                Invoke-RestMethod -Method PUT -Uri $vmUrl -Headers $script:token -Body $vmJsonBody
            }
            catch {
                "VM $vmName not created, $_"
                Continue
            }
            Do {
                $status = Invoke-RestMethod -Method GET -Uri $vmUrl -Headers $script:token
                Start-Sleep 5
            }
            While ($status.properties.provisioningState -ne "Succeeded") {
                Write-Verbose "Host $vmName is ready"
            }

                       
            $method = "PUT"
            try {
                $extensionName = "AADLoginForWindows"
                $domainJoinUrl = "{0}/subscriptions/{1}/resourceGroups/{2}/providers/Microsoft.Compute/virtualMachines/{3}/extensions/{4}?api-version={5}" -f $Script:AzureApiUrl, $script:subscriptionId, $ResourceGroupName, $vmName, $domainJoinName , '2021-11-01'
                $domainJoinExtension = @{
                    properties = @{
                        Type               = "AADLoginForWindows"
                        Settings           = @{
                            mdmId = "0000000a-0000-0000-c000-000000000000"
                        }
                        Publisher          = "Microsoft.Azure.ActiveDirectory"
                        typeHandlerVersion = "1.0"
                    }
                    location   = $Location
                }
                $domainJoinBody = $domainJoinExtension | ConvertTo-Json -Depth 99
                Invoke-RestMethod -Method $method -Uri $domainJoinUrl -Headers $script:token -Body $domainJoinBody
                Do {
                    $status = Invoke-RestMethod -Method GET -Uri $domainJoinUrl -Headers $script:token
                    Start-Sleep 5
                }
                While ($status.properties.provisioningState -ne "Succeeded") {
                    Write-Verbose "Extension $domainJoinName is ready"
                }
            }
            catch {
                Throw $_
                continue
            }

            try {
                $extensionName = "Microsoft.PowerShell.DSC"
                $domainJoinUrl = "{0}/subscriptions/{1}/resourceGroups/{2}/providers/Microsoft.Compute/virtualMachines/{3}/extensions/{4}?api-version={5}" -f $Script:AzureApiUrl, $script:subscriptionId, $ResourceGroupName, $vmName, $extensionName , '2021-11-01'
                $avdDscExtension = @{
                    properties         = @{
                        Type               = "DSC"
                        Publisher          = "Microsoft.Powershell"
                        typeHandlerVersion = "2.73"
                        Settings           = @{
                            modulesUrl            = $script:AvdModuleLocation
                            ConfigurationFunction = "Configuration.ps1\AddSessionHost"
                            Properties            = @{
                                hostPoolName          = $HostpoolName
                                registrationInfoToken = $registrationToken.registrationInfo.token
                                aadJoin               = 1
                            }
                        }
                    }
                    location           = $Location
                }
                $avdExtensionBody = $avdDscExtension | ConvertTo-Json -Depth 99
                Invoke-RestMethod -Method $method -Uri $domainJoinUrl -Headers $script:token -Body $avdExtensionBody
                Do {
                    $status = Invoke-RestMethod -Method GET -Uri $domainJoinUrl -Headers $script:token
                    Start-Sleep 5
                }
                While ($status.properties.provisioningState -ne "Succeeded") {
                    Write-Verbose "Extension $domainJoinName is ready"
                }
            }
            catch {
                Throw $_
                continue
            }
            
            $script:InitialNumber++
            $sessionHostCount--

            Write-Output "$($vmName) deployed"
        }
        while ($sessionHostCount -ne 0) {
            Write-Verbose "Session hosts are created"
        }
        
    }
}