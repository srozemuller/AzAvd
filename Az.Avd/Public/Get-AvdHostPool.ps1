function Get-AvdHostPool {
<#
.SYNOPSIS
Get AVD Hostpool information.
.DESCRIPTION
With this function you can get information about an AVD hostpool.
.PARAMETER HostPoolName
Enter the name of the hostpool you want information from.
.PARAMETER ResourceGroupName
Enter the name of the resourcegroup where the hostpool resides in.
.PARAMETER ResourceId
Enter the hostpool ResourceId
.EXAMPLE
Get-AvdHostPool
.EXAMPLE
Get-AvdHostPool -HostPoolName avd-hostpool-001 -ResourceGroupName rg-avd-001
.EXAMPLE
Get-AvdHostPool -ResourceId "/subscription/../HostPoolName"
#>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ParameterSetName = "Name")]
        [ValidateNotNullOrEmpty()]
        [string]$HostPoolName,

        [Parameter(Mandatory, ParameterSetName = "Name")]
        [ValidateNotNullOrEmpty()]
        [string]$ResourceGroupName,

        [Parameter(Mandatory, ParameterSetName = "ResourceId")]
        [ValidateNotNullOrEmpty()]
        [string]$ResourceId
    )
    Begin {
        Write-Verbose "Start searching for hostpool $hostpoolName"
        switch ($PsCmdlet.ParameterSetName) {
            Name {
                Write-Verbose "Name and ResourceGroup provided"
                $url = "{0}/subscriptions/{1}/resourceGroups/{2}/providers/Microsoft.DesktopVirtualization/hostpools/{3}?api-version={4}" -f $global:AzureApiUrl, $global:subscriptionId, $ResourceGroupName, $HostpoolName, $global:hostpoolApiVersion
            }
            ResourceId {
                Write-Verbose "ResourceId provided"
                $url = "{0}{1}?api-version={2}" -f $global:AzureApiUrl, $resourceId, $global:hostpoolApiVersion
            }
            default {
                Write-Verbose "Searching for all AVD host pools in subscription $global:subscriptionId"
                $url = "{0}/subscriptions/{1}/providers/Microsoft.DesktopVirtualization/hostpools?api-version={2}" -f $global:AzureApiUrl, $global:subscriptionId, $global:hostpoolApiVersion
            }
        }
    }
    Process {
        $parameters = @{
            uri     = $url
            Method  = "GET"
        }
        Write-Verbose $url
        $results = Request-Api @parameters
        $results
    }
}
