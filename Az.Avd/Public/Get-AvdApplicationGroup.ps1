function Get-AvdApplicationGroup {
    <#
.SYNOPSIS
Get AVD applicationgroup information with the assigned permissions.
.DESCRIPTION
With this function you can get information about an AVD application group.
.PARAMETER ApplicationGroupName
Enter the name of the application group you want information from.
.PARAMETER ResourceGroupName
Enter the name of the resourcegroup where the hostpool resides in.
.PARAMETER ResourceId
Enter the applicationgroup resourceId.
.EXAMPLE
Get-AvdApplicationGroup -ApplicationGroupName applicationGroup -ResourceGroupName rg-avd-001
.EXAMPLE
Get-AvdApplicationGroup -ResourceId "/subscriptions/../applicationGroupname"
#>
    [CmdletBinding(DefaultParameterSetName = "All")]
    param (
        [Parameter(Mandatory, ParameterSetName = "Name")]
        [ValidateNotNullOrEmpty()]
        [string]$ApplicationGroupName,

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
        $token = GetAuthToken -resource $script:AzureApiUrl
        $apiVersion = "?api-version=2019-12-10-preview"
        switch ($PsCmdlet.ParameterSetName) {
            Name {
                Write-Verbose "Name and ResourceGroup provided"
                $url = "{0}/subscriptions/{1}/resourceGroups/{2}/providers/Microsoft.DesktopVirtualization/applicationGroups/{3}{4}" -f $script:AzureApiUrl, $script:subscriptionId, $ResourceGroupName, $ApplicationGroupName, $apiVersion
            }
            ResourceId {
                Write-Verbose "ResourceId provided"
                $url = $script:AzureApiUrl + $ResourceId + $apiVersion
            }
            default {
                Write-Verbose "Getting all application groups in $ResourceGroupName"
                $url = "{0}/subscriptions/{1}/resourceGroups/{2}/providers/Microsoft.DesktopVirtualization/applicationGroups{3}" -f $script:AzureApiUrl, $script:subscriptionId, $ResourceGroupName, $apiVersion
            }
        }
    }
    Process {
        $allResults = [System.Collections.ArrayList]@()
        $parameters = @{
            uri     = $url
            Headers = $token
            Method  = "GET"
        }
        $applicationResults = Invoke-RestMethod @parameters
        $applicationResults.value | ForEach-Object {
          
            $url = "{0}/{1}/providers/Microsoft.Authorization/roleAssignments?api-version=2021-04-01-preview" -f $script:AzureApiUrl, $_.id 
            $parameters = @{
                uri     = $url
                Method  = "GET"
                Headers = $token
            }
            $applicationPermissions = Invoke-RestMethod @parameters
            $_ | Add-Member -NotePropertyName assignments -NotePropertyValue $applicationPermissions.value
            $allResults.Add($_) | Out-Null
        }
        $allResults
    }
}
