function Remove-AvdHostPool {
    <#
.SYNOPSIS
Removes AVD Hostpool information.
.DESCRIPTION
With this function you can remove an AVD hostpool.
.PARAMETER HostPoolName
Enter the name of the hostpool you want remove.
.PARAMETER ResourceGroupName
Enter the name of the resourcegroup where the hostpool resides in.
.PARAMETER ResourceId
Enter the hostpool ResourceId
.EXAMPLE
Remove-AvdHostPool -HostPoolName avd-hostpool-001 -ResourceGroupName rg-avd-001
.EXAMPLE
Remove-AvdHostPool -ResourceId "/subscription/../HostPoolName"
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
        switch ($PsCmdlet.ParameterSetName) {
            Name {
                Write-Verbose "Name and ResourceGroup provided"
                $url = "{0}/subscriptions/{1}/resourceGroups/{2}/providers/Microsoft.DesktopVirtualization/hostpools/{3}?api-version={4}" -f $Script:AzureApiUrl, $script:subscriptionId, $ResourceGroupName, $HostpoolName, $script:hostpoolApiVersion
            }
            ResourceId {
                Write-Verbose "ResourceId provided"
                $url = "{0}{1}?api-version={2}" -f $script:AzureApiUrl, $resourceId, $script:hostpoolApiVersion
            }
        }
    }
    Process {
        try {
            $parameters = @{
                uri     = $url
                Method  = "DELETE"
                Headers = $token
            }
            $results = Request-Api @parameters
            $results
        }
        catch {
            Write-Error -Message "An error occurred while removing hostpool $hostpoolName. Error message: $($_)"
        }
    }
}
