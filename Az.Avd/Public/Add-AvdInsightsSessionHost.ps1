function Add-AvdInsightsSessionHost {
    <#
    .SYNOPSIS
    Adds an AVD session host to the AVD Insights workbook.
    .DESCRIPTION
    The function will install the needed extensions on the AVD session host.
    .PARAMETER Id
    Enter the session host's resource ID (Not VM, use Get-AvdSessionHost or Get-AvdSessionHostResources to get the ID).
    .PARAMETER WorkSpaceId
    Enter the Log Analytics Workspace's resource ID.
    .PARAMETER LASku
    Enter the name of the Log Analytics SKU
    .PARAMETER LAWorkspace
    Enter the name of the Log Analytics Workspace
    .PARAMETER LaResourceGroupName
    Enter the name of the Log Analyics Workspace resource group
    .EXAMPLE
    Add-AvdInsightsSessionHost -Id /subscriptions/../sessionhosts/avd-0 -WorkSpaceId /subscriptions/../Microsoft.OperationalInsights/workspaces/laworkspace
    .EXAMPLE
    Add-AvdInsightsSessionHost -Id /subscriptions/../sessionhosts/avd-0 -LAWorkspace laworkspace -LaResourceGroupName rg-la-01
    #>
    [CmdletBinding(DefaultParameterSetName = 'Id')]
    param (
        [parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [string]$Id,

        [parameter(Mandatory, ParameterSetName = 'Id')]
        [ValidateNotNullOrEmpty()]
        [string]$WorkSpaceId,

        [parameter(Mandatory, ParameterSetName = 'WorkspaceName')]
        [string]$LAWorkspace,

        [parameter(Mandatory, ParameterSetName = 'WorkspaceName')]
        [string]$LaResourceGroupName
    )
    Begin {
        AuthenticationCheck
        $token = GetAuthToken -resource $global:AzureApiUrl
    }
    Process {
        switch ($PsCmdlet.ParameterSetName) {
            WorkspaceName {
                $WorkSpaceId = "/subscriptions/{0}/resourceGroups/{1}/providers/Microsoft.OperationalInsights/workspaces/{2}" -f $global:subscriptionId, $LaResourceGroupName, $LAWorkspace
            }
            default {
                Write-Verbose "[Add-AvdInsightsSessionHost] - Got a session host's resource ID. Thank you for that!"
            }
        }
        Write-Verbose "[Add-AvdInsightsSessionHost] - Looking for workspace"
        Write-Verbose $WorkSpaceId
        $laws = Get-Resource -Method "GET" -ResourceId $WorkSpaceId -ApiVersion $global:diagnosticsApiVersion -Verbose
        $lawsKey = Get-Resource -Method "POST" -ResourceId $WorkSpaceId -ApiVersion $global:diagnosticsApiVersion -UrlAddition '/sharedKeys'  -Verbose 
        
        if ($null -eq $laws) {
            Throw "No workspace found! If it is a new workspace, create the workspace first, $_"
        }
        else {
            try {
                Write-Information "[Add-AvdInsightsSessionHost] -  Workspace and sessionhosts found, adding to AVD Insights" -InformationAction Continue
                $sessionhostResource = Get-AvdSessionHostResources -Id $Id
                $sessionhostResource | ForEach-Object {
                    $vmObject = $_
                    $vmPowerState = Get-AvdSessionHostPowerState -Id $vmObject.id
                    if ($vmPowerState.powerstate -ne 'running') {
                        Write-Warning "[Add-AvdInsightsSessionHost] - Sessionhost $($_.name) not running, starting machine from $($vmPowerState.powerstate) state"
                        Start-AvdSessionHost -Id $vmObject.id
                    }
                    $extensionBody = @{
                        location   = $_.vmResources.location
                        properties = @{
                            publisher               = "Microsoft.EnterpriseCloud.Monitoring"
                            type                    = "MicrosoftMonitoringAgent"
                            typeHandlerVersion      = "1.0"
                            autoUpgradeMinorVersion = $true
                            settings                = @{
                                workspaceId = $laws.properties.customerId
                            }
                            protectedSettings       = @{
                                workspaceKey = $lawsKey.primarySharedKey
                            }
                        }
                    }
                    $requestParameters = @{
                        uri     = "{0}{1}/extensions/{2}?api-version={3}" -f $global:AzureApiUrl, $_.vmResources.id, "OMSExtenstion", "2022-08-01"
                        Method  = "PUT"
                        Headers = $token
                        Body    = $extensionBody | ConvertTo-Json -Depth 99
                    }
                    Invoke-RestMethod @requestParameters
                    switch ($vmPowerState.powerstate){
                        stopped {
                            Write-Information "[Add-AvdInsightsSessionHost] - Sessionhost was $($vmPowerState.powerstate), bringing back to initial state" -InformationAction Continue
                            Stop-AvdSessionHost -Id $vmObject.id
                        }
                        deallocated {
                            Write-Information "[Add-AvdInsightsSessionHost] - Sessionhost was $($vmPowerState.powerstate), bringing back to initial state" -InformationAction Continue
                            Stop-AvdSessionHost -Id $vmObject.id -Deallocate
                        }
                        default {
                            Write-Information "[Add-AvdInsightsSessionHost] - Sessionhost was $($vmPowerState.powerstate), taking no further action" -InformationAction Continue
                        }
                    }
                }
            }
            catch {
                Throw "[Add-AvdInsightsSessionHost] - $_"
            }
        }
    }
}