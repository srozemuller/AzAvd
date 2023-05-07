function Get-AvdInsightsSessionHost {
    <#
    .SYNOPSIS
    Adds an AVD session host to the AVD Insights workbook.
    .DESCRIPTION
    The function will install the needed extensions on the AVD session host.
    .PARAMETER WorkSpaceId
    Enter the Log Analytics Workspace's resource ID.
    .PARAMETER LAWorkspace
    Enter the name of the Log Analytics Workspace
    .PARAMETER LaResourceGroupName
    Enter the name of the Log Analyics Workspace resource group
    .EXAMPLE
    Get-AvdInsightsSessionHost -Id /subscriptions/../sessionhosts/avd-0 -WorkSpaceId /subscriptions/../Microsoft.OperationalInsights/workspaces/laworkspace
    .EXAMPLE
    Get-AvdInsightsSessionHost -Id /subscriptions/../sessionhosts/avd-0 -LAWorkspace laworkspace -LaResourceGroupName rg-la-01
    #>
    [CmdletBinding(DefaultParameterSetName = 'WorkspaceName')]
    param (

        [parameter(Mandatory,ParameterSetName = 'WorkspaceId')]
        [parameter(Mandatory, ParameterSetName = 'WorkspaceName')]
        [ValidateNotNullOrEmpty()]
        [string]$HostpoolName,

        [parameter(Mandatory,ParameterSetName = 'WorkspaceId')]
        [parameter(Mandatory, ParameterSetName = 'WorkspaceName')]
        [ValidateNotNullOrEmpty()]
        [string]$ResourceGroupName,

        [parameter(ParameterSetName = 'WorkspaceId')]
        [parameter(ParameterSetName = 'WorkspaceName')]
        [ValidateNotNullOrEmpty()]
        [string]$Name,

        [parameter(Mandatory, ParameterSetName = 'WorkspaceResourceId')]
        [parameter(Mandatory,ParameterSetName = 'WorkspaceNameResourceId')]
        [ValidateNotNullOrEmpty()]
        [string]$Id,

        [parameter(Mandatory,ParameterSetName = 'WorkspaceId')]
        [parameter(Mandatory,ParameterSetName = 'WorkspaceResourceId')]
        [ValidateNotNullOrEmpty()]
        [string]$WorkSpaceId,

        [parameter(Mandatory, ParameterSetName = 'WorkspaceName')]
        [parameter(Mandatory,ParameterSetName = 'WorkspaceNameResourceId')]
        [string]$LAWorkspace,

        [parameter(Mandatory, ParameterSetName = 'WorkspaceName')]
        [parameter(Mandatory,ParameterSetName = 'WorkspaceNameResourceId')]
        [string]$LaResourceGroupName,

        [parameter()]
        [switch]$Missing
    )
    Begin {
        Write-Verbose "Start searching for resources"
        AuthenticationCheck
    }
    Process {
        switch ($PsCmdlet.ParameterSetName) {
            All {
                $parameters = @{
                    HostPoolName      = $HostpoolName
                    ResourceGroupName = $ResourceGroupName
                }
            }
            Hostname {
                $parameters = @{
                    hostPoolName      = $HostpoolName
                    resourceGroupName = $ResourceGroupName
                    name              = $Name
                }
            }
            Resource {
                Write-Verbose "Got a resource object, looking for $Id"
                $parameters = @{
                    Id = $Id
                }
            }
            default {
                $parameters = @{
                    HostPoolName      = $HostpoolName
                    ResourceGroupName = $ResourceGroupName
                }
            }
        }
        try {
            $sessionHosts = Get-AvdSessionHostResources @parameters
        }
        catch {
            Throw "No sessionhosts ($name) found in $HostpoolName ($ResourceGroupName), $_"
        }
        $sessionHosts | Foreach-Object {
            Write-Verbose "Searching for $($_.Name)"
            $monitoringEnabled = $false
            $monitoringInfo = $_.vmresources.resources | Where-Object {$_.Name -eq "OMSExtenstion"}
            try {
                $object = @{
                    name = $_.Name
                    id = $_.id
                }
                if ($monitoringInfo) {
                    $monitoringEnabled = $true
                    $autoUpgradeMinorVersion = $monitoringInfo.properties.autoUpgradeMinorVersion
                }
                else {}
                $object.Add("monitoringEnabled",$monitoringEnabled)
                $object.Add("autoUpgradeMinorVersion",$autoUpgradeMinorVersion)
                $object.Add("provisioningState",$monitoringInfo.properties.provisioningState)
                $object.Add("type",$monitoringInfo.properties.type)
                $object.Add("workspaceId",$monitoringInfo.properties.settings.workspaceId)
            }
            catch {
                Write-Warning "Sessionhost $($_.name) has no resources, consider deleting it. Use the Remove-AvdSessionHost command, $_. URI is $($requestparameters.uri)"
            }
            $_ | Add-Member -NotePropertyName vmResources -NotePropertyValue $resource -Force
        }
    }
    End {
        $sessionHosts
    }
}