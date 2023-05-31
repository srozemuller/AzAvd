function Enable-AvdInsightsCounters {
    <#
    .SYNOPSIS
    Create sources in a (new) LogAnalytics workspace
    .DESCRIPTION
    The function creates the needed sources in a Log Analytics workspace for AVD Insights.
    .PARAMETER Id
    Enter the Log Analytics Workspace's resource ID.
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
    Enable-AvdInsightsCounters -Id /subscription/../workspaces/la-workspace 
    .EXAMPLE
    Enable-AvdInsightsCounters -LAWorkspace 'la-avd-workspace' -LaResourceGroupName 'rg-la-01'
    .EXAMPLE
    Enable-AvdInsightsCounters -LAWorkspace 'la-avd-workspace' -LaResourceGroupName 'rg-la-01' -LaSku 'standard' -LaLocation 'WestEurope' -RetentionInDays 30 -Autocreate
    #>
    [CmdletBinding(DefaultParameterSetName = 'Id')]
    param (
        [parameter(Mandatory, ParameterSetName = 'Id', ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [string]$Id,

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
        Write-Verbose "[Enable-AvdInsightsCounters] - Start enabling counters for AVD Insights "
        AuthenticationCheck
        $token = GetAuthToken -resource $global:AzureApiUrl
    }
    Process {
        switch ($PsCmdlet.ParameterSetName) {
            WorkspaceName {
                $Id = "/subscriptions/{0}/resourceGroups/{1}/providers/Microsoft.OperationalInsights/workspaces/{2}" -f $global:subscriptionId, $LaResourceGroupName, $LAWorkspace
            }
            default {
                Write-Verbose "[Enable-AvdInsightsCounters] - Got a Log Analytics workspace's resource ID. Thank you for that!"
            }
        }
        Write-Verbose "[Enable-AvdInsightsCounters] - Looking for workspace"
        Write-Verbose $Id
        $laws = (Get-Resource -ResourceId $Id -Verbose).value

        if ($null -eq $laws) {
            try {
                if ($AutoCreate.IsPresent) {
                    Write-Warning "No Log Analytics Workspace found! Creating a new workspace"
                    $laws = New-Workspace -Workspace $LAWorkspace -Sku $LASku -ResourceGroupName $LaResourceGroupName -Location $LaLocation
                }
                else {
                    Throw "[Enable-AvdInsightsCounters] - No workspace found! If it is a new workspace, add -AutoCreate in your command, $_"
                }
            }
            catch {
                Throw $_
            }
        }
        else {
            try {
                Write-Information "[Enable-AvdInsightsCounters] - Workspace found, configuring diagnostics" -InformationAction Continue
                $sources = Get-Content $global:AvdInsightsCountersLocation | ConvertFrom-Json
                $sources.sources.GetEnumerator().ForEach({
                        Write-Verbose "Found $($_.kind) to configure"
                        $sourceKind = $_
                        $sourceKind.sources.ForEach({
                            Write-Verbose "[Enable-AvdInsightsCounters] - Adding $($_.name) as a source to $($laws.name)"
                            $properties = $_
                                if ($_.properties) {
                                    $properties = $_.properties
                                }
                                $source = @{
                                    type       = "Microsoft.OperationalInsights/workspaces/datasources"
                                    kind       = $sourceKind.kind
                                    properties = $properties
                                }
                                $parameters = @{
                                    uri     = "{0}{1}/dataSources/{2}?api-version=2020-08-01" -f $global:AzureApiUrl, $laws.id, $_.name
                                    Method  = "PUT"
                                    Headers = $token
                                    Body    = $source | ConvertTo-Json -Depth 99 
                                }
                                Invoke-RestMethod @parameters
                                Write-Verbose "[Enable-AvdInsightsCounters] - Diagnostics enabled for $_, sending info to $LAWorkspace"
                            })
                    }) 
            }
            catch {
                Throw "[Enable-AvdInsightsCounters] - $_"
            }
        }
    }
}