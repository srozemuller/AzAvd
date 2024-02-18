function New-AvdApplicationGroup {
<#
.SYNOPSIS
Creates a new AVD applicationgroup.
.DESCRIPTION
With this function you can create a new AVD application group.
.PARAMETER ApplicationGroupName
Enter the name of the application group.
.PARAMETER ResourceGroupName
Enter the name of the resourcegroup where to deploy the application group.
.PARAMETER Description
Enter the description of the application group.
.PARAMETER FriendlyName
Enter the friendlyName of the application group.
.PARAMETER Location
Enter the location where to deploy application group.
.PARAMETER Tags
If the resource needs tags, enter them in here.
.PARAMETER HostpoolResourceId
Enter the hostpool resource ID where to assign the application group to.
.PARAMETER WorkspaceResourceId
If there is a workspace allready, fill in the workspace resource ID where to assign the application group to.
.PARAMETER Type
Enter the application group type. (eg. RemoteApp or Desktop)
.EXAMPLE
New-AvdApplicationGroup -Name applicationGroupname -ResourceGroupName rg-avd-001 -location WestEurope -ApplicationGroupType Desktop -HostPoolArmPath "/resourceID"
.EXAMPLE
New-AvdApplicationGroup -Name applicationGroupname -ResourceGroupName rg-avd-001 -location WestEurope -ApplicationGroupType Desktop -tags @{tag="value"}
#>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Name,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$Description,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$FriendlyName,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$ResourceGroupName,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Location,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [object]$Tags,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$HostPoolArmPath,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$WorkspaceResourceId,

        [Parameter(Mandatory = $true)]
        [ValidateSet("RemoteApp", "Desktop")]
        [ValidateNotNullOrEmpty()]
        [string]$ApplicationGroupType

    )
    Begin {
        Write-Verbose "Start searching for hostpool $hostpoolName"
        $apiVersion = "?api-version=2019-12-10-preview"
        $url = $global:AzureApiUrl + "/subscriptions/" + $global:subscriptionId + "/resourceGroups/" + $ResourceGroupName + "/providers/Microsoft.DesktopVirtualization/applicationGroups/" + $Name + $apiVersion
    }
    Process {
        $body = @{
            location = $Location
            tags = $Tags
            properties = @{
              description = $Description
              friendlyName = $FriendlyName
              hostPoolArmPath = $HostPoolArmPath
              applicationGroupType = $ApplicationGroupType
            }
        }
        if ($WorkspaceResourceId){$body.properties.Add("workspaceArmPath", $WorkspaceResourceId)}
        $parameters = @{
            uri     = $url
            Method  = "PUT"
            Body = $body | ConvertTo-Json
        }
        $results = Request-Api @parameters
        $results
    }
}
