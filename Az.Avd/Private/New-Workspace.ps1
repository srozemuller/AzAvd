function New-Workspace {
    [CmdletBinding()]
    param (
        [parameter(Mandatory)]
        [string]$Workspace,

        [parameter()]
        [ValidateSet("CapacityReservation", "Free", "LACluster", "PerGB2018", "PerNode", "Premium", "Standalone", "Standard")]
        [string]$Sku = "Standard",

        [parameter()]
        [string]$ResourceGroupName,

        [parameter()]
        [string]$Location,

        [parameter()]
        [int]$RetentionInDays
    )
    try {
        if ($null -eq $LAWorkspace) {
            $LAWorkspace = "log-analytics-avd-" + (Get-Random -Maximum 99999)
            Write-Verbose "No Log Analytics Workspace provided, creating a new one."
            Write-Verbose "Workspace name: $LAWorkspace"
        }
        $body = @{
            location   = $Location
            properties = @{
                retentionInDays = $RetentionInDays
                sku             = @{
                    name = $Sku
                }
            }
        }
        $url = "{0}/subscriptions/{1}/resourceGroups/{2}/providers/Microsoft.OperationalInsights/workspaces/{3}?api-version={4}" -f $global:AzureApiUrl, $global:subscriptionId, $ResourceGroupName, $Workspace, $global:diagnosticsApiVersion
        $loganalyticsParameters = @{
            URI     = $url
            Method  = "PUT"
            Body    = $body | ConvertTo-Json
            Headers = $token
        }
        Invoke-RestMethod @loganalyticsParameters
    }
    catch {
        Throw $_

    }
}