function Update-AvdHostpool {
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
        [parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$HostpoolName,
    
        [parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$ResourceGroupName,
    
        [parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$customRdpProperty,

        [parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$friendlyName,

        [parameter()]
        [ValidateSet("BreadthFirst", "DepthFirst")]
        [ValidateNotNullOrEmpty()]
        [string]$loadBalancerType,
        
        [parameter()]
        [ValidateNotNullOrEmpty()]
        [boolean]$validationEnvironment,

        [parameter()]
        [ValidateNotNullOrEmpty()]
        [ValidateRange(1, 999999)]
        [int]$maxSessionLimit,

        [parameter(ParameterSetName = 'Change')]
        [switch]$Force
    )
    Begin {
        Write-Verbose "Start searching"
        AuthenticationCheck
        $token = GetAuthToken -resource "https://management.azure.com"
        $apiVersion = "?api-version=2019-12-10-preview"
        $url = "https://management.azure.com/subscriptions/" + $script:subscriptionId + "/resourceGroups/" + $ResourceGroupName + "/providers/Microsoft.DesktopVirtualization/hostpools/" + $HostpoolName + $apiVersion
        $parameters = @{
            uri     = $url
            Headers = $token
        }
        $body = @{
            properties = @{
            }
        }
        if ($customRdpProperty){
            $getResults = Invoke-RestMethod @parameters
            $currentCustomRdpProperty = $getResults.properties.customRdpProperty
        }    
        if ($friendlyName){$body.properties.Add("friendlyName", $friendlyName)}
        if ($description){$body.properties.Add("description", $description)}
        if ($loadBalancerType){$body.properties.Add("loadBalancerType", $loadBalancerType)}
        if ($validationEnvironment){$body.properties.Add("validationEnvironment", $validationEnvironment)}
        if ($maxSessionLimit){$body.properties.Add("maxSessionLimit", $maxSessionLimit)}
    }
    Process {
         switch ($PsCmdlet.ParameterSetName) {
            Change {
                Write-Verbose "Force used, overwriting custom RDP properties."
                Write-Verbose "Old properties where: $customRdpProperty"
            }
            default {
                If (!($customRdpProperty.EndsWith(";"))) {
                    $customRdpProperty = $customRdpProperty + ";"
                }
                $customRdpProperty = $currentCustomRdpProperty + $customRdpProperty
            }
        }
        $jsonBody = $body | ConvertTo-Json
        $parameters = @{
            uri     = $url
            Method  = "PATCH"
            Headers = $token
            Body    = $jsonBody
        }
        $results = Invoke-RestMethod @parameters
        return $results
    }
}