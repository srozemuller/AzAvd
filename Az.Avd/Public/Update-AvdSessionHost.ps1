function Update-AvdSessionHost {
    <#
    .SYNOPSIS
    Updating one or more sessionhosts. Assign new users or put them in drainmode or not.
    .DESCRIPTION
    The function will update the current sessionhosts assigned user and drainmode
    .PARAMETER HostpoolName
    Enter the source AVD Hostpool name
    .PARAMETER ResourceGroupName
    Enter the source Hostpool resourcegroup name
    .PARAMETER AllowNewSession
    Allowing new sessions or not. (Default: true). 
    .PARAMETER AssignedUser
    Enter the new username for the current sessionhost. Only available if providing one sessionhost at a time. 
    .PARAMETER SessionHostName
    Enter the sessionhosts name avd-hostpool/avd-host-1.avd.domain
    .EXAMPLE
    Update-AvdSessionHost -HostpoolName avd-hostpool -ResourceGroupName rg-avd-01 -SessionHostName avd-hostpool/avd-host-1.avd.domain -AllowNewSession $true
    .EXAMPLE
    Update-AvdSessionHost -HostpoolName avd-hostpool -ResourceGroupName rg-avd-01 -SessionHostName avd-hostpool/avd-host-1.avd.domain -AssignedUser "" -Force
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
        [string]$AllowNewSession = $true,

        [parameter(ParameterSetName = 'SingleObject')]
        [parameter(Mandatory, ParameterSetName = 'UserMutation')]
        [AllowEmptyString()]
        [string]$AssignedUser,

        [parameter(ParameterSetName = 'SingleObject')]
        [parameter(Mandatory)]
        [string]$SessionHostName,

        [parameter(Mandatory,ParameterSetName = 'InputObject')]
        [object]$SessionHosts,

        [parameter(Mandatory, ParameterSetName = 'UserMutation')]
        [switch]$Force
        
    )
    Begin {
        Write-Verbose "Start moving session hosts"
        AuthenticationCheck
        $token = GetAuthToken -resource $Script:AzureApiUrl
        if ($Force.IsPresent){
            $forceString = "true"
        }
        else {
            $forceString = "false"
        }
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
                Write-Verbose "Updating sessionhost $vmName"
                $url = "{0}/subscriptions/{1}/resourceGroups/{2}/providers/Microsoft.DesktopVirtualization/hostpools/{3}/sessionHosts/{4}?api-version={5}&force={6}" -f $Script:AzureApiUrl, $script:subscriptionId, $ResourceGroupName, $HostpoolName, $vmName, $script:sessionhostApiVersion, $forceString
                $parameters = @{
                    uri     = $url
                    Headers = $token
                }
                $body = @{
                    properties = @{
                        AllowNewSession = $AllowNewSession
                        AssignedUser    = $AssignedUser
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