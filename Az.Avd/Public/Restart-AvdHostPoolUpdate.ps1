function Restart-AvdHostPoolUpdate {
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
Restart-AvdHostPoolUpdate -Resourceid /subscriptions/xxx/resourceGroups/rg-avd/providers/Microsoft.DesktopVirtualization/hostpools/AVD-Hostpool/
.EXAMPLE
Restart-AvdHostPoolUpdate -Hostpoolname AVD-Hostpool -ResourceGroupName rg-avd
#>
    [CmdletBinding(DefaultParameterSetName = "ResourceID")]
    param (
        [Parameter(Mandatory, ParameterSetName = "Name")]
        [ValidateNotNullOrEmpty()]
        [string]$HostPoolName,

        [Parameter(Mandatory, ParameterSetName = "Name")]
        [ValidateNotNullOrEmpty()]
        [string]$ResourceGroupName,

        [Parameter(Mandatory, ParameterSetName = "ResourceID")]
        [ValidateNotNullOrEmpty()]
        [string]$ResourceId
    )
    Begin {
        Write-Verbose "Start searching for hostpool $hostpoolName"
        AuthenticationCheck
        switch ($PsCmdlet.ParameterSetName) {
            Name {
                Write-Verbose "Name and ResourceGroup provided"
                $url = "{0}/subscriptions/{1}/resourceGroups/{2}/providers/Microsoft.DesktopVirtualization/hostpools/{3}/sessionHostManagements/default/controlSessionHostUpdate?api-version={4}" -f $script:AzureApiUrl, $script:subscriptionId, $ResourceGroupName, $HostpoolName, $script:hostpoolUpdateApiVersion
            }
            ResourceId {
                Write-Verbose "ResourceId provided"
                $url = "{0}{1}/sessionHostManagements/default/controlSessionHostUpdate?api-version={2}" -f $script:AzureApiUrl, $resourceId, $script:hostpoolUpdateApiVersion
            }
        }
    }
    Process {
        try {
            $body = @{
                action = "Retry"
            } | ConvertTo-Json
            $parameters = @{
                uri     = $url
                Method  = "POST"
                Headers = $global:authHeader
                Body    = $body
            }
            $response = Request-Api @parameters
            return $response
        }
        catch {
            Write-Error $_.Exception.Response
        }
    }
}
