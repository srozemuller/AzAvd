function Update-AvdSessionhost {
    <#
    .SYNOPSIS
    Updating one or more sessionhosts. Assign new users or put them in drainmode or not.
    .DESCRIPTION
    The function will update the current sessionhosts assigned user and drainmode
    .PARAMETER HostpoolName
    Enter the source AVD Hostpool name
    .PARAMETER ResourceGroupName
    Enter the source Hostpool resourcegroup name
    .PARAMETER allowNewSession
    Allowing new sessions or not. (Default: true). 
    .PARAMETER assignedUser
    Enter the new username for the current sessionhost. Only available if providing one sessionhost at a time. 
    .PARAMETER SessionHostName
    Enter the sessionhosts name avd-hostpool/avd-host-1.avd.domain
    .EXAMPLE
    Update-AvdSessionhost -HostpoolName avd-hostpool -ResourceGroupName rg-avd-01 -SessionHostName avd-hostpool/avd-host-1.avd.domain -AllowNewSession $true
    .EXAMPLE
    $sessionHosts = Get-AvdSessionhost -HostpoolName avd-hostpool -ResourceGroupName rg-avd-01
    $sessionHosts | Update-AvdSessionhost -HostpoolName avd-hostpool -ResourceGroupName rg-avd-01 -AllowNewSession $true
    #>
    [CmdletBinding(DefaultParameterSetName = 'SingleObject')]
    param
    (
        [parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$HostpoolName,
    
        [parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$ResourceGroupName,

        [parameter(ParameterSetName = 'SingleObject')]
        [parameter(ParameterSetName = 'InputObject')]
        [ValidateNotNullOrEmpty()]
        [string]$allowNewSession = $true,

        [parameter(ParameterSetName = 'SingleObject')]
        [ValidateNotNullOrEmpty()]
        [string]$assignedUser,

        [parameter(ParameterSetName = 'SingleObject')]
        [parameter(Mandatory)]
        [string]$sessionHostName,

        [parameter(Mandatory,ParameterSetName = 'InputObject')]
        [object]$SessionHosts
        
    )
    Begin {
        Write-Verbose "Start moving session hosts"
        AuthenticationCheck
        $token = GetAuthToken -resource "https://management.azure.com"
        $apiVersion = "?api-version=2021-01-14-preview"
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
                Write-Verbose "Updating sessionhost $vmName"
                $url = "https://management.azure.com/subscriptions/" + $script:subscriptionId + "/resourceGroups/" + $ResourceGroupName + "/providers/Microsoft.DesktopVirtualization/hostpools/" + $HostpoolName + "/sessionHosts/" + $vmName + $apiVersion
                $parameters = @{
                    uri     = $url
                    Headers = $token
                }
                $body = @{
                    properties = @{
                        allowNewSession = $allowNewSession
                        assignedUser    = $assignedUser
                    }
                }
                $parameters = @{
                    URI     = $url 
                    Method  = "PATCH"
                    Body    = $body | ConvertTo-Json
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