function Get-AvdSessionHost {
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
    Get-AvdSessionHost -HostpoolName avd-hostpool-personal -ResourceGroupName rg-avd-01 -SessionHostName avd-host-1.avd.domain -AllowNewSession $true 
    .EXAMPLE
    Get-AvdSessionHost -HostpoolName avd-hostpool-personal -ResourceGroupName rg-avd-01
    
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

        [parameter(Mandatory, ParameterSetName = 'AllID')]
        [ValidateNotNullOrEmpty()]
        [string]$HostPoolResourceId,
    
        [parameter(Mandatory, ParameterSetName = 'Hostname')]
        [ValidateNotNullOrEmpty()]
        [string]$SessionHostName,

        [parameter(Mandatory, ParameterSetName = 'HostId')]
        [ValidateNotNullOrEmpty()]
        [string]$Id
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
                $baseUrl = $baseUrl + $SessionHostName 
            }
            AllID {
                Write-Verbose 'Using base url for getting all session hosts in $hostpoolName'
                $baseUrl = $Script:AzureApiUrl + $HostPoolResourceId + "/sessionHosts/"
            }
            HostId {
                Write-Verbose "Looking for sessionhost $Id"
                $baseUrl = "{0}/{1}" -f $Script:AzureApiUrl, $Id
            }
        }
        write-verbose $baseUrl
        $parameters = @{
            uri     = $baseUrl + $apiVersion
            Method  = "GET"
            Headers = $token
        }
        $results = Invoke-RestMethod @parameters
        if ($SessionHostName -or $Id){
            $results
        }
        else {
            $results.value
        }
        
    }
}