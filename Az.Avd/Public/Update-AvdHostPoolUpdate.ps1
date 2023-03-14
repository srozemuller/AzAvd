function Update-AvdHostPoolUpdate {
    <#
.SYNOPSIS
Get AVD Hostpool information.
.DESCRIPTION
With this function you can get information about an AVD hostpool.
.PARAMETER HostPoolName
Enter the name of the hostpool you want information from.
.PARAMETER ResourceGroupName
Enter the name of the resourcegroup where the hostpool resides in.
.PARAMETER ResourceId
Enter the hostpool ResourceId
.PARAMETER MaxVMsRemovedDuringUpdate
Enter the number of sessionhosts that can be removed during the update.
.PARAMETER SaveOriginalDisk
Enter if you want to save the original disk.
.PARAMETER logOffMessage
Enter the message that will be shown to the user when the sessionhost is removed.
.PARAMETER LogoutDelayMinutes
Enter the number of minutes the user has to log off.
.PARAMETER VmSizeId
Enter the VM size you want to use for the sessionhosts.
.PARAMETER DiskType
Enter the disk type you want to use for the sessionhosts.
.PARAMETER GalleryImageResourceId
Enter the image resource ID location
.PARAMETER vmUsername
Enter the username for the VM
.PARAMETER keyVaultResourceId
Enter the keyvault resource ID
.PARAMETER keyVaultSecretName
Enter the keyvault secret name
.PARAMETER DomainUsername
Enter the domain username
.PARAMETER DomainKeyVaultResourceId
Enter the domain keyvault resource ID
.PARAMETER DomainKeyVaultSecretName
Enter the domain keyvault secret name
.PARAMETER DomainName
Enter the domain name 
.EXAMPLE
Update-AvdHostPoolUpdate -ResourceId /subscriptions/xxx/resourceGroups/rg-avd/providers/Microsoft.DesktopVirtualization/hostpools/AVD-Hostpool/ -MaxVMsRemovedDuringUpdate 2
.EXAMPLE
Update-AvdHostPoolUpdate -Hostpoolname AVD-Hostpool -ResourceGroupName rg-avd -MaxVMsRemovedDuringUpdate 2
.EXAMPLE
Update-AvdHostPoolUpdate -ResourceId /../ -MaxVMsRemovedDuringUpdate 2 -GalleryImageResourceId /xxxx/versions/1.0.0 -vmUsername admin -keyVaultResourceId /xxxx -keyVaultSecretName secret -DomainUsername admin -DomainKeyVaultResourceId /xxxx -DomainKeyVaultSecretName secret -DomainName contoso.com
#>
    [CmdletBinding(DefaultParameterSetName = "Name-AAD")]
    param (
        [Parameter(Mandatory, ParameterSetName = "Name-AAD")]
        [Parameter(Mandatory, ParameterSetName = "Name-Hybrid")]
        [ValidateNotNullOrEmpty()]
        [string]$HostPoolName,

        [Parameter(Mandatory, ParameterSetName = "Name-AAD")]
        [Parameter(Mandatory, ParameterSetName = "Name-Hybrid")]
        [ValidateNotNullOrEmpty()]
        [string]$ResourceGroupName,

        [Parameter(Mandatory, ParameterSetName = "ResourceID-AAD")]
        [Parameter(Mandatory, ParameterSetName = "ResourceID-Hybrid")]
        [ValidateNotNullOrEmpty()]
        [string]$ResourceId,

        [Parameter()]
        [int]$MaxVMsRemovedDuringUpdate = 1,

        [Parameter()]
        [bool]$SaveOriginalDisk = $true,

        [Parameter()]
        [string]$logOffMessage = "Please save your work and sign out for this session host will be shut down for image update. Please log back in when you are ready",

        [Parameter()]
        [int]$LogoutDelayMinutes = 5,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$VmSizeId,

        [Parameter()]
        [string]$DiskType,

        [Parameter()]
        [string]$ImageResourceId,

        [Parameter(ParameterSetName = "ResourceID-AAD")]
        [Parameter(ParameterSetName = "Name-AAD")]
        [string]$VmUsername,

        [Parameter()]
        [string]$KeyVaultResourceId,

        [Parameter()]
        [string]$KeyVaultSecretName,

        [Parameter(Mandatory, ParameterSetName = "Name-Hybrid")]
        [Parameter(Mandatory, ParameterSetName = "ResourceID-Hybrid")]
        [ValidateNotNullOrEmpty()]
        [string]$DomainUsername,

        [Parameter(ParameterSetName = "Name-Hybrid")]
        [Parameter(ParameterSetName = "ResourceID-Hybrid")]
        [ValidateNotNullOrEmpty()]
        [string]$DomainName,

        [Parameter(Mandatory, ParameterSetName = "ResourceID-AAD")]
        [Parameter(Mandatory, ParameterSetName = "Name-AAD")]
        [switch]$AadJoin
    )
    Begin {
        Write-Verbose "Start searching for update conifguration in $hostpoolName"
        AuthenticationCheck
        $token = GetAuthToken -resource $script:AzureApiUrl
        switch ($PsCmdlet.ParameterSetName) {
            Name-AAD {
                Write-Verbose "Name and ResourceGroup provided"
                $ResourceId = "/subscriptions/{0}/resourceGroups/{1}/providers/Microsoft.DesktopVirtualization/hostpools/{2}" -f $script:subscriptionId, $ResourceGroupName, $HostpoolName
                $shConfigUpdateUrl = "{0}{1}/sessionHostConfigurations/default?api-version={2}" -f $script:AzureApiUrl, $ResourceId, $script:hostpoolUpdateApiVersion
                $hpConfigUpdateUrl = "{0}{1}/update?api-version={2}" -f $script:AzureApiUrl, $ResourceId, $script:hostpoolUpdateApiVersion
                id = "{0}/sessionHostConfigurations/default" -f $ResourceId 
            }
            ResourceId-AAD {
                Write-Verbose "ResourceId provided, thank you for that :)"
                $shConfigUpdateUrl = "{0}{1}/sessionHostConfigurations/default?api-version={2}" -f $script:AzureApiUrl, $ResourceId, $script:hostpoolUpdateApiVersion
                $hpConfigUpdateUrl = "{0}{1}/update?api-version={2}" -f $script:AzureApiUrl, $ResourceId, $script:hostpoolUpdateApiVersion
                $id = $ResourceId
                Write-Verbose "Url: $shConfigUpdateUrl"
                Write-Verbose "Id: $id"
            }
        }
    }
    Process {
        try {
            Write-Verbose "Getting configuration"
            $currentConfig = Get-AvdHostPoolUpdateConfiguration -ResourceId $ResourceId
            $currentConfig.sessionHostConfiguration
            Write-Verbose "Writing sessionhost configuration"
            $sessionHostConfig = @{
                id         = $id
                name       = "{0}/default" -f $ResourceId
                type       = "Microsoft.DesktopVirtualization/hostpools/sessionHostConfigurations"
                properties = @{
                    vmSizeId           = if(($PSBoundParameters.ContainsKey("vmSizeId"))){$vmSizeId}else{$currentConfig.sessionHostConfiguration.vmSizeId}
                    diskInfo           = @{
                        type = if(($PSBoundParameters.ContainsKey("DiskType"))){$DiskType}else{$currentConfig.sessionHostConfiguration.diskInfo.type}
                    }
                    imageInfo          = @{
                        type       = "Custom"
                        customInfo = @{
                            resourceId = if(($PSBoundParameters.ContainsKey("ImageResourceId"))){$ImageResourceId}else{$currentConfig.sessionHostConfiguration.customInfo.resourceId}
                        }
                    }
                    vmAdminCredentials = @{
                        username                   = if(($PSBoundParameters.ContainsKey("DomainUsername"))){$VmUseDomainUsernamername}else{$currentConfig.sessionHostConfiguration.vmAdminCredentials.username}
                        passwordKeyVaultResourceId = if(($PSBoundParameters.ContainsKey("KeyVaultResourceId"))){$KeyVaultResourceId}else{$currentConfig.sessionHostConfiguration.vmAdminCredentials.passwordKeyVaultResourceId}
                        passwordKeyVaultSecretName = if(($PSBoundParameters.ContainsKey("KeyVaultSecretName"))){$KeyVaultSecretName}else{$currentConfig.sessionHostConfiguration.vmAdminCredentials.passwordKeyVaultSecretName}
                    }
                }
            }
            switch -wildcard ($PsCmdlet.ParameterSetName) {
                *AAD {
                    Write-Verbose "AAD configuration"
                    $domainInfo = @{
                        joinType                 = "AzureActiveDirectory"
                        azureActiveDirectoryInfo = @{
                            mdmProviderGuid = "0000000a-0000-0000-c000-000000000000"
                        }
                    }
                    $sessionHostConfig.properties.Add("domainInfo", $domainInfo)
                }
                *Hybrid {
                    Write-Verbose "Domain info provided, now in hybrid configuration"
                    $domainInfo = @{
                        joinType            = "ActiveDirectory"
                        activeDirectoryInfo = @{
                            credentials = @{
                                username                   = if(($PSBoundParameters.ContainsKey("DomainUsername"))){$DomainUsername}else{$currentConfig.sessionHostConfiguration.domainInfo.activeDirectoryInfo.credentials.username}
                                passwordKeyVaultResourceId = if(($PSBoundParameters.ContainsKey("DomainKeyVaultResourceId"))){$KeyVaultResourceId}else{$currentConfig.sessionHostConfiguration.domainInfo.activeDirectoryInfo.credentials.passwordKeyVaultResourceId}
                                passwordKeyVaultSecretName = if(($PSBoundParameters.ContainsKey("KeyVaultSecretName"))){$KeyVaultSecretName}else{$currentConfig.sessionHostConfiguration.domainInfo.activeDirectoryInfo.credentials.passwordKeyVaultSecretName}
                            }
                        }
                        domainName          = if(($PSBoundParameters.ContainsKey("DomainName"))){$DomainName}else{$currentConfig.sessionHostConfiguration.domainInfo.domainName}
                    }
                    $sessionHostConfig.Add("domainInfo", $domainInfo)
                }
            }
            $sessionHostConfig = $sessionHostConfig | ConvertTo-Json -Depth 10
            $shConfig = Invoke-WebRequest -uri $shConfigUpdateUrl -Headers $token -Method PUT -Body $sessionHostConfig -ContentType 'application/json' -SkipHttpErrorCheck
    
            Write-Verbose "Writing hostpool configuration"
            $body = @{
                parameters   = @{
                    saveOriginalDisk          = $SaveOriginalDisk
                    maxVMsRemovedDuringUpdate = $MaxVMsRemovedDuringUpdate
                    maintenanceAlerts         = @()
                    logOffDelayMinutes        = $LogoutDelayMinutes
                    logOffMessage             = $LogOffMessage
                }
                validateOnly = $false
            } | ConvertTo-Json
            $parameters = @{
                uri     = $hpConfigUpdateUrl
                Method  = "POST"
                Headers = $token
                Body    = $body
            }
            $hpConfig = Invoke-WebRequest @parameters -SkipHttpErrorCheck
        }
        catch {
            Write-Error $_
        }
        finally {
            Write-Verbose "Done"
            Write-Information "Sessionhost configuration status: $($shConfig)" -InformationAction Continue
            (Get-AvdHostPoolUpdateConfiguration -ResourceId $ResourceId).sessionHostConfiguration
            Write-Information "Hostpool configuration status: $($hpConfig)" -InformationAction Continue
            (Get-AvdHostPoolUpdateConfiguration -ResourceId $ResourceId).hostPoolUpdateConfiguration
        }
    }
}
