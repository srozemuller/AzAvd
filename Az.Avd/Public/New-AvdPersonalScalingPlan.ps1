function New-AvdPersonalScalingPlan {
    <#
    .SYNOPSIS
    Creates a new Azure Virtual Desktop Personal Scaling plan.
    .DESCRIPTION
    The function will create a new Azure Virtual Desktop scaling plan and will assign it to (a) hostpool(s).
    .PARAMETER Name
    Enter the scaling plan name
    .PARAMETER ResourceGroupName
    Enter the resourcegroup name
    .PARAMETER Location
    Enter the location
    .PARAMETER Description
    If needed fill in the description
    .PARAMETER AssignToHostPool
    Enter the AVD Hostpool names and resource groups (eg. @{"Hostpool-1" = "RG-AVD-01"; "Hostpool-2" = "RG-AVD-02" }
    .PARAMETER FriendlyName
    Change the scaling plan friendly name
    .PARAMETER TimeZone
    Timezone where the plan lives. (default is the timezone where the script is running.)
    .EXAMPLE
    New-AvdPersonalScalingPlan -Name 'ScalingPlan' -ResourceGroupName 'rg-avd-01' -Location 'WestEurope'
    .EXAMPLE
    New-AvdPersonalScalingPlan -Name 'ScalingPlan' -ResourceGroupName 'rg-avd-01' -Location 'WestEurope' -AssignToHostpool @{"Hostpool-1" = "RG-AVD-01"}
    #>
    [CmdletBinding()]
    param
    (
        [parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$Name,

        [parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$ResourceGroupName,

        [parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$Location,

        [parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$Description,

        [parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$FriendlyName,

        [parameter()]
        [ValidateNotNullOrEmpty()]
        [object]$AssignToHostPool,

        [parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$TimeZone = (Get-TimeZone).StandardName
    )

    Begin {
        Write-Verbose "Start creating scaling plan $Name"
        $url = "{0}/subscriptions/{1}/resourceGroups/{2}/providers/Microsoft.DesktopVirtualization/scalingPlans/{3}?api-version={4}" -f $global:AzureApiUrl, $global:subscriptionId, $ResourceGroupName, $Name, $global:scalingPlanApiVersion
        $body = @{
            location   = $Location
            properties = @{
                hostPoolType = "Personal"
                timezone     = $TimeZone
                schedules    = @()
            }
        }
        if ($Description) { $body.properties.Add("Description", $Description) }
        if ($ExclusionTag) { $body.properties.Add("ExclusionTag", $ExclusionTag) }
        if ($FriendlyName) { $body.properties.Add("FriendlyName", $FriendlyName) }

    }
    Process {
        if ($AssignToHostPool) {
            $hostPoolReferences = New-Object System.Collections.ArrayList
            $AssignToHostPool.GetEnumerator() | ForEach-Object {
                $hostpool = Get-AvdHostPool -HostPoolName $_.Key -ResourceGroupName $_.Value
                $hostPoolReferences.add(@{
                        hostPoolArmPath    = $hostpool.id
                        scalingPlanEnabled = $true
                    })
            }
            $body.properties.Add("hostPoolReferences", $hostPoolReferences)
        }
        $jsonBody = $body | ConvertTo-Json -Depth 6
        $parameters = @{
            URI     = $url
            Method  = "PUT"
            Body    = $jsonBody
        }
        $results = Request-Api @parameters
        $results
    }
}
