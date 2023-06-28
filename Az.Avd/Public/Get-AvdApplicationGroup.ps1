function Get-AvdApplicationGroup {
    <#
.SYNOPSIS
Get AVD applicationgroup information with the assigned permissions.
.DESCRIPTION
With this function you can get information about an AVD application group.
.PARAMETER ApplicationGroupName
Enter the name of the application group you want information from.
.PARAMETER ResourceGroupName
Enter the name of the resourcegroup where the application group resides in.
.PARAMETER HostpoolName
Enter the name of the hostpool to look in.
.PARAMETER HostpoolResourceGroup
Enter the name of the resourcegroup where the hostpool resides in.
.PARAMETER ResourceId
Enter the applicationgroup resourceId.
.EXAMPLE
Get-AvdApplicationGroup -Name applicationGroup -ResourceGroupName "rg-avd-001"
.EXAMPLE
Get-AvdApplicationGroup -ResourceId "/subscriptions/../applicationGroupname"
.EXAMPLE
Get-AvdApplicationGroup -HostpoolName "avd-hostpool" -HostpoolResourceGroup "rg-avd-001"
#>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ParameterSetName = "Name")]
        [ValidateNotNullOrEmpty()]
        [string]$Name,

        [Parameter(Mandatory, ParameterSetName = "Name")]
        [ValidateNotNullOrEmpty()]
        [string]$ResourceGroupName,

        [Parameter(Mandatory, ParameterSetName = "Hostpool")]
        [ValidateNotNullOrEmpty()]
        [string]$HostpoolName,

        [Parameter(Mandatory, ParameterSetName = "Hostpool")]
        [ValidateNotNullOrEmpty()]
        [string]$HostpoolResourceGroup,

        [Parameter(Mandatory, ParameterSetName = "ResourceId")]
        [ValidateNotNullOrEmpty()]
        [string]$ResourceId

    )
    Begin {
        Write-Verbose "Start searching for application group $Name"
        switch ($PsCmdlet.ParameterSetName) {
            Name {
                Write-Verbose "Name and ResourceGroup provided"
                $url = "{0}/subscriptions/{1}/resourceGroups/{2}/providers/Microsoft.DesktopVirtualization/applicationGroups/{3}?api-version={4}" -f $global:AzureApiUrl, $global:subscriptionId, $ResourceGroupName, $ApplicationGroupName, $global:applicationGroupApiVersion
            }
            ResourceId {
                Write-Verbose "ResourceId provided"
                $url = "{0}{1}?api-version={2}" -f $global:AzureApiUrl, $ResourceId, $global:applicationGroupApiVersion
            }
            Hostpool {
                Write-Verbose "ResourceId provided"
                $url = "{0}/subscriptions/{1}/providers/Microsoft.DesktopVirtualization/applicationGroups?api-version={2}" -f $global:AzureApiUrl, $global:subscriptionId, $global:applicationGroupApiVersion
                $hostpoolArmPath = "/subscriptions/{0}/resourceGroups/{1}/providers/Microsoft.DesktopVirtualization/hostPools/{2}" -f $global:subscriptionId, $HostpoolResourceGroup, $HostpoolName
            }
            default {
                Write-Verbose "Getting all application groups in $ResourceGroupName"
                $url = "{0}/subscriptions/{1}/providers/Microsoft.DesktopVirtualization/applicationGroups?api-version={2}" -f $global:AzureApiUrl, $global:subscriptionId, $global:applicationGroupApiVersion
            }
        }
    }
    Process {
        $allResults = [System.Collections.ArrayList]@()
        $appParameters = @{
            uri     = $url
            Method  = "GET"
        }
        $applicationResults = Request-Api @appParameters
        if ($PsCmdlet.ParameterSetName -eq 'Hostpool') {
            $applicationResults = $applicationResults | Where-Object { $_.properties.hostpoolArmPath -eq $hostpoolArmPath }
        }
        $applicationResults | ForEach-Object {
            $parameters = @{
                uri     = "{0}/{1}/providers/Microsoft.Authorization/roleAssignments?api-version=2021-04-01-preview" -f $global:AzureApiUrl, $_.id
                Method  = "GET"
            }
            $applicationPermissions = Request-Api @parameters
            $_ | Add-Member -NotePropertyName assignments -NotePropertyValue $applicationPermissions.value
            $allResults.Add($_) | Out-Null
        }
        $allResults
    }
}
