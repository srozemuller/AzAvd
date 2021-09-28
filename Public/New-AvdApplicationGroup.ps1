function New-AvdApplicationGroup {
<#
.SYNOPSIS
Creates a new AVD applicationgroup information
.DESCRIPTION
With this function you can create a new AVD application group.
.PARAMETER ApplicationGroupName
Enter the name of the application group.
.PARAMETER ResourceGroupName
Enter the name of the resourcegroup where to deploy the application group.
.PARAMETER description
Enter the description of the application group.
.PARAMETER friendlyName
Enter the friendlyName of the application group.
.PARAMETER location
Enter the location where to deploy application group.
.PARAMETER tags
If the resource needs tags, enter them in here.
.PARAMETER hostpoolResourceId
Enter the hostpool resource ID where to assign the application group to.
.PARAMETER workspaceResourceId
If there is a workspace allready, fill in the workspace resource ID where to assign the application group to.
.PARAMETER type
Enter the application group type. (eg. RemoteApp or Desktop)
.EXAMPLE
New-AvdApplicationGroup -ApplicationGroupName applicationGroupname -ResourceGroupName rg-avd-001 -location WestEurope -type Desktop -hostpoolResourceId "/resourceID"
.EXAMPLE
New-AvdApplicationGroup -ApplicationGroupName applicationGroupname -ResourceGroupName rg-avd-001 -location WestEurope -type Desktop -tags @{tag="value"}
#>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$ApplicationGroupName,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$description,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$friendlyName,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$ResourceGroupName,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$location,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [object]$tags,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$hostpoolResourceId,
        
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$workspaceResourceId,

        [Parameter(Mandatory = $true)]
        [ValidateSet("RemoteApp", "Desktop")]
        [ValidateNotNullOrEmpty()]
        [string]$type

    )
    Begin {
        Write-Verbose "Start searching for hostpool $hostpoolName"
        AuthenticationCheck
        $token = GetAuthToken -resource $script:AzureApiUrl
        $apiVersion = "?api-version=2019-12-10-preview"
        $url = $script:AzureApiUrl + "/subscriptions/" + $script:subscriptionId + "/resourceGroups/" + $ResourceGroupName + "/providers/Microsoft.DesktopVirtualization/applicationGroups/" + $ApplicationGroupName + $apiVersion
    }
    Process {
        $body = @{
            location = $location
            tags = $tags
            properties = @{
              description = $description
              friendlyName = $friendlyName
              hostPoolArmPath = $hostpoolResourceId
              applicationGroupType = $type
            }
        }
        if ($workspaceResourceId){$body.properties.Add("workspaceArmPath", $workspaceResourceId)}
        $parameters = @{
            uri     = $url
            Method  = "PUT"
            Body = $body | ConvertTo-Json
            Headers = $token
        }
        $results = Invoke-RestMethod @parameters
        return $results
    }
    End {}
}
