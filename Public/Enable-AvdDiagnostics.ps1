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
    .PARAMETER LASku
    Enter the name of the Log Analytics SKU
    .PARAMETER LAWorkspace
    Enter the name of the Log Analytics Workspace
    .PARAMETER LaResourceGroupName
    Enter the name of the Log Analyics Workspace resource group
    .PARAMETER diagnosticsName
    The diagnostics name shown in the hostpool diagnostics overview
    .PARAMETER categories
    The categories you like to save in Log Analytics
    .PARAMETER RetentionInDays
    How long should the data be saved
    .EXAMPLE
    Enable-AvdDiagnostics -HostPoolName avd-hostpool-001 -ResourceGroupName rg-avd-001 -LAWorkspace 'la-avd-workspace' -Categories ("Checkpoint","Error")
    #>
    [CmdletBinding(DefaultParameterSetName = 'Existing')]
    param (
        [parameter(Mandatory)]
        [parameter(ParameterSetName = 'Initial')]
        [parameter(ParameterSetName = 'Existing')]
        [ValidateNotNullOrEmpty()]
        [string]$HostpoolName,

        [parameter(Mandatory)]
        [parameter(ParameterSetName = 'Initial')]
        [parameter(ParameterSetName = 'Existing')]
        [ValidateNotNullOrEmpty()]
        [string]$ResourceGroupName,

        [parameter(ParameterSetName = 'Initial')]
        [parameter(ParameterSetName = 'Existing')]
        [string]$LAWorkspace,

        [parameter(ParameterSetName = 'Initial')]
        [ValidateSet("CapacityReservation", "Free", "LACluster", "PerGB2018", "PerNode", "Premium","Standalone","Standard")]
        [string]$LASku = "Standard",

        [parameter(ParameterSetName = 'Initial')]
        [parameter(ParameterSetName = 'Existing')]
        [string]$LaResourceGroupName,
        
        [parameter(ParameterSetName = 'Initial')]
        [string]$diagnosticsName = "AVD-Diagnostics",

        [parameter(Mandatory)]
        [parameter(ParameterSetName = 'Initial')]
        [parameter(ParameterSetName = 'Existing')]
        [ValidateSet("Checkpoint", "Error", "Management", "Connection", "HostRegistration", "AgentHealthStatus")]
        [array]$Categories,

        [parameter(ParameterSetName = 'Initial')]
        [int]$RetentionInDays
        
    )
    Begin {
       AuthenticationCheck
       $token = GetAuthToken -resource "https://management.azure.com"
    }
    Process {
        switch ($PsCmdlet.ParameterSetName) {
            Initial {
                if ($null -eq $LAWorkspace) {
                    $LAWorkspace = "log-analytics-avd-" + (Get-Random -Maximum 99999)
                    Write-Verbose "No Log Analytics Workspace provided, creating a new one."
                    Write-Verbose "Workspace name: $LAWorkspace"    
                } 
                $Body = @{
                    location   = $LaLocation
                    properties = @{
                        retentionInDays = $RetentionInDays
                        sku             = @{
                            name = $LASku
                        }
                    }
                }
                $url = "https://management.azure.com/subscriptions/" + $script:subscriptionId + "/resourceGroups/" + $LaResourceGroupName + "/providers/Microsoft.OperationalInsights/workspaces/" + $LAWorkspace + "?api-version=2020-08-01"
                $loganalyticsParameters = @{
                    URI     = $url 
                    Method  = "PUT"
                    Body    = $Body | ConvertTo-Json
                    Headers = $token
                }
                $laws = Invoke-RestMethod @loganalyticsParameters
            }
            Existing {
                $url = "https://management.azure.com/subscriptions/" + $script:subscriptionId + "/resourceGroups/" + $LaResourceGroupName + "/providers/Microsoft.OperationalInsights/workspaces/" + $LAWorkspace + "?api-version=2020-08-01"
                $loganalyticsParameters = @{
                    URI     = $url 
                    Method  = "GET"
                    Headers = $token
                }
                $laws = Invoke-RestMethod @loganalyticsParameters
            }
        }
        $parameters = @{
            HostPoolName      = $HostpoolName 
            ResourceGroupName = $ResourceGroupName
        }
        $Hostpool = Get-AzWvdHostPool @parameters
        $categoryArray = @()
        $Categories | foreach {
            $category = @{
                Category = $_
                Enabled  = $true
            }
            $categoryArray += ($category)
        }
        $diagnosticsBody = @{
            Properties = @{
                workspaceId = $Laws.id
                logs        = $categoryArray
            }
        }    
        $parameters = @{
            uri     = "https://management.azure.com/$($Hostpool.Id)/providers/microsoft.insights/diagnosticSettings/$($diagnosticsName)?api-version=2017-05-01-preview"
            Method  = "PUT"
            Headers = $token
            Body    = $diagnosticsBody | ConvertTo-Json -Depth 4
        }
        $results = Invoke-RestMethod @parameters
        return $results
        Write-Verbose "Diagnostics enabled for $HostpoolName, sending info to $LAWorkspace"
    }
}