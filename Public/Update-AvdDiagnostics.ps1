function Update-AvdDiagnostics {
    <#
    .SYNOPSIS
    Updates the AVD Diagnostics settings to an another LogAnalytics workspace or categories. 
    .DESCRIPTION
    This command will help you updating the Log Analytics workspace or adding/removing log catagories.
    .PARAMETER HostPoolName
    Enter the name of the hostpool you want to enable start vm on connnect.
    .PARAMETER ResourceGroupName
    Enter the name of the resourcegroup where the hostpool resides in.
    .PARAMETER Workspace
    Enter the name(s) of the AVD workspaces
    .PARAMETER LAWorkspace
    Enter the name of the Log Analytics Workspace
    .EXAMPLE
    Update-AvdDiagnostics -HostPoolName avd-hostpool-001 -ResourceGroupName rg-avd-001 -AvdWorkspace avd-workpace-001 -DiagnosticsName 
    #>
    [CmdletBinding(DefaultParameterSetName = 'Category')]
    param (
        [parameter(Mandatory)]
        [parameter(ParameterSetName = 'Category')]
        [parameter(ParameterSetName = 'LAWS')]
        [ValidateNotNullOrEmpty()]
        [string]$HostpoolName,

        [parameter(Mandatory)]
        [parameter(ParameterSetName = 'Category')]
        [parameter(ParameterSetName = 'LAWS')]
        [string]$ResourceGroupName,

        [parameter(ParameterSetName = 'Category')]
        [string]$AvdWorkspace,

        [parameter(Mandatory, ParameterSetName = 'LAWS')]
        [string]$LAWorkspace,

        [parameter(Mandatory, ParameterSetName = 'LAWS')]
        [string]$LaResourceGroupName,

        [parameter(Mandatory)]
        [parameter(ParameterSetName = 'Category')]
        [parameter(ParameterSetName = 'LAWS')]
        [string]$DiagnosticsName,

        [parameter(ParameterSetName = 'LAWS')]
        [parameter(Mandatory, ParameterSetName = 'Category')]
        [ValidateSet("Checkpoint", "Error", "Management", "Connection", "HostRegistration")]
        [array]$Categories
        
    )
    Begin {
        AuthenticationCheck
        $token = GetAuthToken -resource "https://management.azure.com"
        $parameters = @{
            HostPoolName      = $HostpoolName 
            ResourceGroupName = $ResourceGroupName
        }
        $Hostpool = Get-AzWvdHostPool @parameters
    }
    Process {
        switch ($PsCmdlet.ParameterSetName) {
            LAWS {
                Write-Verbose "LAWS"
                try { 
                    $url = "https://management.azure.com/subscriptions/" + $script:subscriptionId + "/resourceGroups/" + $LaResourceGroupName + "/providers/Microsoft.OperationalInsights/workspaces/" + $LAWorkspace + "?api-version=2020-08-01"
                    $loganalyticsParameters = @{
                        URI     = $url 
                        Method  = "GET"
                        Headers = $token
                    }
                    $laws = Invoke-RestMethod @loganalyticsParameters
                    $categoryParameters = @{
                        uri     = "https://management.azure.com/$($Hostpool.Id)/providers/microsoft.insights/diagnosticSettings/$($diagnosticsName)?api-version=2017-05-01-preview"
                        Method  = "GET"
                        Headers = $token
                    }
                    if ($Categories) {
                        $CategoryBody = Create-CategoryArray -Categories $Categories
                    }
                    else {
                        $CategoryBody = (Invoke-RestMethod @categoryParameters).properties.logs
                    }
                }
                catch {
                    Write-Error "Log Analytics Workspace $LAWorkspace does not exist."
                }
            }
            Category {
                Write-Verbose "Category"
                $CategoryBody = Create-CategoryArray -Categories $Categories
            }
            Default {
                Write-Error "No Log Analytics Workspace provided"
            }
        }
        $diagnosticsBody = @{
            Properties = @{
                workspaceId = $Laws.id
                logs        = $CategoryBody
            }
        }    
        $parameters = @{
            uri     = "https://management.azure.com/$($Hostpool.Id)/providers/microsoft.insights/diagnosticSettings/$($diagnosticsName)?api-version=2017-05-01-preview"
            Method  = "PUT"
            Headers = $token
            Body    = $diagnosticsBody | ConvertTo-Json -Depth 4
        }
        Invoke-RestMethod @parameters
    }
}