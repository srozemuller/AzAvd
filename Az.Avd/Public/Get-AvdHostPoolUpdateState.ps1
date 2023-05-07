function Get-AvdHostPoolUpdateState {
    <#
.SYNOPSIS
Get information about an AVD hostpool image update state.
.DESCRIPTION
With this function you can get information about an AVD hostpool update.
.PARAMETER HostPoolName
Enter the name of the hostpool you want information from.
.PARAMETER ResourceGroupName
Enter the name of the resourcegroup where the hostpool resides in.
.PARAMETER ResourceId
Enter the hostpool ResourceId
.EXAMPLE
Get-AvdHostPoolUpdateState -Resourceid /subscriptions/xxx/resourceGroups/rg-avd/providers/Microsoft.DesktopVirtualization/hostpools/AVD-Hostpool/
.EXAMPLE
Get-AvdHostPoolUpdateState -Hostpoolname AVD-Hostpool -ResourceGroupName rg-avd
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
        [string]$ResourceId
    )
    Begin {
        Write-Verbose "Start searching for hostpool $hostpoolName"
        AuthenticationCheck
        $token = GetAuthToken -resource $script:AzureApiUrl
        $apiProvider = "/updateDetails/default" 
        switch ($PsCmdlet.ParameterSetName) {
            Name {
                Write-Verbose "Name and ResourceGroup provided"
                $url = "{0}/subscriptions/{1}/resourceGroups/{2}/providers/Microsoft.DesktopVirtualization/hostpools/{3}{4}?api-version={5}" -f $script:AzureApiUrl, $script:subscriptionId, $ResourceGroupName, $HostpoolName, $apiProvider, $script:hostpoolUpdateApiVersion
            }
            ResourceId {
                Write-Verbose "ResourceId provided"
                $url = "{0}{1}/{2}?api-version={3}" -f $script:AzureApiUrl, $resourceId, $apiProvider, $script:HostpoolApiVersion
            }
        }
        $parameters = @{
            uri     = $url
            Headers = $token
        }
    }
    Process {
        try {
            $parameters = @{
                uri     = $url
                Method  = "GET"
                Headers = $token
            }
            $results = Invoke-RestMethod @parameters
            $results.properties.updateProgress | Add-Member -MemberType NoteProperty -Name "updateStatus" -Value $results.properties.updateStatus
            $results.properties.updateProgress
        }
        catch { 
            Write-Error $_.Exception.Message
        }
    }
}
