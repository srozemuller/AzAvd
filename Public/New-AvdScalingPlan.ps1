function New-AvdScalingPlan {
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
    New-AvdHostpool -hostpoolname avd-hostpool -resourceGroupName rg-avd-01 -location WestEurope -hostPoolType "Personal"
    .EXAMPLE
    New-AvdHostpool -hostpoolname avd-hostpool -resourceGroupName rg-avd-01 -location WestEurope -customRdpProperty "targetisaadjoined:i:1"
    .EXAMPLE
    New-AvdHostpool -hostpoolname avd-hostpool -resourceGroupName rg-avd-01 -location WestEurope -vmTemplate "{"domain":"","osDiskType":"Premium_LRS","namePrefix":"avd","vmSize":{"cores":"2","ram":"8","id":"Standard_B2MS"},"galleryImageOffer":"","galleryImagePublisher":"","galleryImageSKU":"","imageType":"","imageUri":"","customImageId":"","useManagedDisks":"True","galleryItemId":null}"
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
        [ValidateNotNullOrEmpty()]
        [string]$description,

        [parameter()]
        [ValidateSet("BreadthFirst", "DepthFirst", "Persistent")]
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
        [string]$preferredAppGroupType,

        [parameter()]
        [ValidateNotNullOrEmpty()]
        [ValidateSet("Automatic", "Direct")]
        [string]$PersonalDesktopAssignmentType = "Automatic",

        [parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$vmTemplate,

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
        $token = GetAuthToken -resource $Script:AzureApiUrl
        $apiVersion = "?api-version=2021-01-14-preview"
        $scalingPlanName = "Avd-ScalingPlan3"
        $url = $Script:AzureApiUrl + "/subscriptions/" + $script:subscriptionId + "/resourceGroups/" + $ResourceGroupName + "/providers/Microsoft.DesktopVirtualization/scalingPlans/" + $scalingPlanName + $apiVersion
        $body = @{
            location   = 'westeurope'
            properties = @{
                description        = "des1"
                friendlyName       = "friendly"
                hostPoolType       = "Pooled"
                timezone           = "W. Europe Standard Time"
                hostPoolReferences = @(
                    @{
                        hostPoolArmPath    = $hostpool.id
                        scalingPlanEnabled = $true
                    }
                )
            }
        }
    }
    Process {
        $jsonBody = $body | ConvertTo-Json -Depth 4
        $parameters = @{
            URI     = $url
            Method  = "PUT"
            Body    = $jsonBody
            Headers = $token
        }
        $results = Invoke-RestMethod @parameters
        return $results
    }
}
