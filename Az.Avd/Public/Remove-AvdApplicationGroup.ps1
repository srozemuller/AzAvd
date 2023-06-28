function Remove-AvdApplicationGroup {
    <#
.SYNOPSIS
Removes an AVD applicationgroup.
.DESCRIPTION
With this function you can remove an AVD application group.
.PARAMETER ApplicationGroupName
Enter the name of the application group you want information from.
.PARAMETER ResourceGroupName
Enter the name of the resourcegroup where the hostpool resides in.
.PARAMETER ResourceId
Enter the applicationgroup resourceId.
.EXAMPLE
Remove-AvdApplicationGroup -ApplicationGroupName applicationGroup -ResourceGroupName rg-avd-001
.EXAMPLE
Remove-AvdApplicationGroup -ResourceId "/subscriptions/../applicationGroupname"
#>
    [CmdletBinding(DefaultParameterSetName = "All")]
    param (
        [Parameter(Mandatory, ParameterSetName = "Name")]
        [ValidateNotNullOrEmpty()]
        [string]$Name,

        [Parameter(Mandatory, ParameterSetName = "All")]
        [Parameter(Mandatory, ParameterSetName = "Name")]
        [ValidateNotNullOrEmpty()]
        [string]$ResourceGroupName,

        [Parameter(Mandatory, ParameterSetName = "ResourceId")]
        [ValidateNotNullOrEmpty()]
        [string]$ResourceId

    )
    Begin {
        Write-Verbose "Start searching for application group $Name"
        AuthenticationCheck
        $token = GetAuthToken -resource $global:AzureApiUrl
        switch ($PsCmdlet.ParameterSetName) {
            Name {
                Write-Verbose "Name and ResourceGroup provided"
                $url = "{0}/subscriptions/{1}/resourceGroups/{2}/providers/Microsoft.DesktopVirtualization/applicationGroups/{3}?api-version={4}" -f $global:AzureApiUrl, $global:subscriptionId, $ResourceGroupName, $Name, $global:applicationGroupApiVersion
            }
            ResourceId {
                Write-Verbose "ResourceId provided"
                $url = "{0}{1}?api-version={2}" -f $global:AzureApiUrl, $ResourceId, $global:applicationGroupApiVersion
            }
            default {
                Write-Verbose "Getting all application groups in $ResourceGroupName"
                $url = "{0}/subscriptions/{1}/resourceGroups/{2}/providers/Microsoft.DesktopVirtualization/applicationGroups?api-version={3}" -f $global:AzureApiUrl, $global:subscriptionId, $ResourceGroupName, $global:applicationGroupApiVersion
            }
        }
    }
    Process {
        $parameters = @{
            uri     = $url
            Headers = $token
            Method  = "DELETE"
        }
        $results = Request-Api @parameters
        $results
    }
}
