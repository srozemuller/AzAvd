function Get-AvdHostPoolUpdate {
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
.PARAMETER MaxVMsRemovedDuringUpdate
Enter the number of sessionhosts that can be removed during the update.
.PARAMETER SaveOriginalDisk
Enter if you want to save the original disk.
.PARAMETER logOffMessage
Enter the message that will be shown to the user when the sessionhost is removed.
.PARAMETER LogoutDelayMinutes
Enter the number of minutes the user has to log off.
.EXAMPLE
Start-AvdHostPoolUpdate -Resourceid /subscriptions/xxx/resourceGroups/rg-avd/providers/Microsoft.DesktopVirtualization/hostpools/AVD-Hostpool/ -MaxVMsRemovedDuringUpdate 2
.EXAMPLE
Start-AvdHostPoolUpdate -Hostpoolname AVD-Hostpool -ResourceGroupName rg-avd -MaxVMsRemovedDuringUpdate 2
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
        $token = GetAuthToken -resource $script:AzureApiUrl
        switch ($PsCmdlet.ParameterSetName) {
            Name {
                Write-Verbose "Name and ResourceGroup provided"
                $url = "{0}/subscriptions/{1}/resourceGroups/{2}/providers/Microsoft.DesktopVirtualization/hostpools/{3}/updateDetails?api-version={4}" -f $script:AzureApiUrl, $script:subscriptionId, $ResourceGroupName, $HostpoolName, $script:hostpoolUpdateApiVersion
            }
            ResourceId {
                Write-Verbose "ResourceId provided"
                $url = "{0}{1}/updateDetails?api-version={2}" -f $script:AzureApiUrl, $resourceId, $script:hostpoolUpdateApiVersion
            }
        }
    }
    Process {
        try {
            $parameters = @{
                uri     = $url
                Method  = "GET"
                Headers = $token
            }
            $response = Invoke-WebRequest @parameters -SkipHttpErrorCheck
            ($response.Content | ConvertFrom-Json).value.properties
        }
        catch {
            Write-Error $_.Exception.Response
        }
    }
}
