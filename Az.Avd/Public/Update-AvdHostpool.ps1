function Update-AvdHostpool {
    <#
    .SYNOPSIS
    Updates an Azure Virtual Desktop hostpool.
    .DESCRIPTION
    The function will update an Azure Virtual Desktop hostpool.
    .PARAMETER HostpoolName
    Enter the AVD Hostpool name
    .PARAMETER ResourceGroupName
    Enter the AVD Hostpool resourcegroup name
    .PARAMETER CustomRdpProperty
    If needed fill in the custom rdp properties (for example: targetisaadjoined:i:1 )
    .PARAMETER FriendlyName
    Change the host pool friendly name
    .PARAMETER LoadBalancerType
    Change the host pool LoadBalancerType   
    .PARAMETER ValidationEnvironment
    Change the host pool validation environment   
    .PARAMETER MaxSessionLimit
    Change the host pool max session limit (max 999999)
    .PARAMETER Force
    use the force parameter if you want to override the current customrdpproperties. Otherwise it will add the provided properties.
    .EXAMPLE
    Update-AvdHostpool -hostpoolname avd-hostpool -resourceGroupName rg-avd-01 -CustomRdpProperty "targetisaadjoined:i:1"
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
        [string]$CustomRdpProperty,

        [parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$FriendlyName,

        [parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$Description,

        [parameter()]
        [ValidateSet("BreadthFirst", "DepthFirst")]
        [ValidateNotNullOrEmpty()]
        [string]$LoadBalancerType,
        
        [parameter()]
        [ValidateNotNullOrEmpty()]
        [boolean]$ValidationEnvironment,

        [parameter()]
        [ValidateNotNullOrEmpty()]
        [ValidateRange(1, 999999)]
        [int]$MaxSessionLimit,

        [parameter(ParameterSetName = 'Change')]
        [switch]$Force
    )
    Begin {
        Write-Verbose "Start searching"
        AuthenticationCheck
        $token = GetAuthToken -resource $global:AzureApiUrl
        $url = "{0}/subscriptions/{1}/resourceGroups/{2}/providers/Microsoft.DesktopVirtualization/hostpools/{3}?api-version={4}" -f $global:AzureApiUrl, $global:subscriptionId, $ResourceGroupName, $HostpoolName, $global:hostpoolApiVersion 
        $parameters = @{
            uri     = $url
            Headers = $token
        }
        $body = @{
            properties = @{
            }
        }
        if ($CustomRdpProperty){
            $getResults = Invoke-RestMethod @parameters
            $currentCustomRdpProperty = $getResults.properties.CustomRdpProperty
        }    
        if ($FriendlyName){$body.properties.Add("FriendlyName", $FriendlyName)}
        if ($Description){$body.properties.Add("description", $Description)}
        if ($LoadBalancerType){$body.properties.Add("LoadBalancerType", $LoadBalancerType)}
        if ($ValidationEnvironment){$body.properties.Add("ValidationEnvironment", $ValidationEnvironment)}
        if ($MaxSessionLimit){$body.properties.Add("MaxSessionLimit", $MaxSessionLimit)}
    }
    Process {
         switch ($PsCmdlet.ParameterSetName) {
            Change {
                Write-Verbose "Force used, overwriting custom RDP properties."
                Write-Verbose "Old properties where: $CustomRdpProperty"
            }
            default {
                If (!($CustomRdpProperty.EndsWith(";"))) {
                    $CustomRdpProperty = $CustomRdpProperty + ";"
                }
                $CustomRdpProperty = $currentCustomRdpProperty + $CustomRdpProperty
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
        $results
    }
}