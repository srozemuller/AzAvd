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
    .EXAMPLE
    Move-AvdSessionHost -FromHostpoolName avd-hostpool -FromResourceGroupName rg-avd-01 -ToHostpoolName avd-hostpool-02 -ToResourceGroupName rg-avd-02 -SessionHostName avd-host-1.avd.domain
    #>
    [CmdletBinding(DefaultParameterSetName = 'SingleObject')]
    param
    (
        [parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$FromHostpoolName,
    
        [parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$FromResourceGroupName,
        
        [parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$ToHostpoolName,
    
        [parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$ToResourceGroupName,

        [parameter(ParameterSetName = 'SingleObject')]
        [parameter(Mandatory)]
        [string]$SessionHostName

        <# 
        TODO
        [parameter(ParameterSetName = 'InputObject')]
        [parameter(Mandatory)]
        [object]$SessionHosts
        #>
        
    )
    Begin {
        Write-Verbose "Start moving session hosts"
        AuthenticationCheck
        $Token = GetAuthToken -resource $Script:AzureApiUrl
        $apiVersion = "?api-version=2021-04-01"
    }
    Process {
        switch ($PsCmdlet.ParameterSetName) {
            InputObject {
                try {
                    $SessionHostName = $SessionHosts.value.name
                }
                catch {
                    Write-Error "Please provide the Get-AvdSessionHost output"
                }
            }
            SingleObject {
                
            }
        }
        $SessionHostName | ForEach-Object {
            try {
                $vmName = $_.Split("/")[-1]
                Write-Verbose "Removing sessionhost $vmName from $FromHostPoolName"
                $url = $Script:AzureApiUrl + "/subscriptions/" + $script:subscriptionId + "/resourceGroups/" + $ResourceGroupName + "/providers/Microsoft.DesktopVirtualization/hostpools/" + $HostpoolName + "/sessionHosts/" + $vmName + $apiVersion
                $parameters = @{
                    uri     = $url
                    Headers = $Token
                }
                $sessionHost = Get-AvdSessionHost -HostpoolName $FromHostpoolName -ResourceGroupName $FromResourceGroupName -SessionHostName $vmName
                Remove-AvdSessionhost -HostpoolName $FromHostpoolName -ResourceGroupName $FromResourceGroupName -SessionHostName $vmName
                $resourceId = $($sessionHost.properties.resourceId)
                Write-Verbose "Requesting new token in hostpool $ToHostpoolName"
                $avdHostpoolToken = Update-AvdRegistrationToken -HostpoolName $ToHostpoolName -ResourceGroupName $ToResourceGroupName
                
                # Script part
                $script = [System.Collections.ArrayList]@()
                $script.Add('Set-ItemProperty -Path Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\RDInfraAgent -Name RegistrationToken -Value ' + $($avdHostpoolToken.properties.registrationInfo.token) + '')
                $script.Add('Set-ItemProperty -Path Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\RDInfraAgent -Name IsRegistered -Value 0')
                $script.Add('Restart-Service -Name RDAgentBootLoader')

                $MoveBody = @{
                    commandId = "RunPowerShellScript"
                    script    = $script
                }   
                $url = $Script:AzureApiUrl + $($resourceId) + "/runCommand" + $apiVersion
                Write-Verbose "Moving sessionhost $name to $ToHostPoolName"
                $parameters = @{
                    URI     = $url 
                    Method  = "POST"
                    Body    = $MoveBody | ConvertTo-Json
                    Headers = $Token
                }
                Invoke-RestMethod @parameters
            }
            catch {
                Throw $_
            }
        }
    }
}