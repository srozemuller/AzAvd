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
    Get-AvdDiagnosticSettings -HostPoolName avd-hostpool-001 -ResourceGroupName rg-avd-001
    .EXAMPLE
    Get-AvdDiagnosticSettings -HostPoolId "/subscriptions/...."
    #>
    [CmdletBinding(DefaultParameterSetName = 'Name')]
    param (
        [parameter(Mandatory, ParameterSetName = 'Name')]
        [ValidateNotNullOrEmpty()]
        [string]$HostpoolName,

        [parameter(Mandatory, ParameterSetName = 'Name')]
        [string]$ResourceGroupName,

        [parameter(Mandatory, ParameterSetName = 'Id', ValueFromPipelineByPropertyName)]
        [string]$Id
        
    )
    Begin {
        Write-Verbose "Start searching for host pool"
        AuthenticationCheck
        $token = GetAuthToken -resource $global:AzureApiUrl
        $parameters = @{
            HostPoolName      = $HostpoolName 
            ResourceGroupName = $ResourceGroupName
        }
    }
    Process {
        switch ($PsCmdlet.ParameterSetName) {
            Name {
                Write-Verbose "Got a hostpool's name, searching for the resource ID"
                $Id = (Get-AvdHostPool @parameters).id
                $uri =  "{0}/{1}/providers/microsoft.insights/diagnosticSettings/?api-version=2021-05-01-preview" -f $global:AzureApiUrl, $Id
            }
            Id {
                Write-Verbose "Thank you for making me ease and providing the ID"
                $uri =  "{0}/{1}/providers/microsoft.insights/diagnosticSettings/?api-version=2017-05-01-preview" -f $global:AzureApiUrl, $Id
            }
            Default {
                Write-Error "No hostpool name and resource group or id provided"
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