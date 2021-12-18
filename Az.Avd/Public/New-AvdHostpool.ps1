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
    .PARAMETER CustomRdpProperty
    If needed fill in the custom rdp properties (for example: targetisaadjoined:i:1 )
    .PARAMETER FriendlyName
    Change the host pool friendly name
    .PARAMETER LoadBalancerType
    Change the host pool loadBalancerType   
    .PARAMETER ValidationEnvironment
    Change the host pool validation environment   
    .PARAMETER MaxSessionLimit
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
        [string]$Location,

        [parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [ValidateSet("Pooled", "Personal")]
        [string]$HostPoolType,

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
        [ValidateSet("BreadthFirst", "DepthFirst","Persistent")]
        [ValidateNotNullOrEmpty()]
        [string]$LoadBalancerType,
        
        [parameter()]
        [ValidateNotNullOrEmpty()]
        [boolean]$ValidationEnvironment,

        [parameter()]
        [ValidateNotNullOrEmpty()]
        [boolean]$StartVMOnConnect,
         
        [parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$PreferredAppGroupType,

        [parameter()]
        [ValidateNotNullOrEmpty()]
        [ValidateSet("Automatic", "Direct")]
        [string]$PersonalDesktopAssignmentType = "Automatic",

        [parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$VmTemplate,

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
        $token = GetAuthToken -resource $Script:AzureApiUrl
        $apiVersion = "?api-version=2019-12-10-preview"
        $url = $Script:AzureApiUrl+"/subscriptions/" + $script:subscriptionId + "/resourceGroups/" + $ResourceGroupName + "/providers/Microsoft.DesktopVirtualization/hostpools/" + $HostpoolName + $apiVersion
        $parameters = @{
            uri     = $url
            Headers = $token
        }
        $body = @{
            location = $Location
            properties = @{
                hostPoolType = $HostPoolType
            }
        }
        if ($CustomRdpProperty){$body.properties.Add("customRdpProperty", $CustomRdpProperty)}
        if ($FriendlyName){$body.properties.Add("friendlyName", $FriendlyName)}
        if ($Description){$body.properties.Add("description", $Description)}
        if ($LoadBalancerType){$body.properties.Add("loadBalancerType", $LoadBalancerType)}
        if ($ValidationEnvironment){$body.properties.Add("validationEnvironment", $ValidationEnvironment)}
        if ($PreferredAppGroupType){$body.properties.Add("preferredAppGroupType", $PreferredAppGroupType)}
        if ($StartVMOnConnect){$body.properties.Add("startVMOnConnect", $StartVMOnConnect)}
        if ($PersonalDesktopAssignmentType){$body.properties.Add("PersonalDesktopAssignmentType", $PersonalDesktopAssignmentType)}
        if ($MaxSessionLimit){$body.properties.Add("maxSessionLimit", $MaxSessionLimit)}
        if ($VmTemplate){$body.properties.Add("vmTemplate", $VmTemplate)}
    }
    Process {
        $jsonBody = $body | ConvertTo-Json
        $parameters = @{
            uri     = $url
            Method  = "PUT"
            Headers = $token
            Body    = $jsonBody
        }
        $results = Invoke-RestMethod @parameters
        $results
    }
}