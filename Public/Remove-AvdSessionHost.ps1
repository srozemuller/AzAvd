function Remove-AvdSessionhost {
    <#
    .SYNOPSIS
    Removing sessionhosts from an Azure Virtual Desktop hostpool.
    .DESCRIPTION
    The function will search for sessionhosts and will remove them from the Azure Virtual Desktop hostpool.
    .PARAMETER HostpoolName
    Enter the WVD Hostpool name
    .PARAMETER ResourceGroupName
    Enter the WVD Hostpool resourcegroup name
    .PARAMETER SessionHostName
    Enter the sessionhosts name
    .EXAMPLE
    Remove-AvdSessionhost -HostpoolName avd-hostpool-personal -ResourceGroupName rg-avd-01 -SessionHostName avd-host-1.wvd.domain
    #>
    [CmdletBinding()]
    param
    (
        [parameter(Mandatory, ParameterSetName = 'Parameters')]
        [ValidateNotNullOrEmpty()]
        [string]$HostpoolName,
    
        [parameter(Mandatory, ParameterSetName = 'Parameters')]
        [ValidateNotNullOrEmpty()]
        [string]$ResourceGroupName,
    
        [parameter(Mandatory, ParameterSetName = 'Parameters')]
        [ValidateNotNullOrEmpty()]
        [string]$SessionHostName
    )
    Begin {
        Write-Verbose "Start searching"
        AuthenticationCheck
        $token = GetAuthToken -resource "https://management.azure.com"
        $apiVersion = "?api-version=2019-12-10-preview"
    }
    Process {
        switch ($PsCmdlet.ParameterSetName) {
            Parameters {
                $url = "https://management.azure.com/subscriptions/" + $script:subscriptionId + "/resourceGroups/" + $ResourceGroupName + "/providers/Microsoft.DesktopVirtualization/hostpools/" + $HostpoolName + "/sessionHosts/" + $SessionHostName + $apiVersion
                $parameters = @{
                    uri     = $url
                    Method  = "Delete"
                    Headers = $token
                }
            }
        }
        $results = Invoke-RestMethod @parameters
        return $results
    }
}