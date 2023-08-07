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
    .PARAMETER FriendlyName
    Change the scaling plan friendly name
    .PARAMETER TimeZone
    Timezone where the plan lives. (default is the timezone where the script is running.)
    .PARAMETER ScheduleName
    Enter the schedule name
    .PARAMETER ScheduleDays
    Enter the days when the schedule needs to work (eg. @("Monday", "WednesDay"))
    .PARAMETER RampUpStartTime
    Enter the start time of the autoscale process
    .PARAMETER RampUpLoadBalancingAlgorithm
    How do you like the loadbalancing (DepthFirst, BreadthFirst)
    .PARAMETER RampUpMinimumHostsPct
    How many 
    .PARAMETER RampUpCapacityThresholdPct
    
    .PARAMETER PeakStartTime
    Enter the time of the maximum amount of hosts
    .PARAMETER PeakLoadBalancingAlgorithm
    How do you like the loadbalancing (DepthFirst, BreadthFirst)
    .PARAMETER RampDownLoadBalancingAlgorithm
    How do you like the loadbalancing (DepthFirst, BreadthFirst)
    .PARAMETER RampDownStartTime
    What time needs the scaling plan shutdown hosts.
    .PARAMETER RampDownMinimumHostsPct
    Enter the percentage of hosts which needs to be online.
    .PARAMETER RampDownCapacityThresholdPct
    Enter the usage percentage when to start a new host.
    .PARAMETER RampDownForceLogoffUsers
    Force logoff users?
    .PARAMETER RampDownWaitTimeMinutes
    Number of minutes to wait to stop hosts during ramp down period.
    .PARAMETER RampDownNotificationMessage
    Provide the message to send to end users.
    .PARAMETER OffPeakStartTime
    Whats the scaling plans end time?
    .PARAMETER OffPeakLoadBalancingAlgorithm
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
        [string]$Location,

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
        [string]$RampUpStartTime,

        [parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [ValidateSet("BreadthFirst", "DepthFirst")]
        [string]$RampUpLoadBalancingAlgorithm,

        [parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [int]$RampUpMinimumHostsPct,

        [parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [int]$RampUpCapacityThresholdPct,

        [parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$PeakStartTime,

        [parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [ValidateSet("BreadthFirst", "DepthFirst")]
        [string]$PeakLoadBalancingAlgorithm,
        
        [parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$RampDownStartTime,

        [parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [ValidateSet("BreadthFirst", "DepthFirst")]
        [string]$RampDownLoadBalancingAlgorithm,

        [parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [int]$RampDownMinimumHostsPct,

        [parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [int]$RampDownCapacityThresholdPct,

        [parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [boolean]$RampDownForceLogoffUsers,

        [parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [int]$RampDownWaitTimeMinutes,

        [parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [ValidateLength(1, 250)]
        [string]$RampDownNotificationMessage,

        [parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$OffPeakStartTime,

        [parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [ValidateSet("BreadthFirst", "DepthFirst")]
        [string]$OffPeakLoadBalancingAlgorithm
    )

    Begin {
        Write-Verbose "Start creating scaling plan $ScalingPlanName"
        AuthenticationCheck
        $token = GetAuthToken -resource $global:AzureApiUrl
        $apiVersion = "?api-version=2021-01-14-preview"
        $url =  $global:AzureApiUrl + "/subscriptions/" + $global:subscriptionId + "/resourceGroups/" + $ResourceGroupName + "/providers/Microsoft.DesktopVirtualization/scalingPlans/" + $scalingPlanName + $apiVersion
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
                        rampUpStartTime                = $RampUpStartTime
                        rampUpLoadBalancingAlgorithm   = $RampUpLoadBalancingAlgorithm
                        rampUpMinimumHostsPct          = $RampUpMinimumHostsPct
                        rampUpCapacityThresholdPct     = $RampUpCapacityThresholdPct
                        peakStartTime                  = $PeakStartTime
                        peakLoadBalancingAlgorithm     = $PeakLoadBalancingAlgorithm
                        rampDownStartTime              = $RampDownStartTime
                        rampDownLoadBalancingAlgorithm = $RampDownLoadBalancingAlgorithm
                        rampDownMinimumHostsPct        = $RampDownMinimumHostsPct
                        rampDownCapacityThresholdPct   = $RampDownCapacityThresholdPct
                        rampDownForceLogoffUsers       = $RampDownForceLogoffUsers
                        rampDownWaitTimeMinutes        = $RampDownWaitTimeMinutes
                        rampDownNotificationMessage    = $RampDownNotificationMessage
                        offPeakStartTime               = $OffPeakStartTime
                        offPeakLoadBalancingAlgorithm  = $OffPeakLoadBalancingAlgorithm
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
