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
    .PARAMETER Friendlyname
    Enter a friendly name for the current sessionhost. 
    .PARAMETER SessionHostName
    Enter the sessionhosts name avd-hostpool/avd-host-1.avd.domain
    .EXAMPLE
    Update-AvdSessionHost -HostpoolName avd-hostpool -ResourceGroupName rg-avd-01 -SessionHostName avd-hostpool/avd-host-1.avd.domain -AllowNewSession $true
    .EXAMPLE
    Update-AvdSessionHost -HostpoolName avd-hostpool -ResourceGroupName rg-avd-01 -SessionHostName avd-hostpool/avd-host-1.avd.domain -AssignedUser "" -Force
    #>
    [CmdletBinding(DefaultParameterSetName = 'Id')]
    param
    (
        [parameter(Mandatory, ParameterSetName = 'All')]
        [parameter(Mandatory, ParameterSetName = 'Hostname')]
        [ValidateNotNullOrEmpty()]
        [string]$HostpoolName,
    
        [parameter(Mandatory, ParameterSetName = 'All')]
        [parameter(Mandatory, ParameterSetName = 'Hostname')]
        [ValidateNotNullOrEmpty()]
        [string]$ResourceGroupName,

        [parameter()]
        [ValidateNotNullOrEmpty()]
        [boolean]$AllowNewSession = $true,

        [parameter(ParameterSetName = 'Hostname')]
        [parameter(ParameterSetName = 'Id')]
        [ValidateNotNullOrEmpty()]
        [string]$AssignedUser,

        [parameter(ParameterSetName = 'Hostname')]
        [parameter(ParameterSetName = 'Id')]
        [ValidateNotNullOrEmpty()]
        [string]$FriendlyName,

        [parameter(Mandatory, ParameterSetName = 'Hostname')]
        [string]$SessionHostName,

        [parameter(Mandatory, ParameterSetName = 'Id')]
        [object]$Id,

        [parameter()]
        [switch]$Force
    )
    Begin {
        Write-Verbose "Start updating session hosts"
        AuthenticationCheck
        $token = GetAuthToken -resource $Script:AzureApiUrl
        $apiVersion = "2022-02-10-preview"
        if ($Force.IsPresent) {
            $forceString = "true"
        }
        else {
            $forceString = "false"
        }
        $baseParameters = @{
            hostpoolName      = $HostpoolName
            resourceGroupName = $ResourceGroupName
        }
    }
    Process {
        switch ($PsCmdlet.ParameterSetName) {
            All {
                $sessionHosts = Get-AvdSessionHost @baseParameters
            }
            Hostname {
                $sessionHosts = Get-AvdSessionHost @baseParameters -Name $SessionHostName
            }
            default {
                $sessionHosts = Get-AvdSessionHost -Id $Id
            }
        }
        $sessionHosts | ForEach-Object {
            try {
                Write-Verbose "Updating sessionhost $vmName"
                
                $url = "{0}{1}?api-version={2}&force={3}" -f $Script:AzureApiUrl, $_.id , $apiVersion, $forceString
                Write-Verbose $url
                $parameters = @{
                    uri     = $url
                    Headers = $token
                }
                $body = @{
                    properties = @{
                        AllowNewSession = $AllowNewSession
                        FriendlyName    = $FriendlyName
                        AssignedUser    = $AssignedUser
                    }
                }
                if ($AssignedUser){
                    $body.properties.add('AssignedUser',$AssignedUser)
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