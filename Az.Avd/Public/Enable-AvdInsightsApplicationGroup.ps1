function Enable-AvdInsightsApplicationGroup {
    <#
    .SYNOPSIS
    Enables the AVD Diagnostics and will send it to a new LogAnalytics workspace
    .DESCRIPTION
    The function will enable AVD diagnostics for a application group. It will create a new Log Analytics workspace if no existing workspace is provided.
    .PARAMETER HostPoolName
    Enter the name of the hostpool you want to enable start vm on connnect.
    .PARAMETER ResourceGroupName
    Enter the name of the resourcegroup where the hostpool resides in.
    .PARAMETER Id
    Enter the application group's resource ID.
    .PARAMETER ApplicationGroupName
    Enter the application group's name.
    .PARAMETER ApplicationResourceGroup
    Enter the application group's resource group.    
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
    .PARAMETER DiagnosticsName
    Enter the diagnostics display name
    .PARAMETER AutoCreate
    Use this switch to auto create a Log Analtyics Workspace
    .EXAMPLE
    Enable-AvdInsightsApplicationGroup -HostPoolName avd-hostpool-001 -ResourceGroupName rg-avd-001 -LAWorkspace 'la-avd-workspace' -LaResourceGroupName 'rg-la-01' -DiagnosticsName "AvdInsights"
    .EXAMPLE
    Enable-AvdInsightsApplicationGroup -ApplicationGroupName avd-appgroup-01 -ApplicationResourceGroup rg-avd-001 -LAWorkspace 'la-avd-workspace' -LaResourceGroupName 'rg-la-01' -DiagnosticsName "AvdInsights"
    .EXAMPLE
    Enable-AvdInsightsApplicationGroup -ApplicationGroupName avd-appgroup-01 -ApplicationResourceGroup rg-avd-001 -LAWorkspace 'la-avd-workspace' -LaResourceGroupName 'rg-la-01' -LAWorkspace 'la-avd-workspace' -LaResourceGroupName 'la-rg' -LaLocation 'westeurope' -RetentionInDays 30 -AutoCreate -DiagnosticsName "AvdInsights"
    .EXAMPLE
    Enable-AvdInsightsApplicationGroup -Id /subscription/../applicationgroup/groupname -LAWorkspace 'la-avd-workspace' -LaResourceGroupName 'la-rg' -LaLocation 'westeurope' -RetentionInDays 30 -AutoCreate -DiagnosticsName "AvdInsights"
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
        [object]$Id,

        [parameter(Mandatory, ParameterSetName = 'SingleLevel')]
        [parameter(Mandatory, ParameterSetName = 'Create-SingleLevel')]
        [ValidateNotNullOrEmpty()]
        [string]$ApplicationGroupName,

        [parameter(Mandatory, ParameterSetName = 'SingleLevel')]
        [parameter(Mandatory, ParameterSetName = 'Create-SingleLevel')]
        [ValidateNotNullOrEmpty()]
        [string]$ApplicationResourceGroup,

        [parameter(Mandatory, ParameterSetName = 'HostpoolLevel')]
        [parameter(Mandatory, ParameterSetName = 'SingleLevel')]
        [parameter(Mandatory, ParameterSetName = 'Id')]
        [parameter(Mandatory, ParameterSetName = 'Create-Id')]
        [parameter(Mandatory, ParameterSetName = 'Create-Friendly')]
        [parameter(Mandatory, ParameterSetName = 'Create-SingleLevel')]
        [string]$LAWorkspace,

        [parameter(ParameterSetName = 'Create-Id')]
        [parameter(ParameterSetName = 'Create-Friendly')]
        [parameter(ParameterSetName = 'Create-SingleLevel')]
        [ValidateSet("CapacityReservation", "Free", "LACluster", "PerGB2018", "PerNode", "Premium", "Standalone", "Standard")]
        [string]$LASku = "Standard",

        [parameter(Mandatory, ParameterSetName = 'HostpoolLevel')]
        [parameter(Mandatory, ParameterSetName = 'SingleLevel')]
        [parameter(Mandatory, ParameterSetName = 'Id')]
        [parameter(Mandatory, ParameterSetName = 'Create-Id')]
        [parameter(Mandatory, ParameterSetName = 'Create-Friendly')]
        [parameter(Mandatory, ParameterSetName = 'Create-SingleLevel')]
        [string]$LaResourceGroupName,
        
        [parameter(Mandatory, ParameterSetName = 'Create-Id')]
        [parameter(Mandatory, ParameterSetName = 'Create-Friendly')]
        [parameter(Mandatory, ParameterSetName = 'Create-SingleLevel')]
        [string]$LaLocation,

        [parameter(Mandatory, ParameterSetName = 'Create-Id')]
        [parameter(Mandatory, ParameterSetName = 'Create-Friendly')]
        [parameter(Mandatory, ParameterSetName = 'Create-SingleLevel')]
        [int]$RetentionInDays,

        [parameter(Mandatory, ParameterSetName = 'HostpoolLevel')]
        [parameter(Mandatory, ParameterSetName = 'Id')]
        [parameter(Mandatory, ParameterSetName = 'Create-Id')]
        [parameter(Mandatory, ParameterSetName = 'Create-Friendly')]
        [parameter(Mandatory, ParameterSetName = 'Create-SingleLevel')]
        [string]$DiagnosticsName,

        [parameter(Mandatory, ParameterSetName = 'Create-Id')]
        [parameter(Mandatory, ParameterSetName = 'Create-Friendly')]
        [parameter(Mandatory, ParameterSetName = 'Create-SingleLevel')]
        [switch]$AutoCreate
    )
    Begin {
        Write-Verbose "[Enable-AvdInsightsApplicationGroup] - Start enabling AVD Insights for application group"
        AuthenticationCheck
        $token = GetAuthToken -resource $global:AzureApiUrl
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
                Write-Verbose "[Enable-AvdInsightsApplicationGroup] - Got the applicationgroup's resource ID. Thank you for that!"
            }
        }
        Write-Verbose "[Enable-AvdInsightsApplicationGroup] - Looking for workspace"
        $workspaceId = "/subscriptions/{0}/resourceGroups/{1}/providers/Microsoft.OperationalInsights/workspaces/{2}" -f $global:subscriptionId, $LaResourceGroupName, $LAWorkspace
        Write-Verbose $workspaceId
        $laws = (Get-Resource -ResourceId $workspaceId -Verbose).value

        if ($null -eq $laws) {
            try {
                if ($AutoCreate.IsPresent) {
                    Write-Warning "[Enable-AvdInsightsApplicationGroup] - No Log Analytics Workspace found! Creating a new workspace"
                    $laws = New-Workspace -Workspace $LAWorkspace -Sku $LASku -ResourceGroupName $LaResourceGroupName -Location $LaLocation
                }
                else {
                    Throw "[Enable-AvdInsightsApplicationGroup] - No workspace found! If it is a new workspace, add -AutoCreate in your command, $_"
                }
            }
            catch {
                Throw $_
            }
        }
        else {
            try {
                Write-Information "[Enable-AvdInsightsApplicationGroup] - Workspace found, configuring diagnostics" -InformationAction Continue
                $categoryArray = @()
                $mandatoryCategories = @("Checkpoint", "Error", "Management")
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
                    Write-Verbose "[Enable-AvdInsightsApplicationGroup] - Grabbing ID's form application groups"
                    $Id = $applicationGroup.id
                }
                $Id | ForEach-Object {  
                    $parameters = @{
                        uri     = "{0}{1}/providers/microsoft.insights/diagnosticSettings/{2}?api-version={3}" -f $global:AzureApiUrl, $_, $DiagnosticsName, $global:AvdDiagnosticsApiVersion
                        Method  = "PUT"
                        Headers = $token
                        Body    = $diagnosticsBody | ConvertTo-Json -Depth 4
                    }
                    Invoke-RestMethod @parameters
                    Write-Verbose "[Enable-AvdInsightsApplicationGroup] - Diagnostics enabled for $_, sending info to $LAWorkspace"
                }
            }
            catch {
                Throw "[Enable-AvdInsightsApplicationGroup] - $_"
            }
        }
    }
}