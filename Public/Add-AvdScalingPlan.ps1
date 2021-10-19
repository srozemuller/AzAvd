$script:token = GetAuthToken -resource 'https://management.azure.com' 
$scalingPlanName = "Avd-ScalingPlan2"
$url = "https://management.azure.com/subscriptions/398c5aee-6356-47fa-b141-2251e85cdb97/resourceGroups/RG-ROZ-AVD-01/providers/Microsoft.DesktopVirtualization/scalingPlans/" + $scalingPlanName + "?api-version=2021-01-14-preview"

Invoke-RestMethod -Method get -Uri $url -Headers $script:token
$Body = @{
    location   = 'westeurope'
    properties = @{
        description  = "des1"
        friendlyName = "friendly"
        hostPoolType = "pooled"
        timezone = "W. Europe Standard Time"
    }
}
$parameters = @{
    URI     = $url
    Method  = "PATCH"
    Body    = $Body | ConvertTo-Json
    Headers = $token
}
$laws = Invoke-RestMethod @parameters

