---
external help file: Az.Avd-help.xml
Module Name: Az.Avd
online version:
schema: 2.0.0
---

# New-AvdScalingPlanSchedule

## SYNOPSIS
Modifies the scaling plan for a specified resource group.

## SYNTAX

### Pooled (Default)
```
New-AvdScalingPlanSchedule -ScalingPlanName <String> -ResourceGroupName <String> -ScheduleName <String>
 -DaysOfWeek <Array> -RampUpStartTime <String> -RampUpLoadBalancingAlgorithm <String>
 -RampUpMinimumHostsPct <Int32> -RampUpCapacityThresholdPct <Int32> -PeakStartTime <String>
 -PeakLoadBalancingAlgorithm <String> -RampDownStartTime <String> -RampDownLoadBalancingAlgorithm <String>
 -RampDownMinimumHostsPct <Int32> -RampDownCapacityThresholdPct <Int32> -RampDownForceLogoffUsers <Boolean>
 -RampDownWaitTimeMinutes <Int32> -RampDownNotificationMessage <String> -OffPeakStartTime <String>
 -OffPeakLoadBalancingAlgorithm <String> [<CommonParameters>]
```

### Personal
```
New-AvdScalingPlanSchedule -ScalingPlanName <String> -ResourceGroupName <String> -ScheduleName <String>
 -DaysOfWeek <Array> -RampUpStartTime <String> -RampUpActionOnDisconnect <String>
 -RampUpActionOnLogoff <String> -PeakStartTime <String> -RampDownStartTime <String> -OffPeakStartTime <String>
 -RampUpStartVMOnConnect <String> -PeakStartVMOnConnect <String> -RampDownStartVMOnConnect <String>
 -OffPeakStartVMOnConnect <String> -PeakActionOnDisconnect <String> -PeakActionOnLogoff <String>
 -RampDownActionOnDisconnect <String> -RampDownActionOnLogoff <String> -OffPeakActionOnDisconnect <String>
 -OffPeakActionOnLogoff <String> -RampUpMinutesToWaitOnDisconnect <Int32> -RampUpMinutesToWaitOnLogoff <Int32>
 -PeakMinutesToWaitOnDisconnect <Int32> -PeakMinutesToWaitOnLogoff <Int32>
 -RampDownMinutesToWaitOnDisconnect <Int32> -RampDownMinutesToWaitOnLogoff <Int32>
 -OffPeakMinutesToWaitOnDisconnect <Int32> -OffPeakMinutesToWaitOnLogoff <Int32> [<CommonParameters>]
```

## DESCRIPTION
The Set-ScalingPlan cmdlet modifies the scaling plan for a specified resource group.
It allows you to configure different scaling settings for either pooled or personal desktops, depending on the ParameterSetName.

## EXAMPLES

### EXAMPLE 1
```
New-AvdScalingPlanSchedule -ScalingPlanName "PersonalPlan" -ResourceGroupName 'rg-avd-01' -ScheduleName 'Thursday' -daysOfWeek @("Tuesday") @peakObject @rampUpObject @rampDownObject @offPeakObject
```

## PARAMETERS

### -ScalingPlanName
Specifies the name of the scaling plan to modify.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ResourceGroupName
Specifies the name of the resource group where the scaling plan is located.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ScheduleName
Specifies the name of the schedule to update.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DaysOfWeek
Specifies an array of days of the week for the schedule.

```yaml
Type: Array
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RampUpStartTime
Specifies the start time for the ramp-up period.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RampUpActionOnDisconnect
{{ Fill RampUpActionOnDisconnect Description }}

```yaml
Type: String
Parameter Sets: Personal
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RampUpActionOnLogoff
{{ Fill RampUpActionOnLogoff Description }}

```yaml
Type: String
Parameter Sets: Personal
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RampUpLoadBalancingAlgorithm
Specifies the load balancing algorithm during the ramp-up period.
Valid options are "BreadthFirst" and "DepthFirst".
(Applicable only for the "Pooled" ParameterSetName)

```yaml
Type: String
Parameter Sets: Pooled
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RampUpMinimumHostsPct
Specifies the minimum percentage of hosts during the ramp-up period.
(Applicable only for the "Pooled" ParameterSetName)

```yaml
Type: Int32
Parameter Sets: Pooled
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -RampUpCapacityThresholdPct
Specifies the capacity threshold percentage during the ramp-up period.
(Applicable only for the "Pooled" ParameterSetName)

```yaml
Type: Int32
Parameter Sets: Pooled
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -PeakStartTime
Specifies the start time for the peak period.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PeakLoadBalancingAlgorithm
Specifies the load balancing algorithm during the peak period.
Valid options are "BreadthFirst" and "DepthFirst".
(Applicable only for the "Pooled" ParameterSetName)

```yaml
Type: String
Parameter Sets: Pooled
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RampDownStartTime
Specifies the start time for the ramp-down period.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RampDownLoadBalancingAlgorithm
Specifies the load balancing algorithm during the ramp-down period.
Valid options are "BreadthFirst" and "DepthFirst".
(Applicable only for the "Pooled" ParameterSetName)

```yaml
Type: String
Parameter Sets: Pooled
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RampDownMinimumHostsPct
Specifies the minimum percentage of hosts during the ramp-down period.
(Applicable only for the "Pooled" ParameterSetName)

```yaml
Type: Int32
Parameter Sets: Pooled
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -RampDownCapacityThresholdPct
Specifies the capacity threshold percentage during the ramp-down period.
(Applicable only for the "Pooled" ParameterSetName)

```yaml
Type: Int32
Parameter Sets: Pooled
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -RampDownForceLogoffUsers
Indicates whether to force logoff users during the ramp-down period.
(Applicable only for the "Pooled" ParameterSetName)

```yaml
Type: Boolean
Parameter Sets: Pooled
Aliases:

Required: True
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -RampDownWaitTimeMinutes
Specifies the wait time in minutes during the ramp-down period.
(Applicable only for the "Pooled" ParameterSetName)

```yaml
Type: Int32
Parameter Sets: Pooled
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -RampDownNotificationMessage
Specifies the notification message during the ramp-down period.
(Applicable only for the "Pooled" ParameterSetName)

```yaml
Type: String
Parameter Sets: Pooled
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -OffPeakStartTime
Specifies the start time for the off-peak period.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -OffPeakLoadBalancingAlgorithm
Specifies the load balancing algorithm during the off-peak period.
Valid options are "BreadthFirst" and "DepthFirst".
(Applicable only for the "Pooled" ParameterSetName)

```yaml
Type: String
Parameter Sets: Pooled
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RampUpStartVMOnConnect
Specifies whether to start VMs on connect during the ramp-up period.
Valid options are "Enable" and "Disable".
(Applicable only for the "Personal" ParameterSetName)

```yaml
Type: String
Parameter Sets: Personal
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PeakStartVMOnConnect
Specifies whether to start VMs on connect during the peak period.
Valid options are "Enable" and "Disable".
(Applicable only for the "Personal" ParameterSetName)

```yaml
Type: String
Parameter Sets: Personal
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RampDownStartVMOnConnect
Specifies whether to start VMs on connect during the ramp-down period.
Valid options are "Enable" and "Disable".
(Applicable only for the "Personal" ParameterSetName)

```yaml
Type: String
Parameter Sets: Personal
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -OffPeakStartVMOnConnect
Specifies whether to start VMs on connect during the off-peak period.
Valid options are "Enable" and "Disable".
(Applicable only for the "Personal" ParameterSetName)

```yaml
Type: String
Parameter Sets: Personal
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PeakActionOnDisconnect
Specifies the action on disconnect during the peak period.
Valid options are "Deallocate" and "None".
(Applicable only for the "Personal" ParameterSetName)

```yaml
Type: String
Parameter Sets: Personal
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PeakActionOnLogoff
Specifies the action on logoff during the peak period.
Valid options are "Deallocate" and "None".
(Applicable only for the "Personal" ParameterSetName)

```yaml
Type: String
Parameter Sets: Personal
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RampDownActionOnDisconnect
Specifies the action on disconnect during the ramp-down period.
Valid options are "Deallocate" and "None".
(Applicable only for the "Personal" ParameterSetName)

```yaml
Type: String
Parameter Sets: Personal
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RampDownActionOnLogoff
Specifies the action on logoff during the ramp-down period.
Valid options are "Deallocate" and "None".
(Applicable only for the "Personal" ParameterSetName)

```yaml
Type: String
Parameter Sets: Personal
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -OffPeakActionOnDisconnect
Specifies the action on disconnect during the off-peak period.
Valid options are "Deallocate" and "None".
(Applicable only for the "Personal" ParameterSetName)

```yaml
Type: String
Parameter Sets: Personal
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -OffPeakActionOnLogoff
Specifies the action on logoff during the off-peak period.
Valid options are "Deallocate" and "None".
(Applicable only for the "Personal" ParameterSetName)

```yaml
Type: String
Parameter Sets: Personal
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RampUpMinutesToWaitOnDisconnect
Specifies the minutes to wait on disconnect during the ramp-up period.
(Applicable only for the "Personal" ParameterSetName)

```yaml
Type: Int32
Parameter Sets: Personal
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -RampUpMinutesToWaitOnLogoff
Specifies the minutes to wait on logoff during the ramp-up period.
(Applicable only for the "Personal" ParameterSetName)

```yaml
Type: Int32
Parameter Sets: Personal
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -PeakMinutesToWaitOnDisconnect
Specifies the minutes to wait on disconnect during the peak period.
(Applicable only for the "Personal" ParameterSetName)

```yaml
Type: Int32
Parameter Sets: Personal
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -PeakMinutesToWaitOnLogoff
Specifies the minutes to wait on logoff during the peak period.
(Applicable only for the "Personal" ParameterSetName)

```yaml
Type: Int32
Parameter Sets: Personal
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -RampDownMinutesToWaitOnDisconnect
Specifies the minutes to wait on disconnect during the ramp-down period.
(Applicable only for the "Personal" ParameterSetName)

```yaml
Type: Int32
Parameter Sets: Personal
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -RampDownMinutesToWaitOnLogoff
Specifies the minutes to wait on logoff during the ramp-down period.
(Applicable only for the "Personal" ParameterSetName)

```yaml
Type: Int32
Parameter Sets: Personal
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -OffPeakMinutesToWaitOnDisconnect
Specifies the minutes to wait on disconnect during the off-peak period.
(Applicable only for the "Personal" ParameterSetName)

```yaml
Type: Int32
Parameter Sets: Personal
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -OffPeakMinutesToWaitOnLogoff
Specifies the minutes to wait on logoff during the off-peak period.
(Applicable only for the "Personal" ParameterSetName)

```yaml
Type: Int32
Parameter Sets: Personal
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
