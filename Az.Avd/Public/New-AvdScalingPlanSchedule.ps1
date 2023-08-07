function New-AvdScalingPlanSchedule {
    <#
    .SYNOPSIS
        Modifies the scaling plan for a specified resource group.
    .DESCRIPTION
        The Set-ScalingPlan cmdlet modifies the scaling plan for a specified resource group. It allows you to configure different scaling settings for either pooled or personal desktops, depending on the ParameterSetName.
    .PARAMETER ScalingPlanName
        Specifies the name of the scaling plan to modify.
    .PARAMETER ResourceGroupName
        Specifies the name of the resource group where the scaling plan is located.
    .PARAMETER ScheduleName
        Specifies the name of the schedule to update.
    .PARAMETER DaysOfWeek
        Specifies an array of days of the week for the schedule.
    .PARAMETER RampUpStartTime
        Specifies the start time for the ramp-up period.
    .PARAMETER RampUpLoadBalancingAlgorithm
        Specifies the load balancing algorithm during the ramp-up period. Valid options are "BreadthFirst" and "DepthFirst". (Applicable only for the "Pooled" ParameterSetName)
    .PARAMETER RampUpMinimumHostsPct
        Specifies the minimum percentage of hosts during the ramp-up period. (Applicable only for the "Pooled" ParameterSetName)
    .PARAMETER RampUpCapacityThresholdPct
        Specifies the capacity threshold percentage during the ramp-up period. (Applicable only for the "Pooled" ParameterSetName)
    .PARAMETER PeakStartTime
        Specifies the start time for the peak period.
    .PARAMETER PeakLoadBalancingAlgorithm
        Specifies the load balancing algorithm during the peak period. Valid options are "BreadthFirst" and "DepthFirst". (Applicable only for the "Pooled" ParameterSetName)
    .PARAMETER RampDownStartTime
        Specifies the start time for the ramp-down period.
    .PARAMETER RampDownLoadBalancingAlgorithm
        Specifies the load balancing algorithm during the ramp-down period. Valid options are "BreadthFirst" and "DepthFirst". (Applicable only for the "Pooled" ParameterSetName)
    .PARAMETER RampDownMinimumHostsPct
        Specifies the minimum percentage of hosts during the ramp-down period. (Applicable only for the "Pooled" ParameterSetName)
    .PARAMETER RampDownCapacityThresholdPct
        Specifies the capacity threshold percentage during the ramp-down period. (Applicable only for the "Pooled" ParameterSetName)
    .PARAMETER RampDownForceLogoffUsers
        Indicates whether to force logoff users during the ramp-down period. (Applicable only for the "Pooled" ParameterSetName)
    .PARAMETER RampDownWaitTimeMinutes
        Specifies the wait time in minutes during the ramp-down period. (Applicable only for the "Pooled" ParameterSetName)
    .PARAMETER RampDownNotificationMessage
        Specifies the notification message during the ramp-down period. (Applicable only for the "Pooled" ParameterSetName)
    .PARAMETER OffPeakStartTime
        Specifies the start time for the off-peak period.
    .PARAMETER OffPeakLoadBalancingAlgorithm
        Specifies the load balancing algorithm during the off-peak period. Valid options are "BreadthFirst" and "DepthFirst". (Applicable only for the "Pooled" ParameterSetName)
    .PARAMETER RampUpStartVMOnConnect
        Specifies whether to start VMs on connect during the ramp-up period. Valid options are "Enable" and "Disable". (Applicable only for the "Personal" ParameterSetName)
    .PARAMETER PeakStartVMOnConnect
        Specifies whether to start VMs on connect during the peak period. Valid options are "Enable" and "Disable". (Applicable only for the "Personal" ParameterSetName)
    .PARAMETER RampDownStartVMOnConnect
        Specifies whether to start VMs on connect during the ramp-down period. Valid options are "Enable" and "Disable". (Applicable only for the "Personal" ParameterSetName)
    .PARAMETER OffPeakStartVMOnConnect
        Specifies whether to start VMs on connect during the off-peak period. Valid options are "Enable" and "Disable". (Applicable only for the "Personal" ParameterSetName)
    .PARAMETER PeakActionOnDisconnect
        Specifies the action on disconnect during the peak period. Valid options are "Deallocate" and "None". (Applicable only for the "Personal" ParameterSetName)
    .PARAMETER PeakActionOnLogoff
        Specifies the action on logoff during the peak period. Valid options are "Deallocate" and "None". (Applicable only for the "Personal" ParameterSetName)
    .PARAMETER RampDownActionOnDisconnect
        Specifies the action on disconnect during the ramp-down period. Valid options are "Deallocate" and "None". (Applicable only for the "Personal" ParameterSetName)
    .PARAMETER RampDownActionOnLogoff
        Specifies the action on logoff during the ramp-down period. Valid options are "Deallocate" and "None". (Applicable only for the "Personal" ParameterSetName)
    .PARAMETER OffPeakActionOnDisconnect
        Specifies the action on disconnect during the off-peak period. Valid options are "Deallocate" and "None". (Applicable only for the "Personal" ParameterSetName)
    .PARAMETER OffPeakActionOnLogoff
        Specifies the action on logoff during the off-peak period. Valid options are "Deallocate" and "None". (Applicable only for the "Personal" ParameterSetName)
    .PARAMETER RampUpMinutesToWaitOnDisconnect
        Specifies the minutes to wait on disconnect during the ramp-up period. (Applicable only for the "Personal" ParameterSetName)
    .PARAMETER RampUpMinutesToWaitOnLogoff
        Specifies the minutes to wait on logoff during the ramp-up period. (Applicable only for the "Personal" ParameterSetName)
    .PARAMETER PeakMinutesToWaitOnDisconnect
        Specifies the minutes to wait on disconnect during the peak period. (Applicable only for the "Personal" ParameterSetName)
    .PARAMETER PeakMinutesToWaitOnLogoff
        Specifies the minutes to wait on logoff during the peak period. (Applicable only for the "Personal" ParameterSetName)
    .PARAMETER RampDownMinutesToWaitOnDisconnect
        Specifies the minutes to wait on disconnect during the ramp-down period. (Applicable only for the "Personal" ParameterSetName)
    .PARAMETER RampDownMinutesToWaitOnLogoff
        Specifies the minutes to wait on logoff during the ramp-down period. (Applicable only for the "Personal" ParameterSetName)
    .PARAMETER OffPeakMinutesToWaitOnDisconnect
        Specifies the minutes to wait on disconnect during the off-peak period. (Applicable only for the "Personal" ParameterSetName)
    .PARAMETER OffPeakMinutesToWaitOnLogoff
        Specifies the minutes to wait on logoff during the off-peak period. (Applicable only for the "Personal" ParameterSetName)
    .EXAMPLE
        New-AvdScalingPlanSchedule -ScalingPlanName "PersonalPlan" -ResourceGroupName 'rg-avd-01' -ScheduleName 'Thursday' -daysOfWeek @("Tuesday") @peakObject @rampUpObject @rampDownObject @offPeakObject
    #>
    [CmdletBinding(DefaultParameterSetName = "Pooled")]
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
        [string]$ScheduleName,

        [parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [array]$DaysOfWeek,

        [parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$RampUpStartTime,

        [parameter(Mandatory, ParameterSetName = "Personal")]
        [ValidateNotNullOrEmpty()]
        [ValidateSet("Deallocate", "None")]
        [string]$RampUpActionOnDisconnect,

        [parameter(Mandatory, ParameterSetName = "Personal")]
        [ValidateNotNullOrEmpty()]
        [ValidateSet("Deallocate", "None")]
        [string]$RampUpActionOnLogoff,

        [parameter(Mandatory, ParameterSetName = "Pooled")]
        [ValidateNotNullOrEmpty()]
        [ValidateSet("BreadthFirst", "DepthFirst")]
        [string]$RampUpLoadBalancingAlgorithm,

        [parameter(Mandatory, ParameterSetName = "Pooled")]
        [ValidateNotNullOrEmpty()]
        [int]$RampUpMinimumHostsPct,

        [parameter(Mandatory, ParameterSetName = "Pooled")]
        [ValidateNotNullOrEmpty()]
        [int]$RampUpCapacityThresholdPct,

        [parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$PeakStartTime,

        [parameter(Mandatory, ParameterSetName = "Pooled")]
        [ValidateNotNullOrEmpty()]
        [ValidateSet("BreadthFirst", "DepthFirst")]
        [string]$PeakLoadBalancingAlgorithm,

        [parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$RampDownStartTime,

        [parameter(Mandatory, ParameterSetName = "Pooled")]
        [ValidateNotNullOrEmpty()]
        [ValidateSet("BreadthFirst", "DepthFirst")]
        [string]$RampDownLoadBalancingAlgorithm,

        [parameter(Mandatory, ParameterSetName = "Pooled")]
        [ValidateNotNullOrEmpty()]
        [int]$RampDownMinimumHostsPct,

        [parameter(Mandatory, ParameterSetName = "Pooled")]
        [ValidateNotNullOrEmpty()]
        [int]$RampDownCapacityThresholdPct,

        [parameter(Mandatory, ParameterSetName = "Pooled")]
        [ValidateNotNullOrEmpty()]
        [boolean]$RampDownForceLogoffUsers,

        [parameter(Mandatory, ParameterSetName = "Pooled")]
        [ValidateNotNullOrEmpty()]
        [int]$RampDownWaitTimeMinutes,

        [parameter(Mandatory, ParameterSetName = "Pooled")]
        [ValidateNotNullOrEmpty()]
        [ValidateLength(1, 250)]
        [string]$RampDownNotificationMessage,

        [parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$OffPeakStartTime,

        [parameter(Mandatory, ParameterSetName = "Pooled")]
        [ValidateNotNullOrEmpty()]
        [ValidateSet("BreadthFirst", "DepthFirst")]
        [string]$OffPeakLoadBalancingAlgorithm,

        [parameter(Mandatory, ParameterSetName = "Personal")]
        [ValidateNotNullOrEmpty()]
        [ValidateSet("Enable", "Disable")]
        [string]$RampUpStartVMOnConnect,

        [parameter(Mandatory, ParameterSetName = "Personal")]
        [ValidateNotNullOrEmpty()]
        [ValidateSet("Enable", "Disable")]
        [string]$PeakStartVMOnConnect,

        [parameter(Mandatory, ParameterSetName = "Personal")]
        [ValidateNotNullOrEmpty()]
        [ValidateSet("Enable", "Disable")]
        [string]$RampDownStartVMOnConnect,

        [parameter(Mandatory, ParameterSetName = "Personal")]
        [ValidateNotNullOrEmpty()]
        [ValidateSet("Enable", "Disable")]
        [string]$OffPeakStartVMOnConnect,

        [parameter(Mandatory, ParameterSetName = "Personal")]
        [ValidateNotNullOrEmpty()]
        [ValidateSet("Deallocate", "None")]
        [string]$PeakActionOnDisconnect,

        [parameter(Mandatory, ParameterSetName = "Personal")]
        [ValidateNotNullOrEmpty()]
        [ValidateSet("Deallocate", "None")]
        [string]$PeakActionOnLogoff,

        [parameter(Mandatory, ParameterSetName = "Personal")]
        [ValidateNotNullOrEmpty()]
        [ValidateSet("Deallocate", "None")]
        [string]$RampDownActionOnDisconnect,

        [parameter(Mandatory, ParameterSetName = "Personal")]
        [ValidateNotNullOrEmpty()]
        [ValidateSet("Deallocate", "None")]
        [string]$RampDownActionOnLogoff,

        [parameter(Mandatory, ParameterSetName = "Personal")]
        [ValidateNotNullOrEmpty()]
        [ValidateSet("Deallocate", "None")]
        [string]$OffPeakActionOnDisconnect,

        [parameter(Mandatory, ParameterSetName = "Personal")]
        [ValidateNotNullOrEmpty()]
        [ValidateSet("Deallocate", "None")]
        [string]$OffPeakActionOnLogoff,

        [parameter(Mandatory, ParameterSetName = "Personal")]
        [ValidateNotNullOrEmpty()]
        [int]$RampUpMinutesToWaitOnDisconnect,

        [parameter(Mandatory, ParameterSetName = "Personal")]
        [ValidateNotNullOrEmpty()]
        [int]$RampUpMinutesToWaitOnLogoff,

        [parameter(Mandatory, ParameterSetName = "Personal")]
        [ValidateNotNullOrEmpty()]
        [int]$PeakMinutesToWaitOnDisconnect,

        [parameter(Mandatory, ParameterSetName = "Personal")]
        [ValidateNotNullOrEmpty()]
        [int]$PeakMinutesToWaitOnLogoff,

        [parameter(Mandatory, ParameterSetName = "Personal")]
        [ValidateNotNullOrEmpty()]
        [int]$RampDownMinutesToWaitOnDisconnect,

        [parameter(Mandatory, ParameterSetName = "Personal")]
        [ValidateNotNullOrEmpty()]
        [int]$RampDownMinutesToWaitOnLogoff,

        [parameter(Mandatory, ParameterSetName = "Personal")]
        [ValidateNotNullOrEmpty()]
        [int]$OffPeakMinutesToWaitOnDisconnect,

        [parameter(Mandatory, ParameterSetName = "Personal")]
        [ValidateNotNullOrEmpty()]
        [int]$OffPeakMinutesToWaitOnLogoff
    )

    Begin {
        Write-Verbose "Start creating scaling plan schedule for $ScalingPlanName"
        $body = @{
            properties = @{
                daysOfWeek        = @(
                    $DaysOfWeek
                )
                rampUpStartTime   = IsValidTime $RampUpStartTime
                peakStartTime     = IsValidTime $PeakStartTime
                rampDownStartTime = IsValidTime $RampDownStartTime
                offPeakStartTime  = IsValidTime $OffPeakStartTime
            }
        }
        switch ($PSCmdlet.ParameterSetName) {
            "Personal" {
                Write-Verbose "Creating a scaling plan personal type schedule"
                $scheduleType = "personalSchedules"
                $personalScheduleObject = @{
                    RampUpStartVMOnConnect            = $RampUpStartVMOnConnect
                    RampUpMinutesToWaitOnDisconnect   = $RampUpMinutesToWaitOnDisconnect
                    RampUpMinutesToWaitOnLogoff       = $RampUpMinutesToWaitOnLogoff
                    rampUpActionOnDisconnect          = $rampUpActionOnDisconnect
                    PeakStartVMOnConnect              = $PeakStartVMOnConnect
                    PeakActionOnDisconnect            = $PeakActionOnDisconnect
                    PeakMinutesToWaitOnDisconnect     = $PeakMinutesToWaitOnDisconnect
                    PeakActionOnLogoff                = $PeakActionOnLogoff
                    PeakMinutesToWaitOnLogoff         = $PeakMinutesToWaitOnLogoff
                    RampDownStartVMOnConnect          = $RampDownStartVMOnConnect
                    RampDownActionOnDisconnect        = $RampDownActionOnDisconnect
                    RampDownMinutesToWaitOnDisconnect = $RampDownMinutesToWaitOnDisconnect
                    RampDownActionOnLogoff            = $RampDownActionOnLogoff
                    RampDownMinutesToWaitOnLogoff     = $RampDownMinutesToWaitOnLogoff
                    OffPeakStartVMOnConnect           = $OffPeakStartVMOnConnect
                    OffPeakActionOnDisconnect         = $OffPeakActionOnDisconnect
                    OffPeakMinutesToWaitOnDisconnect  = $OffPeakMinutesToWaitOnDisconnect
                    OffPeakActionOnLogoff             = $OffPeakActionOnLogoff
                    OffPeakMinutesToWaitOnLogoff      = $OffPeakMinutesToWaitOnLogoff
                }
                $personalScheduleObject.GetEnumerator() | ForEach-Object { $body.properties.Add($_.Key, $_.Value) }
            }
            "Pooled" {
                $scheduleType = "pooledSchedules"
                $pooledScheduleObject = @{
                    rampUpLoadBalancingAlgorithm   = $RampUpLoadBalancingAlgorithm
                    rampUpMinimumHostsPct          = $RampUpMinimumHostsPct
                    rampUpCapacityThresholdPct     = $RampUpCapacityThresholdPct
                    peakLoadBalancingAlgorithm     = $PeakLoadBalancingAlgorithm
                    rampDownLoadBalancingAlgorithm = $RampDownLoadBalancingAlgorithm
                    rampDownMinimumHostsPct        = $RampDownMinimumHostsPct
                    rampDownCapacityThresholdPct   = $RampDownCapacityThresholdPct
                    rampDownForceLogoffUsers       = $RampDownForceLogoffUsers
                    rampDownWaitTimeMinutes        = $RampDownWaitTimeMinutes
                    rampDownNotificationMessage    = $RampDownNotificationMessage
                    offPeakLoadBalancingAlgorithm  = $OffPeakLoadBalancingAlgorithm
                }
                $pooledScheduleObject.GetEnumerator() | ForEach-Object { $body.properties.Add($_.Key, $_.Value) }
            }
        }
        $url = "{0}/subscriptions/{1}/resourceGroups/{2}/providers/Microsoft.DesktopVirtualization/scalingPlans/{3}/{4}/{5}?api-version={6}" -f $global:AzureApiUrl, $global:subscriptionId, $ResourceGroupName, $ScalingPlanName, $scheduleType, $ScheduleName, $global:scalingPlanApiVersion
    }
    Process {
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
