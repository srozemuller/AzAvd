function Disconnect-AvdUserSessions {
    <#
    .SYNOPSIS
    Gets the current connect users on an AVD from a specific hostpool.
    .DESCRIPTION
    This function will grab all the logged in users sessions from a specific Azure Virtual Desktop hostpool.
    .PARAMETER HostpoolName
    Enter the AVD Hostpool name
    .PARAMETER ResourceGroupName
    Enter the AVD Hostpool resourcegroup name
    .PARAMETER SessionHostName
    Enter the sessionhosts name
    .PARAMETER SessionHostName
    Enter the user principal name
    .PARAMETER All
    Switch parameter to logoff all sessions on a session host
    .EXAMPLE
    Disconnect-AvdUserSessions -HostpoolName avd-hostpool-personal -ResourceGroupName rg-avd-01 -SessionHostName avd-host-1.avd.domain -LogonName user@domain.com
    .EXAMPLE
    Disconnect-AvdUserSessions -HostpoolName avd-hostpool-personal -ResourceGroupName rg-avd-01 -All
    .EXAMPLE
    Disconnect-AvdUserSessions -HostpoolName avd-hostpool-personal -ResourceGroupName rg-avd-01 -SessionHostName avd-host-1.avd.domain -All
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
        $token = GetAuthToken -resource $global:AzureApiUrl
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
                $avdParameters.Add("sessionHostName", $SessionHostName)
            }
        }
        try {
            $userSessions = Get-AvdUserSessions @avdParameters
        }
        catch {
            Throw "No user sessions found under $Hostpoolname in $ResourceGroupName"
        }
        try {
            if ($all) {
                $userSessions | ForEach-Object {
                    $parameters = @{
                        uri     = "{0}{1}{2}" -f $global:AzureApiUrl, $_.id, $apiVersion
                        Method  = "DELETE"
                        Headers = $token
                    }
                    Invoke-RestMethod @parameters
                }
            }
            else {
                $userId = $userSessions | Where-Object { $_.properties.userPrincipalName -eq $LogonName }

                $parameters = @{
                    uri     = "{0}{1}{2}" -f $global:AzureApiUrl, $($userId.id), $apiVersion
                    Method  = "DELETE"
                    Headers = $token
                }
                Invoke-RestMethod @parameters
            }
        }
        catch {
            Throw "Logging of users not succesfully, $_"
        }
    }
}