function New-AvdHostpool {
    <#
    .SYNOPSIS
    Creates a new Azure Virtual Desktop hostpool.
    .DESCRIPTION
    The function will create a new Azure Virtual Desktop hostpool.
    .PARAMETER HostpoolName
    Enter the AVD Hostpool name
    .PARAMETER ResourceGroupName
    Enter the AVD Hostpool resourcegroup name
    .PARAMETER customRdpProperty
    If needed fill in the custom rdp properties (for example: targetisaadjoined:i:1 )
    .PARAMETER friendlyName
    Change the host pool friendly name
    .PARAMETER loadBalancerType
    Change the host pool loadBalancerType   
    .PARAMETER validationEnvironment
    Change the host pool validation environment   
    .PARAMETER maxSessionLimit
    Change the host pool max session limit (max 999999)
    .PARAMETER Force
    use the force parameter if you want to override the current customrdpproperties. Otherwise it will add the provided properties.
    .EXAMPLE
    New-AvdHostpool -hostpoolname avd-hostpool -resourceGroupName rg-avd-01 -customRdpProperty "targetisaadjoined:i:1"
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
    
        [parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$location,

        [parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [ValidateSet("Pooled", "Personal")]
        [string]$hostPoolType,

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
        [boolean]$startVMOnConnect,

        
        [parameter()]
        [ValidateNotNullOrEmpty()]
        [ValidateSet("Automatic", "Direct")]
        [string]$PersonalDesktopAssignmentType = "Automatic",

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
            location = $location
            properties = @{
                hostPoolType = $hostPoolType
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
        if ($startVMOnConnect){$body.properties.Add("startVMOnConnect", $startVMOnConnect)}
        if ($PersonalDesktopAssignmentType){$body.properties.Add("PersonalDesktopAssignmentType", $PersonalDesktopAssignmentType)}
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
            Method  = "PUT"
            Headers = $token
            Body    = $jsonBody
        }
        $results = Invoke-RestMethod @parameters
        return $results
    }
}