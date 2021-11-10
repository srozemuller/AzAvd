function New-AvdScalingPlan {
    <#
    .SYNOPSIS
    Creates a new Azure Virtual Desktop Scaling plan.
    .DESCRIPTION
    The function will create a new Azure Virtual Desktop scaling plan and will assign it to (a) hostpool(s).
    .PARAMETER ScalingPlanName
    Enter the scaling plan name
    .PARAMETER ResourceGroupName
    Enter the resourcegroup name
    .PARAMETER Location
    Enter the location
    .PARAMETER Description
    If needed fill in the description
    .PARAMETER AssignToHostPool
    Enter the AVD Hostpool names and resource groups (eg. @{"Hostpool-1" = "RG-AVD-01"; "Hostpool-2" = "RG-AVD-02" } -ScheduleDays @("Monday", "WednesDay"))
    .PARAMETER friendlyName
    Change the scaling plan friendly name
    .PARAMETER TimeZone
    Timezone where the plan lives. (default is the timezone where the script is running.)
    .PARAMETER ScheduleName
    Enter the schedule name
    .PARAMETER ScheduleDays
    Enter the days when the schedule needs to work (eg. @("Monday", "WednesDay"))
    .PARAMETER rampUpStartTime
    Enter the start time of the autoscale process
    .PARAMETER rampUpLoadBalancingAlgorithm
    How do you like the loadbalancing (DepthFirst, BreadthFirst)
    .PARAMETER rampUpMinimumHostsPct
    How many 
    .PARAMETER rampUpCapacityThresholdPct
    
    .PARAMETER peakStartTime
    Enter the time of the maximum amount of hosts
    .PARAMETER peakLoadBalancingAlgorithm
    How do you like the loadbalancing (DepthFirst, BreadthFirst)
    .PARAMETER rampDownLoadBalancingAlgorithm
    How do you like the loadbalancing (DepthFirst, BreadthFirst)
    .PARAMETER rampDownStartTime
    What time needs the scaling plan shutdown hosts.
    .PARAMETER rampDownMinimumHostsPct
    Enter the percentage of hosts which needs to be online.
    .PARAMETER rampDownCapacityThresholdPct
    Enter the usage percentage when to start a new host.
    .PARAMETER rampDownForceLogoffUsers
    Force logoff users?
    .PARAMETER rampDownWaitTimeMinutes
    Number of minutes to wait to stop hosts during ramp down period.
    .PARAMETER rampDownNotificationMessage
    Provide the message to send to end users.
    .PARAMETER offPeakStartTime
    Whats the scaling plans end time?
    .PARAMETER offPeakLoadBalancingAlgorithm
    How do you like the loadbalancing (DepthFirst, BreadthFirst)
    .EXAMPLE
    New-AvdScalingPlan -ScalingPlanName sp-avd-weekdays -resourceGroupName rg-avd-01 -location WestEurope -AssignToHostpool @{"Hostpool-1" = "RG-AVD-01"; "Hostpool-2" = "RG-AVD-02"} -ScheduleDays @("Monday", "WednesDay")
    #>
    [CmdletBinding()]
    param
    (
        [parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$ScalingPlanName,
    
        [parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$ResourceGroupName,
    
        [parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$location,

        [parameter()]
        [ValidateNotNullOrEmpty()]
        [ValidateSet("Pooled")]
        [string]$HostpoolType = "Pooled",

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
        [string]$TimeZone = (Get-TimeZone).id,
        
        [parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$ScheduleName,

        [parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [array]$ScheduleDays,

        [parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$rampUpStartTime,

        [parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [ValidateSet("BreadthFirst", "DepthFirst")]
        [string]$rampUpLoadBalancingAlgorithm,

        [parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [int]$rampUpMinimumHostsPct,

        [parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [int]$rampUpCapacityThresholdPct,

        [parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$peakStartTime,

        [parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [ValidateSet("BreadthFirst", "DepthFirst")]
        [string]$peakLoadBalancingAlgorithm,
        
        [parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$rampDownStartTime,

        [parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [ValidateSet("BreadthFirst", "DepthFirst")]
        [string]$rampDownLoadBalancingAlgorithm,

        [parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [int]$rampDownMinimumHostsPct,

        [parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [int]$rampDownCapacityThresholdPct,

        [parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [boolean]$rampDownForceLogoffUsers,

        [parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [int]$rampDownWaitTimeMinutes,

        [parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [ValidateLength(1, 250)]
        [string]$rampDownNotificationMessage,

        [parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$offPeakStartTime,

        [parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [ValidateSet("BreadthFirst", "DepthFirst")]
        [string]$offPeakLoadBalancingAlgorithm
    )
    
    Begin {
        Write-Verbose "Start creating scaling plan $ScalingPlanName"
        AuthenticationCheck
        $token = GetAuthToken -resource $Script:AzureApiUrl
        $apiVersion = "?api-version=2021-01-14-preview"
        $url = $Script:AzureApiUrl + "/subscriptions/" + $script:subscriptionId + "/resourceGroups/" + $ResourceGroupName + "/providers/Microsoft.DesktopVirtualization/scalingPlans/" + $scalingPlanName + $apiVersion
        $body = @{
            location   = $Location
            properties = @{
                hostPoolType = $HostpoolType
                timezone     = $TimeZone
                schedules    = @(
                    @{
                        name                           = $ScheduleName
                        daysOfWeek                     = @(
                            $ScheduleDays
                        )
                        rampUpStartTime                = $rampUpStartTime
                        rampUpLoadBalancingAlgorithm   = $rampUpLoadBalancingAlgorithm
                        rampUpMinimumHostsPct          = $rampUpMinimumHostsPct
                        rampUpCapacityThresholdPct     = $rampUpCapacityThresholdPct
                        peakStartTime                  = $peakStartTime
                        peakLoadBalancingAlgorithm     = $peakLoadBalancingAlgorithm
                        rampDownStartTime              = $rampDownStartTime
                        rampDownLoadBalancingAlgorithm = $rampDownLoadBalancingAlgorithm
                        rampDownMinimumHostsPct        = $rampDownMinimumHostsPct
                        rampDownCapacityThresholdPct   = $rampDownCapacityThresholdPct
                        rampDownForceLogoffUsers       = $rampDownForceLogoffUsers
                        rampDownWaitTimeMinutes        = $rampDownWaitTimeMinutes
                        rampDownNotificationMessage    = $rampDownNotificationMessage
                        offPeakStartTime               = $offPeakStartTime
                        offPeakLoadBalancingAlgorithm  = $offPeakLoadBalancingAlgorithm
                    }
                )
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
            Headers = $token
        }
        $results = Invoke-RestMethod @parameters
        $results
    }
}
