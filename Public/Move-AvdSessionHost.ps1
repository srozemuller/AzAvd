function Move-AvdSessionhost {
    <#
    .SYNOPSIS
    Moving sessionhosts from an Azure Virtual Desktop hostpool to a new one.
    .DESCRIPTION
    The function will move sessionhosts to a new Azure Virtual Desktop hostpool.
    .PARAMETER fromHostpoolName
    Enter the source AVD Hostpool name
    .PARAMETER fromResourceGroupName
    Enter the source Hostpool resourcegroup name
    .PARAMETER toHostpoolName
    Enter the destination AVD Hostpool name
    .PARAMETER toResourceGroupName
    Enter the destination Hostpool resourcegroup name
    .PARAMETER SessionHostName
    Enter the sessionhosts name avd-hostpool/avd-host-1.avd.domain
    .EXAMPLE
    Move-AvdSessionhost -FromHostpoolName avd-hostpool -FromResourceGroupName rg-avd-01 -ToHostpoolName avd-hostpool-02 -ToResourceGroupName rg-avd-02 -SessionHostName avd-host-1.avd.domain
    #>
    [CmdletBinding(DefaultParameterSetName = 'SingleObject')]
    param
    (
        [parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$fromHostpoolName,
    
        [parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$fromResourceGroupName,
        
        [parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$toHostpoolName,
    
        [parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$toResourceGroupName,

        [parameter(ParameterSetName = 'SingleObject')]
        [parameter(Mandatory)]
        [string]$sessionHostName

        #[parameter(ParameterSetName = 'InputObject')]
        #[parameter(Mandatory)]
        #[object]$SessionHosts
        
    )
    Begin {
        Write-Verbose "Start moving session hosts"
        AuthenticationCheck
        $token = GetAuthToken -resource "https://management.azure.com"
        $apiVersion = "?api-version=2021-04-01"
    }
    Process {
        switch ($PsCmdlet.ParameterSetName) {
            InputObject {
                try {
                    $sessionHostName = $SessionHosts.value.name
                }
                catch {
                    Write-Error "Please provide the Get-AvdSessionHost output"
                }
            }
            SingleObject {
                
            }
        }
        $sessionHostName | foreach {
            try {
                $vmName = $_.Split("/")[-1]
                Write-Verbose "Removing sessionhost $vmName from $FromHostPoolName"
                $url = "https://management.azure.com/subscriptions/" + $script:subscriptionId + "/resourceGroups/" + $ResourceGroupName + "/providers/Microsoft.DesktopVirtualization/hostpools/" + $HostpoolName + "/sessionHosts/" + $vmName + $apiVersion
                $parameters = @{
                    uri     = $url
                    Headers = $token
                }
                $sessionHost = Get-AvdSessionHost -HostpoolName $fromHostpoolName -ResourceGroupName $fromResourceGroupName -SessionHostName $vmName
                Remove-AvdSessionhost -HostpoolName $fromHostpoolName -ResourceGroupName $fromResourceGroupName -SessionHostName $vmName
                $resourceId = $($sessionHost.properties.resourceId)
                Write-Verbose "Requesting new token in hostpool $toHostpoolName"
                $avdHostpoolToken = Update-AvdRegistrationToken -HostpoolName $toHostpoolName -ResourceGroupName $toResourceGroupName
                
                # Script part
                $script = [System.Collections.ArrayList]@()
                $script.Add('Set-ItemProperty -Path Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\RDInfraAgent -Name RegistrationToken -Value ' + $($avdHostpoolToken.properties.registrationInfo.token) + '')
                $script.Add('Set-ItemProperty -Path Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\RDInfraAgent -Name IsRegistered -Value 0')
                $script.Add('Restart-Service -Name RDAgentBootLoader')

                $MoveBody = @{
                    commandId = "RunPowerShellScript"
                    script    = $script
                }   
                $url = "https://management.azure.com" + $($resourceId) + "/runCommand" + $apiVersion
                Write-Verbose "Moving sessionhost $name to $ToHostPoolName"
                $parameters = @{
                    URI     = $url 
                    Method  = "POST"
                    Body    = $MoveBody | ConvertTo-Json
                    Headers = $token
                }
                Invoke-RestMethod @parameters
            }
            catch {
                Throw $_
            }
        }
    }
}