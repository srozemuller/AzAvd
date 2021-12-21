function Restart-AvdSessionHost {
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
    .EXAMPLE
    Restart-AvdSessionHost -HostpoolName avd-hostpool-personal -ResourceGroupName rg-avd-01 -SessionHostName avd-host-1.avd.domain
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
        [string]$SessionHostName
    )
    Begin {
        Write-Verbose "Start searching session hosts"
        AuthenticationCheck
        $token = GetAuthToken -resource $Script:AzureApiUrl
        $baseUrl = $Script:AzureApiUrl + "/subscriptions/" + $script:subscriptionId + "/resourceGroups/" + $ResourceGroupName + "/providers/Microsoft.DesktopVirtualization/hostpools/" + $HostpoolName + "/sessionHosts/"
        $apiVersion = "?api-version=2021-07-12"
    }
    Process {
        switch ($PsCmdlet.ParameterSetName) {
            All {
                Write-Verbose 'Using base url for getting all session hosts in $hostpoolName'
                
            }
            Hostname {
                Write-Verbose "Looking for sessionhost $SessionHostName"
                $sessionHostUrl = "{0}{1}" -f $baseUrl, $SessionHostName 
            }
        }
        $parameters = @{
            uri     = $sessionHostUrl + $apiVersion
            Method  = "GET"
            Headers = $token
        }
        try {
            $sessionHost = Invoke-RestMethod @parameters
            if ($sessionHost) {
                $apiVersion = "?api-version=2021-11-01"
                $restartParameters = @{
                    uri     = "{0}{1}/restart{2}" -f $Script:AzureApiUrl, $sessionHost.properties.resourceId, $apiVersion
                    Method  = "POST"
                    Headers = $token
                }
                Invoke-RestMethod @restartParameters
            }
            else {
                Write-Error "Sessionhost $sessionHostName not found, $_"
            }
        }
        catch {
            Throw "Not able to execute request, $_"
        }
        
    }
}