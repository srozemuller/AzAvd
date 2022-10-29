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
    
        [parameter(ParameterSetName = 'AADAuth')]
        [boolean]$AadAuthentication
    )
    Begin {
        Write-Verbose "Start searching"
        AuthenticationCheck
        $token = GetAuthToken -resource $Script:AzureApiUrl
        $url = "{0}/subscriptions/{1}/resourceGroups/{2}/providers/Microsoft.DesktopVirtualization/hostpools/{3}?api-version={4}" -f $Script:AzureApiUrl, $script:subscriptionId, $ResourceGroupName, $HostpoolName, $script:hostpoolApiVersion 
        $parameters = @{
            uri     = $url
            Headers = $token
        }
        $body = @{
            properties = @{
            }
        }

        $getResults = Invoke-RestMethod @parameters
        $currentCustomRdpProperty = $getResults.properties.CustomRdpProperty  
    }
    Process {
        switch ($PsCmdlet.ParameterSetName) {
            AADAuth {
                Write-Verbose "Force used, overwriting custom RDP properties."
                Write-Verbose "Old properties where: $CustomRdpProperty"
                if (($currentCustomRdpProperty.Contains('enablerdsaadauth')) -and $AadAuthentication){
                    $currentCustomRdpProperty = $currentCustomRdpProperty.Replace("enablerdsaadauth:i:0","enablerdsaadauth:i:1")
                }
                else {
                    $currentCustomRdpProperty = $currentCustomRdpProperty.Replace("enablerdsaadauth:i:1","enablerdsaadauth:i:0")
                }                
            }
            default {
                If (!($CustomRdpProperty.EndsWith(";"))) {
                    $CustomRdpProperty = $CustomRdpProperty + ";"
                }
                $CustomRdpProperty = $currentCustomRdpProperty + $CustomRdpProperty
            }
        }
        $body.properties.Add("CustomRdpProperty", $currentCustomRdpProperty)
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