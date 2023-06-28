function Move-AvdSessionHost {
    <#
    .SYNOPSIS
    Moving sessionhosts from an Azure Virtual Desktop hostpool to a new one.
    .DESCRIPTION
    The function will move sessionhosts to a new Azure Virtual Desktop hostpool.
    .PARAMETER FromHostpoolName
    Enter the source AVD Hostpool name
    .PARAMETER FromResourceGroupName
    Enter the source Hostpool resourcegroup name
    .PARAMETER ToHostpoolName
    Enter the destination AVD Hostpool name
    .PARAMETER ToResourceGroupName
    Enter the destination Hostpool resourcegroup name
    .PARAMETER SessionHostName
    Enter the sessionhosts name avd-hostpool/avd-host-1.avd.domain
    .PARAMETER Id
    Enter the sessionhosts resource id
    .PARAMETER Force
    Force the move of the sessionhost
    .EXAMPLE
    Move-AvdSessionHost -FromHostpoolName avd-hostpool -FromResourceGroupName rg-avd-01 -ToHostpoolName avd-hostpool-02 -ToResourceGroupName rg-avd-02 -SessionHostName avd-host-1.avd.domain
    .EXAMPLE
    Move-AvdSessionHost -Id /subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/rg-avd-01/providers/Microsoft.DesktopVirtualization/hostPools/avd-hostpool/sessionHosts/avd-host-1.avd.domain -ToHostpoolName avd-hostpool-02 -ToResourceGroupName rg-avd-02
    #>
    [CmdletBinding(DefaultParameterSetName = 'All')]
    param
    (
        [parameter(Mandatory, ParameterSetName = 'All')]
        [parameter(Mandatory, ParameterSetName = 'SingleObject')]
        [ValidateNotNullOrEmpty()]
        [string]$FromHostpoolName,
    
        [parameter(Mandatory, ParameterSetName = 'All')]
        [parameter(Mandatory, ParameterSetName = 'SingleObject')]
        [ValidateNotNullOrEmpty()]
        [string]$FromResourceGroupName,
        
        [parameter(Mandatory, ParameterSetName = 'All')]
        [parameter(Mandatory, ParameterSetName = 'ResourceID')]
        [parameter(Mandatory, ParameterSetName = 'SingleObject')]
        [ValidateNotNullOrEmpty()]
        [string]$ToHostpoolName,
    
        [parameter(Mandatory, ParameterSetName = 'All')]
        [parameter(Mandatory, ParameterSetName = 'ResourceID')]
        [parameter(Mandatory, ParameterSetName = 'SingleObject')]
        [ValidateNotNullOrEmpty()]
        [string]$ToResourceGroupName,

        [parameter(Mandatory, ParameterSetName = 'SingleObject')]
        [string]$SessionHostName,
        
        [parameter(Mandatory, ValueFromPipelineByPropertyName, ParameterSetName = 'ResourceID')]
        [String]$Id,

        [parameter()]
        [switch]$Force = $false
    )
    Begin {
        Write-Verbose "Start moving session hosts"
        AuthenticationCheck
        $token = GetAuthToken -resource $global:AzureApiUrl
    }
    Process {
        switch ($PsCmdlet.ParameterSetName) {
            All {
                try {
                    $sessionHosts = Get-AvdSessionHost -HostpoolName $FromHostpoolName -ResourceGroupName $FromResourceGroupName
                }
                catch {
                    Write-Error "Something went wrong, $_"
                }
            }
            SingleObject {
                if ($SessionHostName.Contains($FromHostpoolName)) { 
                    Write-Verbose "SessionHostName contains hostpool name, removing it"
                    $SessionHostName = $SessionHostName.Replace($FromHostpoolName + "/", "")
                }
                $sessionHosts = Get-AvdSessionHost -HostpoolName $FromHostpoolName -ResourceGroupName $FromResourceGroupName -Name $SessionHostName
            }
            ResourceID {
                try {
                    $sessionHosts = Get-AvdSessionHost -Id $Id
                }
                catch {
                    Write-Error "Please provide the Get-AvdSessionHost output"
                }
            }
        }         
        if ($sessionHosts) {
            Write-Verbose "Found $($sessionHosts.count) sessionhosts"
            $sessionHosts | ForEach-Object {
                try {
                    if ($Force.IsPresent) {
                        Write-Verbose "Force parameter is present, skipping confirmation, moving all sessionhosts even if they are in use"
                        Write-Verbose "Removing sessionhost $($_.name) from $FromHostPoolName"
                    }
                    else {
                        $confirm = Read-Host "Are you sure you want to move sessionhost $($_.name) from $FromHostpoolName to $ToHostpoolName? (y/n)"
                        if ($confirm -ne "y") {
                            Write-Verbose "Skipping sessionhost $($_.name)"
                            continue
                        }
                    }
                    $sessionhostDeleteUrl = "{0}{1}?api-version={2}&force={3}" -f $global:AzureApiUrl , $_.id, $global:sessionHostApiVersion, $Force
                    $deleteParameters = @{
                        uri     = $sessionhostDeleteUrl
                        Headers = $token
                        Method  = "DELETE"
                    }
                    Invoke-RestMethod @deleteParameters
                    $vmResourceId = $_.properties.resourceId
                    Write-Verbose "Requesting new token in hostpool $ToHostpoolName"
                    $avdHostpoolToken = Update-AvdRegistrationToken -HostpoolName $ToHostpoolName -ResourceGroupName $ToResourceGroupName
                    # Script part
                    $global = [System.Collections.ArrayList]@()
                    $global.Add('Set-ItemProperty -Path Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\RDInfraAgent -Name RegistrationToken -Value ' + $($avdHostpoolToken.properties.registrationInfo.token) + '') | Out-Null
                    $global.Add('Set-ItemProperty -Path Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\RDInfraAgent -Name IsRegistered -Value 0') | Out-Null
                    $global.Add('Restart-Service -Name RDAgentBootLoader') | Out-Null
                    $moveBody = @{
                        commandId = "RunPowerShellScript"
                        script    = $global
                    }   
                    $runCommandUrl = "{0}{1}/runCommand?api-version={2}" -f $global:AzureApiUrl, $vmResourceId, $global:vmApiVersion
                    Write-Verbose "Moving sessionhost $name to $ToHostPoolName"
                    $parameters = @{
                        URI     = $runCommandUrl 
                        Method  = "POST"
                        Body    = $moveBody | ConvertTo-Json
                        Headers = $token
                    }
                    Invoke-RestMethod @parameters
                }
                catch {
                    Throw $_.Exception.Message
                }
            }
            else {
                Write-Error "No sessionhosts found in hostpool $FromHostpoolName"
            }
        }
    }
}