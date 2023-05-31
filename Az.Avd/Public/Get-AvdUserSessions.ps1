function Get-AvdUserSessions {
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
    .PARAMETER LoginName
    Enter the user principal name
    .EXAMPLE
    Get-AvdUserSessions -HostpoolName avd-hostpool-personal -ResourceGroupName rg-avd-01 -SessionHostName avd-host-1.avd.domain 
    .EXAMPLE
    Get-AvdUserSessions -HostpoolName avd-hostpool-personal -ResourceGroupName rg-avd-01 -SessionHostName avd-host-1.avd.domain -LoginName user@domain.com
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
        [string]$LoginName,

        [parameter(ParameterSetName = 'Id')]
        [string]$SessionHostId
    )
    Begin {
        Write-Verbose "Start searching session hosts"
        AuthenticationCheck
        $token = GetAuthToken -resource $global:AzureApiUrl
        $baseUrl = $global:AzureApiUrl + "/subscriptions/" + $global:subscriptionId + "/resourceGroups/" + $ResourceGroupName + "/providers/Microsoft.DesktopVirtualization/hostpools/" + $HostpoolName + "/sessionHosts/"
        $apiVersion = "?api-version=2021-07-12"
    }
    Process {
        switch ($PsCmdlet.ParameterSetName) {
            All {
                Write-Verbose "Searching for all sessions in $hostpoolName"
                $SessionHostNames = Get-AvdSessionHost -HostpoolName $hostpoolName -ResourceGroupName $ResourceGroupName
                $sessionHostUrl = [System.Collections.ArrayList]@()
                $SessionHostNames | ForEach-Object {
                    $url = "{0}{1}/UserSessions" -f $global:AzureApiUrl, $_.id
                    $sessionHostUrl.Add($url) | Out-Null
                }
            }
            Hostname {
                Write-Verbose "Looking for sessionhost $SessionHostName"
                $sessionHostUrl = "{0}{1}/UserSessions" -f $baseUrl, $SessionHostName 
            }
            Id {
                Write-Verbose "Looking for sessionhost on ID $SessionHostId"
                $sessionHostUrl = "{0}{1}/UserSessions" -f $global:AzureApiUrl, $SessionHostId
            }

        }
        try {
            $sessionHostUrl | ForEach-Object {
                Write-Verbose "Looking for sessions at $($_.Split("/")[-2])"
                $parameters = @{
                    uri     = "{0}{1}" -f $_, $apiVersion
                    Method  = "GET"
                    Headers = $token
                }
        
                $sessions = [System.Collections.ArrayList]@()
                $sessions.Add((Invoke-RestMethod @parameters).value) | Out-Null
            }
            if ($LoginName) {
                Write-Verbose "Searching for user with UPN $LoginName"
                $sessions = $sessions | Where-Object { $_.Properties.userPrincipalName -eq $LoginName }
                if ($null -eq $sessions) {
                    Write-Error "User $LoginName not found on $sessionHostName"
                }
                else {
                    $sessions
                }
            }
            else {
                $sessions
            }
        }
        catch {
            "No sessions found. $_"
        }
    }
}