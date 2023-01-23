function Get-AvdHostPoolUpdateConfiguration {
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
Get-AvdHostPool -HostPoolName avd-hostpool-001 -ResourceGroupName rg-avd-001
.EXAMPLE
Get-AvdHostPool -ResourceId "/subscription/../HostPoolName"
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
        Write-Verbose "Start searching for hostpool update configuration in $hostpoolName"
        AuthenticationCheck
        $token = GetAuthToken -resource $script:AzureApiUrl
        switch ($PsCmdlet.ParameterSetName) {
            Name {
                Write-Verbose "Name and ResourceGroup provided"
                $url = "{0}/subscriptions/{1}/resourceGroups/{2}/providers/Microsoft.DesktopVirtualization/hostpools/{3}/updateDetails?api-version={4}" -f $script:AzureApiUrl, $script:subscriptionId, $ResourceGroupName, $HostpoolName, $script:hostpoolUpdateApiVersion
            }
            ResourceId {
                Write-Verbose "ResourceId provided"
                $url = "{0}{1}/updateDetails?api-version={2}" -f $script:AzureApiUrl, $ResourceId, $script:hostpoolUpdateApiVersion
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
            $response = Invoke-WebRequest @parameters -SkipHttpErrorCheck
            ($response.Content | ConvertFrom-Json).value.properties
        }
        catch {
            Write-Error $_.Exception.Response
        }
    }
}
