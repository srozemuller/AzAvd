function Logoff-AvdUserSessions {
    <#
    .SYNOPSIS
    Gets the current AVD Session hosts from a specific hostpool.
    .DESCRIPTION
    This function will grab all the sessionhost from a specific Azure Virtual Desktop hostpool.
    .PARAMETER HostpoolName
    Enter the AVD Hostpool name
    .PARAMETER ResourceGroupName
    Enter the AVD Hostpool resourcegroup name
    .PARAMETER SessionHostName
    Enter the sessionhosts name
    .PARAMETER All
    Switch parameter to logoff all sessions on a session host
    .EXAMPLE
    Logoff-AvdUserSessions -HostpoolName avd-hostpool-personal -ResourceGroupName rg-avd-01 -SessionHostName avd-host-1.avd.domain -AllowNewSession $true 
    #>
    [CmdletBinding(DefaultParameterSetName = 'All')]
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
    
        [parameter(Mandatory, ParameterSetName = 'Hostname')]
        [ValidateNotNullOrEmpty()]
        [string]$SessionHostName,

        [parameter(ParameterSetName = 'All')]
        [parameter(ParameterSetName = 'Hostname')]
        [ValidateNotNullOrEmpty()]
        [string]$LogonName,

        [parameter(ParameterSetName = 'All')]
        [parameter(ParameterSetName = 'Hostname')]
        [ValidateNotNullOrEmpty()]
        [switch]$All
    )
    Begin {
        Write-Verbose "Start searching session hosts"
        AuthenticationCheck
        $token = GetAuthToken -resource $Script:AzureApiUrl
        #$baseUrl = $Script:AzureApiUrl + "/subscriptions/" + $script:subscriptionId + "/resourceGroups/" + $ResourceGroupName + "/providers/Microsoft.DesktopVirtualization/hostpools/" + $HostpoolName + "/sessionHosts/"
        $apiVersion = "?api-version=2021-07-12"
        $avdParameters = @{
            HostpoolName      = $HostpoolName
            ResourceGroupName = $ResourceGroupName
        }
    }
    Process {
        switch ($PsCmdlet.ParameterSetName) {
            All {
                Write-Verbose 'Using base url for getting all session hosts in $hostpoolName'
            }
            Hostname {
                Write-Verbose "Looking for sessionhost $SessionHostName"
                $avdParameters.Add("sessionHostName",$SessionHostName)
            }
        }
        $userSessions = Get-AvdUserSessions @avdParameters
        if ($all) {
            $userSessions | ForEach-Object {
                $parameters = @{
                    uri     = "{0}{1}{2}" -f $Script:AzureApiUrl, $_.id, $apiVersion
                    Method  = "DELETE"
                    Headers = $token
                }
                Invoke-RestMethod @parameters
            }
        }
        else {
            $userSessions | Where-Object {$_.properties.userPrincipalName -eq $LogonName }
            $parameters = @{
                uri     = "{0}{1}{2}" -f $Script:AzureApiUrl, $_.id, $apiVersion
                Method  = "DELETE"
                Headers = $token
            }
            Invoke-RestMethod @parameters
        }
    }
}