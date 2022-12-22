function Enable-AvdInsightsCounters {
    <#
    .SYNOPSIS
    Enables the AVD Diagnostics and will send it to a new LogAnalytics workspace
    .DESCRIPTION
    The function will enable AVD diagnostics for a hostpool. It will create a new Log Analytics workspace if no existing workspace is provided.
    .PARAMETER WorkspaceName
    Enter the name of the hostpool you want to enable start vm on connnect.
    .PARAMETER ResourceGroupName
    Enter the name of the resourcegroup where the hostpool resides in.
    .PARAMETER Id
    Enter the host pool's resource ID.
    .PARAMETER LASku
    Enter the name of the Log Analytics SKU
    .PARAMETER LAWorkspace
    Enter the name of the Log Analytics Workspace
    .PARAMETER LaResourceGroupName
    Enter the name of the Log Analyics Workspace resource group
    .PARAMETER AdditionalCategories
    The categories you like extra to save in Log Analytics, beside the mandatory categories for AVD Insights.
    .PARAMETER RetentionInDays
    How long should the data be saved
    .PARAMETER AutoCreate
    Use this switch to auto create a Log Analtyics Workspace
    .EXAMPLE
    Enable-AvdHostpoolInsights -HostPoolName avd-hostpool-001 -ResourceGroupName rg-avd-001 -LAWorkspace 'la-avd-workspace' -Categories ("Checkpoint","Error")
    .EXAMPLE
    Enable-AvdHostpoolInsights -Id /subscription/.../ -LAWorkspace 'la-avd-workspace' -Categories ("Checkpoint","Error") -LaResourceGroupName 'la-rg' -LaLocation 'westeurope' -RetentionInDays 30 -AutoCreate
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
        [parameter(Mandatory, ParameterSetName = 'Create-Friendly')]
        [string]$LAWorkspace,

        [parameter(ParameterSetName = 'Create-Friendly')]
        [ValidateSet("CapacityReservation", "Free", "LACluster", "PerGB2018", "PerNode", "Premium", "Standalone", "Standard")]
        [string]$LASku = "Standard",

        [parameter(Mandatory, ParameterSetName = 'WorkspaceName')]
        [parameter(Mandatory, ParameterSetName = 'Create-Friendly')]
        [string]$LaResourceGroupName,
        
        [parameter(Mandatory, ParameterSetName = 'Create-Friendly')]
        [string]$LaLocation,

        [parameter(Mandatory, ParameterSetName = 'Create-Friendly')]
        [int]$RetentionInDays,

        [parameter(Mandatory, ParameterSetName = 'Create-Friendly')]
        [switch]$AutoCreate
        
    )
    Begin {
        AuthenticationCheck
        $token = GetAuthToken -resource $Script:AzureApiUrl
    }
    Process {
        switch ($PsCmdlet.ParameterSetName) {
            WorkspaceName {
                $WorkSpaceId = "/subscriptions/{0}/resourceGroups/{1}/providers/Microsoft.OperationalInsights/workspaces/{2}" -f $script:subscriptionId, $LaResourceGroupName, $LAWorkspace
            }
            default {
                Write-Verbose "Got a session host's resource ID. Thank you for that!"
            }
        }
        Write-Verbose "Looking for workspace"
        Write-Verbose $laWorkspaceId
        $laws = Get-Resource -Method "GET" -ResourceId $WorkSpaceId -ApiVersion $script:diagnosticsApiVersion -Verbose
        $lawsKey = Get-Resource -Method "POST" -ResourceId $WorkSpaceId -ApiVersion $script:diagnosticsApiVersion -UrlAddition '/sharedKeys'  -Verbose 
        
        if ($null -eq $laws) {
            Throw "No workspace found! If it is a new workspace, create the workspace first, $_"
        }
        else {
            try {
                Write-Information "Workspace and sessionhosts found, adding to AVD Insights" -InformationAction Continue
                $sessionhostResource = Get-AvdSessionHostResources -Id $Id
                $sessionhostResource.vmResources | ForEach-Object {
                    $extensionBody = @{
                        location = $_.location
                        properties = @{
                            publisher = "Microsoft.EnterpriseCloud.Monitoring"
                            type = "MicrosoftMonitoringAgent"
                            typeHandlerVersion = "1.0"
                            autoUpgradeMinorVersion = $true
                            settings = @{
                                workspaceId = $laws.properties.customerId
                            }
                            protectedSettings = @{
                                workspaceKey = $lawsKey.primarySharedKey
                            }
                        }
                    }
                    $requestParameters = @{
                        uri     = "{0}{1}/extensions/{2}?api-version={3}" -f $Script:AzureApiUrl, $_.id, "OMSExtenstion", "2022-08-01"
                        Method  = "PUT"
                        Headers = $token
                        Body    = $extensionBody | ConvertTo-Json -Depth 99
                    }
                    Invoke-RestMethod @requestParameters
                }
            }
            catch {
                Throw $_
            }
        }
    }
}