function Update-AvdHostPoolUpdateConfiguration {
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
Update-AvdHostPoolUpdateConfiguration -HostPoolName avd-hostpool-001 -ResourceGroupName rg-avd-001 -JsonBody "{"json":"string"}"
.EXAMPLE
Update-AvdHostPoolUpdateConfiguration -ResourceId "/subscription/../HostPoolName"
#>
    [CmdletBinding(DefaultParameterSetName = "Name")]
    param (
        [Parameter(Mandatory, ParameterSetName = "Name")]
        [ValidateNotNullOrEmpty()]
        [string]$HostPoolName,

        [Parameter(Mandatory, ParameterSetName = "Name")]
        [ValidateNotNullOrEmpty()]
        [string]$ResourceGroupName,

        [Parameter(Mandatory, ParameterSetName = "ResourceId")]
        [ValidateNotNullOrEmpty()]
        [string]$ResourceId,

        [Parameter(Mandatory, ParameterSetName = "Name")]
        [Parameter(Mandatory, ParameterSetName = "ResourceId")]
        [ValidateNotNullOrEmpty()]
        [string]$JsonBody
    )
    Begin {
        Write-Verbose "Start searching for hostpool update configuration in $hostpoolName"
        AuthenticationCheck
        switch ($PsCmdlet.ParameterSetName) {
            Name {
                Write-Verbose "Name and ResourceGroup provided"
                $url = "{0}/subscriptions/{1}/resourceGroups/{2}/providers/Microsoft.DesktopVirtualization/hostpools/{3}/sessionHostConfigurations/default?api-version={4}" -f $script:AzureApiUrl, $script:subscriptionId, $ResourceGroupName, $HostpoolName, $script:hostpoolUpdateApiVersion
            }
            ResourceId {
                Write-Verbose "ResourceId provided"
                $url = "{0}{1}/sessionHostConfigurations/default?api-version={2}" -f $script:AzureApiUrl, $ResourceId, $script:hostpoolUpdateApiVersion
            }
        }
    }
    Process {
        try {
            $parameters = @{
                Uri     = $url
                Body = $JsonBody
                Method  = "PATCH"
                Headers = $script:authHeader
            }
            $response = Request-Api @parameters
            $response
        }
        catch {
            Write-Error $_.Exception.Response
        }
    }
}
