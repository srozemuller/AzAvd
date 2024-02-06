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
    Update-AvdDiagnostics -HostPoolName avd-hostpool-001 -ResourceGroupName rg-avd-001 -LaWorkspace avd-workpace-001 -DiagnosticsName
    #>
    [CmdletBinding(DefaultParameterSetName = 'Category')]
    param (

        [parameter(Mandatory, ParameterSetName = 'Category')]
        [parameter(Mandatory, ParameterSetName = 'LAWS')]
        [ValidateNotNullOrEmpty()]
        [string]$HostpoolName,

        [parameter(Mandatory, ParameterSetName = 'Category')]
        [parameter(Mandatory, ParameterSetName = 'LAWS')]
        [string]$ResourceGroupName,

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
        [ValidateSet("Checkpoint", "Error", "Management", "Connection", "HostRegistration","AgentHealthStatus","NetworkData","SessionHostManagement","ConnectionGraphicsData")]
        [array]$Categories

    )
    Begin {
        AuthenticationCheck
        $token = GetAuthToken -resource $global:AzureApiUrl
        $parameters = @{
            HostPoolName      = $HostpoolName 
            ResourceGroupName = $ResourceGroupName
        }
        $hostpool = Get-AvdHostPool @parameters
    }
    Process {
        switch ($PsCmdlet.ParameterSetName) {
            LAWS {
                Write-Verbose "LAWS"
                try {
                    $url = "{0}/subscriptions/{1}/resourceGroups/{2}/providers/Microsoft.OperationalInsights/workspaces/{3}?api-version=2020-08-01" -f $global:AzureApiUrl, $global:subscriptionId, $LaResourceGroupName, $LAWorkspace
                    $loganalyticsParameters = @{
                        URI     = $url 
                        Method  = "GET"
                        Headers = $token
                    }
                    $laws = Invoke-RestMethod @loganalyticsParameters
                    $categoryParameters = @{
                        uri     = "{0}{1}/providers/microsoft.insights/diagnosticSettings/{2}?api-version=2021-05-01-preview" -f $global:AzureApiUrl , $hostpool.Id, $diagnosticsName
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
                logs        = @($CategoryBody)
            }
        }
        $parameters = @{
            uri     = "{0}/{1}/providers/microsoft.insights/diagnosticSettings/{2}?api-version=2021-05-01-preview" -f $global:AzureApiUrl, $hostpool.Id, $diagnosticsName
            Method  = "PUT"
            Headers = $token
            Body    = $diagnosticsBody | ConvertTo-Json -Depth 4
        }
        Invoke-RestMethod @parameters
    }
}