function Enable-AvdDiagnostics {
    <#
    .SYNOPSIS
    Enables the AVD Diagnostics and will send it to a new LogAnalytics workspace
    .DESCRIPTION
    The function will enable AVD diagnostics for a hostpool. It will create a new Log Analytics workspace if no existing workspace is provided.
    .PARAMETER HostPoolName
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
    .PARAMETER DiagnosticsName
    The diagnostics name shown in the hostpool diagnostics overview
    .PARAMETER Categories
    The categories you like to save in Log Analytics
    .PARAMETER RetentionInDays
    How long should the data be saved
    .PARAMETER AutoCreate
    Use this switch to auto create a Log Analtyics Workspace
    .EXAMPLE
    Enable-AvdDiagnostics -HostPoolName avd-hostpool-001 -ResourceGroupName rg-avd-001 -LAWorkspace 'la-avd-workspace' -Categories ("Checkpoint","Error")
    .EXAMPLE
    Enable-AvdDiagnostics -Id /subscription/.../ -LAWorkspace 'la-avd-workspace' -Categories ("Checkpoint","Error") -LaResourceGroupName 'la-rg' -LaLocation 'westeurope' -RetentionInDays 30 -AutoCreate
    #>
    [CmdletBinding(DefaultParameterSetName = 'Friendly')]
    param (
        [parameter(Mandatory, ParameterSetName = 'Friendly')]
        [parameter(Mandatory, ParameterSetName = 'Create-Friendly')]
        [ValidateNotNullOrEmpty()]
        [string]$HostpoolName,

        [parameter(Mandatory, ParameterSetName = 'Friendly')]
        [parameter(Mandatory, ParameterSetName = 'Create-Friendly')]
        [ValidateNotNullOrEmpty()]
        [string]$ResourceGroupName,

        [parameter(Mandatory, ParameterSetName = 'Id', ValueFromPipelineByPropertyName)]
        [parameter(Mandatory, ParameterSetName = 'Create-Id')]
        [ValidateNotNullOrEmpty()]
        [string]$Id,

        [parameter(Mandatory, ParameterSetName = 'Friendly')]
        [parameter(Mandatory, ParameterSetName = 'Id')]
        [parameter(Mandatory, ParameterSetName = 'Create-Id')]
        [parameter(Mandatory, ParameterSetName = 'Create-Friendly')]
        [string]$LAWorkspace,

        [parameter(ParameterSetName = 'Create-Id')]
        [parameter(ParameterSetName = 'Create-Friendly')]
        [ValidateSet("CapacityReservation", "Free", "LACluster", "PerGB2018", "PerNode", "Premium", "Standalone", "Standard")]
        [string]$LASku = "Standard",

        [parameter(Mandatory, ParameterSetName = 'Friendly')]
        [parameter(Mandatory, ParameterSetName = 'Id')]
        [parameter(Mandatory, ParameterSetName = 'Create-Id')]
        [parameter(Mandatory, ParameterSetName = 'Create-Friendly')]
        [string]$LaResourceGroupName,
        
        [parameter(ParameterSetName = 'Friendly')]
        [parameter(ParameterSetName = 'Id')]
        [parameter(ParameterSetName = 'Create-Id')]
        [parameter(ParameterSetName = 'Create-Friendly')]
        [string]$DiagnosticsName = "AVD-Diagnostics",


        [parameter(Mandatory, ParameterSetName = 'Create-Id')]
        [parameter(Mandatory, ParameterSetName = 'Create-Friendly')]
        [string]$LaLocation,

        [parameter(Mandatory, ParameterSetName = 'Friendly')]
        [parameter(Mandatory, ParameterSetName = 'Id')]
        [parameter(Mandatory, ParameterSetName = 'Create-Id')]
        [parameter(Mandatory, ParameterSetName = 'Create-Friendly')]
        [ValidateSet("Checkpoint", "Error", "Management", "Connection", "HostRegistration", "AgentHealthStatus", "NetworkData", "SessionHostManagement", "ConnectionGraphicsData")]
        [array]$Categories,

        [parameter(Mandatory, ParameterSetName = 'Create-Id')]
        [parameter(Mandatory, ParameterSetName = 'Create-Friendly')]
        [int]$RetentionInDays,

        [parameter(Mandatory, ParameterSetName = 'Create-Id')]
        [parameter(Mandatory, ParameterSetName = 'Create-Friendly')]
        [switch]$AutoCreate
        
    )
    Begin {
        AuthenticationCheck
        $token = GetAuthToken -resource $global:AzureApiUrl
    }
    Process {
        switch ($PsCmdlet.ParameterSetName) {
            Friendly {
                $parameters = @{
                    HostPoolName      = $HostpoolName 
                    ResourceGroupName = $ResourceGroupName
                }
                $Id = Get-AvdHostPool @parameters | Select-Object Id
            }
            default {
                Write-Verbose "Got the hostpool's resource ID. Thank you for that!"
            }
        }
        Write-Verbose "Looking for workspace"
        $workspaceUrl = "{0}/subscriptions/{1}/resourceGroups/{2}/providers/Microsoft.OperationalInsights/workspaces/{3}?api-version={4}" -f $global:AzureApiUrl, $global:subscriptionId, $LaResourceGroupName, $LAWorkspace, $global:diagnosticsApiVersion
        Write-Verbose $workspaceUrl
        $loganalyticsParameters = @{
            URI     = $workspaceUrl 
            Method  = "GET"
            Headers = $token
        }
        $laws = Invoke-RestMethod @loganalyticsParameters

        if ($null -eq $laws) {
            if ($AutoCreate.IsPresent) {
                Write-Warning "No Log Analytics Workspace found! Creating a new workspace"
                if ($null -eq $LAWorkspace) {
                    $LAWorkspace = "log-analytics-avd-" + (Get-Random -Maximum 99999)
                    Write-Verbose "No Log Analytics Workspace provided, creating a new one."
                    Write-Verbose "Workspace name: $LAWorkspace"    
                } 
                $body = @{
                    location   = $LaLocation
                    properties = @{
                        retentionInDays = $RetentionInDays
                        sku             = @{
                            name = $LASku
                        }
                    }
                }
                $url = "{0}/subscriptions/{1}/resourceGroups/{2}/providers/Microsoft.OperationalInsights/workspaces/{3}?api-version={4}" -f $global:AzureApiUrl, $global:subscriptionId, $LaResourceGroupName, $LAWorkspace, $global:diagnosticsApiVersion
                $loganalyticsParameters = @{
                    URI     = $url 
                    Method  = "PUT"
                    Body    = $body | ConvertTo-Json
                    Headers = $token
                }
                $laws = Invoke-RestMethod @loganalyticsParameters
            }
            else {
                Throw "No workspace found! If it is a new workspace, add -AutoCreate in your command, $_"
            }
        }
        else {
            Write-Information "Workspace found, configuring diagnostics" -InformationAction Continue
        }
        $categoryArray = @()
        $Categories | ForEach-Object {
            $category = @{
                Category = $_
                Enabled  = $true
            }
            $categoryArray += ($category)
        }
        $diagnosticsBody = @{
            Properties = @{
                workspaceId = $laws.id
                logs        = @($categoryArray)
            }
        }    
        $parameters = @{
            uri     = "{0}{1}/providers/microsoft.insights/diagnosticSettings/{2}?api-version={3}" -f $global:AzureApiUrl, $Id, $DiagnosticsName, $global:AvdDiagnosticsApiVersion
            Method  = "PUT"
            Headers = $token
            Body    = $diagnosticsBody | ConvertTo-Json -Depth 4
        }
        Invoke-RestMethod @parameters
        Write-Verbose "Diagnostics enabled for $HostpoolName, sending info to $LAWorkspace"
    }
}