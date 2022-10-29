function Get-AvdDiagnosticSettings {
    <#
    .SYNOPSIS
    Gets the AVD Diagnostics settings to an another LogAnalytics workspace or categories. 
    .DESCRIPTION
    This command will help you updating the Log Analytics workspace or adding/removing log catagories.
    .PARAMETER HostPoolName
    Enter the name of the hostpool you want to enable start vm on connnect.
    .PARAMETER ResourceGroupName
    Enter the name of the resourcegroup where the hostpool resides in.
    .PARAMETER HostpoolId
    Enter the hostpool's resource ID
    .EXAMPLE
    Get-AvdDiagnostics -HostPoolName avd-hostpool-001 -ResourceGroupName rg-avd-001
    .EXAMPLE
    Get-AvdDiagnostics -HostPoolId "/subscriptions/...."
    #>
    [CmdletBinding(DefaultParameterSetName = 'Name')]
    param (
        [parameter(ParameterSetName = 'Name')]
        [ValidateNotNullOrEmpty()]
        [string]$HostpoolName,

        [parameter(ParameterSetName = 'Name')]
        [string]$ResourceGroupName,

        [parameter(ParameterSetName = 'Id')]
        [string]$HostpoolId
        
    )
    Begin {
        AuthenticationCheck
        $token = GetAuthToken -resource $Script:AzureApiUrl
        $parameters = @{
            HostPoolName      = $HostpoolName 
            ResourceGroupName = $ResourceGroupName
        }
    }
    Process {
        switch ($PsCmdlet.ParameterSetName) {
            Name {
                $HostpoolId = (Get-AvdHostPool @parameters).id
                $uri =  "{0}/{1}/providers/microsoft.insights/diagnosticSettings/?api-version=2017-05-01-preview" -f $Script:AzureApiUrl, $HostpoolId
            }
            Id {
                $uri =  "{0}/{1}/providers/microsoft.insights/diagnosticSettings/?api-version=2017-05-01-preview" -f $Script:AzureApiUrl, $HostpoolId
            }
            Default {
                Write-Error "No Log Analytics Workspace provided"
            }
        }
        $parameters = @{
            uri     = $uri
            Method  = "GET"
            Headers = $token
        }
        (Invoke-RestMethod @parameters).value
    }
}