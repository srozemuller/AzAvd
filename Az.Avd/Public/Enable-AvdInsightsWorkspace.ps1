function Enable-AvdInsightsWorkspace {
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
        [parameter(Mandatory, ParameterSetName = 'HostpoolLevel')]
        [parameter(Mandatory, ParameterSetName = 'Create-Friendly')]
        [ValidateNotNullOrEmpty()]
        [string]$HostpoolName,

        [parameter(Mandatory, ParameterSetName = 'HostpoolLevel')]
        [parameter(Mandatory, ParameterSetName = 'Create-Friendly')]
        [ValidateNotNullOrEmpty()]
        [string]$ResourceGroupName,

        [parameter(Mandatory, ParameterSetName = 'Id', ValueFromPipelineByPropertyName)]
        [parameter(Mandatory, ParameterSetName = 'Create-Id')]
        [ValidateNotNullOrEmpty()]
        [string]$Id,

        [parameter(Mandatory, ParameterSetName = 'SingleLevel')]
        [ValidateNotNullOrEmpty()]
        [string]$WorkspaceName,

        [parameter(Mandatory, ParameterSetName = 'SingleLevel')]
        [ValidateNotNullOrEmpty()]
        [string]$WorkspaceResourceGroup,

        [parameter(Mandatory, ParameterSetName = 'HostpoolLevel')]
        [parameter(Mandatory, ParameterSetName = 'Id')]
        [parameter(Mandatory, ParameterSetName = 'Create-Id')]
        [parameter(Mandatory, ParameterSetName = 'Create-Friendly')]
        [string]$LAWorkspace,

        [parameter(ParameterSetName = 'Create-Id')]
        [parameter(ParameterSetName = 'Create-Friendly')]
        [ValidateSet("CapacityReservation", "Free", "LACluster", "PerGB2018", "PerNode", "Premium", "Standalone", "Standard")]
        [string]$LASku = "Standard",

        [parameter(Mandatory, ParameterSetName = 'HostpoolLevel')]
        [parameter(Mandatory, ParameterSetName = 'Id')]
        [parameter(Mandatory, ParameterSetName = 'Create-Id')]
        [parameter(Mandatory, ParameterSetName = 'Create-Friendly')]
        [string]$LaResourceGroupName,
        
        [parameter(Mandatory, ParameterSetName = 'Create-Id')]
        [parameter(Mandatory, ParameterSetName = 'Create-Friendly')]
        [string]$LaLocation,

        [parameter(ParameterSetName = 'HostpoolLevel')]
        [parameter(ParameterSetName = 'Id')]
        [parameter(ParameterSetName = 'Create-Id')]
        [parameter(ParameterSetName = 'Create-Friendly')]
        [ValidateSet("NetworkData", "SessionHostManagement", "ConnectionGraphicsData")]
        [array]$AdditionalCategories,

        [parameter(Mandatory, ParameterSetName = 'Create-Id')]
        [parameter(Mandatory, ParameterSetName = 'Create-Friendly')]
        [int]$RetentionInDays,

        [parameter(Mandatory, ParameterSetName = 'HostpoolLevel')]
        [parameter(Mandatory, ParameterSetName = 'Id')]
        [parameter(Mandatory, ParameterSetName = 'Create-Id')]
        [parameter(Mandatory, ParameterSetName = 'Create-Friendly')]
        [string]$DiagnosticsName,

        [parameter(Mandatory, ParameterSetName = 'Create-Id')]
        [parameter(Mandatory, ParameterSetName = 'Create-Friendly')]
        [switch]$AutoCreate
        
    )
    Begin {
        AuthenticationCheck
        $token = GetAuthToken -resource $Script:AzureApiUrl
    }
    Process {
        switch ($PsCmdlet.ParameterSetName) {
            HostpoolLevel {
                $parameters = @{
                    HostPoolName      = $HostpoolName 
                    ResourceGroupName = $ResourceGroupName
                }
                $hostpoolId = Get-AvdHostPool @parameters | Select-Object Id
                $applicationGroup = Get-AvdApplicationGroup -ResourceGroupName $ResourceGroupName | Where-Object { $hostpoolId.id -in $_.properties.hostpoolArmPath }
                
            }
            SingleLevel {
                $appGroupParameters = @{
                    ApplicationGroupName = $ApplicationGroupName 
                    ResourceGroupName    = $ApplicationResourceGroup
                }
                $applicationGroup = Get-AvdApplicationGroup @appGroupParameters
            }
            default {
                Write-Verbose "Got the applicationgroup's resource ID. Thank you for that!"
            }
        }
        Write-Verbose "Looking for workspace"
        $laWorkspaceId = "/subscriptions/{0}/resourceGroups/{1}/providers/Microsoft.OperationalInsights/workspaces/{2}" -f $script:subscriptionId, $LaResourceGroupName, $LAWorkspace
        Write-Verbose $laWorkspaceId
        $laws = Get-Resource -ResourceId $workspaceId -Verbose

        if ($null -eq $laws) {
            try {
                if ($AutoCreate.IsPresent) {
                    Write-Warning "No Log Analytics Workspace found! Creating a new workspace"
                    $laws = New-Workspace -Workspace $LAWorkspace -Sku $LASku -ResourceGroupName $LaResourceGroupName -Location $LaLocation
                }
                else {
                    Throw "No workspace found! If it is a new workspace, add -AutoCreate in your command, $_"
                }
            }
            catch {
                Throw $_
            }
        }
        else {
            try {
                Write-Information "Workspace found, configuring diagnostics" -InformationAction Continue
                $categoryArray = @()
                $mandatoryCategories = @("Checkpoint", "Error", "Management", "Feed")
                $mandatoryCategories | ForEach-Object {
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
                if ($applicationGroup) {
                    Write-Verbose "Grabbing ID's form application groups"
                    $Id = $applicationGroup.properties.workspaceArmPath
                }
                $Id | ForEach-Object {  
                    $parameters = @{
                        uri     = "{0}{1}/providers/microsoft.insights/diagnosticSettings/{2}?api-version={3}" -f $Script:AzureApiUrl, $_, $DiagnosticsName, $Script:AvdDiagnosticsApiVersion
                        Method  = "PUT"
                        Headers = $token
                        Body    = $diagnosticsBody | ConvertTo-Json -Depth 4
                    }
                    Invoke-RestMethod @parameters
                    Write-Verbose "Diagnostics enabled for $_, sending info to $LAWorkspace"
                }
            }
            catch {
                Throw $_
            }
        }
    }
}