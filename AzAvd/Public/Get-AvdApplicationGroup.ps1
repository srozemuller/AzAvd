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
    [CmdletBinding(DefaultParameterSetName = "Name")]
    param (
        [Parameter(Mandatory, ParameterSetName = "Name")]
        [ValidateNotNullOrEmpty()]
        [string]$ApplicationGroupName,

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
                $url = $script:AzureApiUrl + "/subscriptions/" + $script:subscriptionId + "/resourceGroups/" + $ResourceGroupName + "/providers/Microsoft.DesktopVirtualization/applicationGroups/" + $Name + $apiVersion
            }
            ResourceId {
                Write-Verbose "ResourceId provided"
                $url = $script:AzureApiUrl + $ResourceId + $apiVersion
            }
        }
        $parameters = @{
            uri     = $url
            Headers = $token
            Method  = "GET"
        }
    }
    Process {
        $applicationResults = Invoke-RestMethod @parameters
        $url = $script:AzureApiUrl + "/" + $applicationResults.id + "/providers/Microsoft.Authorization/roleAssignments?api-version=2021-04-01-preview"
        $parameters = @{
            uri     = $url
            Method  = "GET"
            Headers = $token
        }
        $applicationPermissions = Invoke-RestMethod @parameters
        $applicationResults | Add-Member -NotePropertyName assignments -NotePropertyValue $applicationPermissions.value
        return $applicationResults
    }
}
