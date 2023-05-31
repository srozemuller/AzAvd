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
    .PARAMETER UnassignAll
    Unassign all users from the sessionhost.
    .EXAMPLE
    Update-AvdSessionHost -HostpoolName avd-hostpool -ResourceGroupName rg-avd-01 -SessionHostName avd-hostpool/avd-host-1.avd.domain -AllowNewSession $true
    .EXAMPLE
    Update-AvdSessionHost -HostpoolName avd-hostpool -ResourceGroupName rg-avd-01 -SessionHostName avd-hostpool/avd-host-1.avd.domain -AssignedUser "user@domain.com" -Force
    .EXAMPLE
    Update-AvdSessionHost -HostpoolName avd-hostpool -ResourceGroupName rg-avd-01 -SessionHostName avd-hostpool/avd-host-1.avd.domain -UnAssignAll -Force
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
        [parameter(ParameterSetName = 'Id-All')]
        [ValidateNotNullOrEmpty()]
        [string]$FriendlyName,

        [parameter(Mandatory, ParameterSetName = 'Hostname')]
        [parameter(Mandatory, ParameterSetName = 'Hostname-All')]
        [string]$SessionHostName,

        [parameter(Mandatory, ParameterSetName = 'Id')]
        [parameter(Mandatory, ParameterSetName = 'Id-All')]
        [object]$Id,

        [parameter()]
        [switch]$Force,

        [parameter(ParameterSetName = 'All')]
        [parameter(ParameterSetName = 'Hostname')]
        [parameter(ParameterSetName = 'Id-All')]
        [parameter(ParameterSetName = 'Hostname-All')]
        [switch]$UnAssignAll
    )
    Begin {
        Write-Verbose "Start updating session hosts"
        AuthenticationCheck
        $token = GetAuthToken -resource $global:AzureApiUrl
        $apiVersion = "2022-02-10-preview"
        if ($Force.IsPresent) {
            $forceString = "true"
        }
        else {
            $forceString = "false"
        }
    }
    Process {
        switch -Wildcard ($PsCmdlet.ParameterSetName) {
            All {
                $sessionHosts = Get-AvdSessionHost -HostpoolName $HostpoolName -ResourceGroupName $ResourceGroupName
            }
            *Hostname {
                $sessionHosts = Get-AvdSessionHost -HostpoolName $HostpoolName -ResourceGroupName $ResourceGroupName -Name $SessionHostName
            }
            Id* {
                $sessionHosts = Get-AvdSessionHost -Id $Id
            }
        }
        $sessionHosts | ForEach-Object {
            try {
                Write-Verbose "Updating sessionhost $vmName"
                $url = "{0}{1}?api-version={2}&force={3}" -f $global:AzureApiUrl, $_.id , $apiVersion, $forceString
                Write-Verbose $url
                $parameters = @{
                    uri     = $url
                    Headers = $token
                }
                $body = @{
                    properties = @{
                        AllowNewSession = $AllowNewSession
                        FriendlyName    = $FriendlyName
                    }
                }
                if ($AssignedUser){
                    $body.properties.add('AssignedUser',$AssignedUser)
                }
                if ($UnAssignAll.IsPresent) {
                    Write-Verbose "Unassigning all users from sessionhost"
                    $body.properties.add('AssignedUser', "")
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