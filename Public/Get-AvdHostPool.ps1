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
.EXAMPLE
Get-AvdHostPoolInfo -HostPoolName avd-hostpool-001 -ResourceGroupName rg-avd-001
#>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$HostPoolName,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$ResourceGroupName
    )
    Begin {
        Write-Verbose "Start searching for hostpool $hostpoolName"
        AuthenticationCheck
        $token = GetAuthToken -resource $script:AzureApiUrl
        $apiVersion = "?api-version=2019-12-10-preview"
        $url = $script:AzureApiUrl + "/subscriptions/" + $script:subscriptionId + "/resourceGroups/" + $ResourceGroupName + "/providers/Microsoft.DesktopVirtualization/hostpools/" + $HostpoolName + $apiVersion
        $parameters = @{
            uri     = $url
            Headers = $token
        }
    }
    Process {
        $parameters = @{
            uri     = $url
            Method  = "GET"
            Headers = $token
        }
        $results = Invoke-RestMethod @parameters
        return $results
    }
    End {}
}
