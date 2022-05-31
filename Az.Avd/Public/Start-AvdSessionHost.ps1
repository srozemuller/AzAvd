function Start-AvdSessionHost {
    <#
    .SYNOPSIS
    Starts AVD Session hosts in a specific hostpool.
    .DESCRIPTION
    This function starts sessionshosts in a specific Azure Virtual Desktop hostpool. If you want to start a specific session host then also provide the name, 
    .PARAMETER HostpoolName
    Enter the AVD Hostpool name
    .PARAMETER ResourceGroupName
    Enter the AVD Hostpool resourcegroup name
    .PARAMETER SessionHostName
    Enter the session hosts name
    .EXAMPLE
    Start-AvdSessionHost -HostpoolName avd-hostpool-personal -ResourceGroupName rg-avd-01
    .EXAMPLE
    Start-AvdSessionHost -HostpoolName avd-hostpool-personal -ResourceGroupName rg-avd-01 -SessionHostName avd-host-1.avd.domain
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
    
        [ValidatePattern('^(?:(?!\/).)*$', ErrorMessage = "It looks like you also provided a hostpool, a sessionhost name is enough. Provided value {0}")]
        [parameter(Mandatory, ParameterSetName = 'Hostname')]
        [ValidateNotNullOrEmpty()]
        [string]$SessionHostName
    )
    Begin {
        Write-Verbose "Start searching session hosts"
        AuthenticationCheck
        $token = GetAuthToken -resource $Script:AzureApiUrl
        $sessionHostParameters = @{
            hostpoolName      = $HostpoolName
            resourceGroupName = $ResourceGroupName
        }
    }
    Process {
        switch ($PsCmdlet.ParameterSetName) {
            All {
                Write-Verbose "No specific host provided, starting all hosts in $hostpoolName"
            }
            Hostname {
                Write-Verbose "Looking for sessionhost $SessionHostName"
                $sessionHostParameters.Add("SessionHostName", $SessionHostName)
            }
        }
        try {
            $sessionHosts = Get-AvdSessionHost @sessionHostParameters
        }
        catch {
            Throw "No sessionhosts found in $HostpoolName ($ResourceGroupName)"
        }
        $sessionHosts | ForEach-Object {
            try {
                Write-Verbose "Found $($sessionHosts.Count) host(s)"
                Write-Verbose "Starting $($_.name)"
                $apiVersion = "?api-version=2021-11-01"
                $startParameters = @{
                    uri     = "{0}{1}/start{2}" -f $Script:AzureApiUrl, $_.properties.resourceId, $apiVersion
                    Method  = "POST"
                    Headers = $token
                }
                Invoke-RestMethod @startParameters
                Write-Information -MessageData "$($_.name) started" -InformationAction Continue
            }
            catch {
                Throw "Not able to start $($_.name), $_"
            }
        }
    }       
}