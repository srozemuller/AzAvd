---
external help file: Az.Avd-help.xml
Module Name: az.avd
online version:
schema: 2.0.0
---

# New-AvdScalingPlan

## SYNOPSIS
Creates a new Azure Virtual Desktop Scaling plan.

## SYNTAX

```
New-AvdScalingPlan [-ScalingPlanName] <String> [-ResourceGroupName] <String> [-location] <String>
 [[-HostpoolType] <String>] [[-Description] <String>] [[-FriendlyName] <String>] [[-AssignToHostPool] <Object>]
 [[-TimeZone] <String>] [-ScheduleName] <String> [-ScheduleDays] <Array> [-rampUpStartTime] <String>
 [-rampUpLoadBalancingAlgorithm] <String> [-rampUpMinimumHostsPct] <Int32>
 [-rampUpCapacityThresholdPct] <Int32> [-peakStartTime] <String> [-peakLoadBalancingAlgorithm] <String>
 [-rampDownStartTime] <String> [-rampDownLoadBalancingAlgorithm] <String> [-rampDownMinimumHostsPct] <Int32>
 [-rampDownCapacityThresholdPct] <Int32> [-rampDownForceLogoffUsers] <Boolean>
 [-rampDownWaitTimeMinutes] <Int32> [-rampDownNotificationMessage] <String> [-offPeakStartTime] <String>
 [-offPeakLoadBalancingAlgorithm] <String> [<CommonParameters>]
```

## DESCRIPTION
The function will create a new Azure Virtual Desktop scaling plan and will assign it to (a) hostpool(s).

## EXAMPLES

### EXAMPLE 1
```
New-AvdScalingPlan -ScalingPlanName sp-avd-weekdays -resourceGroupName rg-avd-01 -location WestEurope -AssignToHostpool @{"Hostpool-1" = "RG-AVD-01"; "Hostpool-2" = "RG-AVD-02"} -ScheduleDays @("Monday", "WednesDay")
```

## PARAMETERS

### -ScalingPlanName
Enter the scaling plan name

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ResourceGroupName
Enter the resourcegroup name

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -location
Enter the location

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -HostpoolType
{{ Fill HostpoolType Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: Pooled
Accept pipeline input: False
Accept wildcard characters: False
```

### -Description
If needed fill in the description

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -FriendlyName
Change the scaling plan friendly name

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AssignToHostPool
Enter the AVD Hostpool names and resource groups (eg.
@{"Hostpool-1" = "RG-AVD-01"; "Hostpool-2" = "RG-AVD-02" } -ScheduleDays @("Monday", "WednesDay"))

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TimeZone
Timezone where the plan lives.
(default is the timezone where the script is running.)

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 8
Default value: (Get-TimeZone).id
Accept pipeline input: False
Accept wildcard characters: False
```

### -ScheduleName
Enter the schedule name

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 9
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ScheduleDays
Enter the days when the schedule needs to work (eg.
@("Monday", "WednesDay"))

```yaml
Type: Array
Parameter Sets: (All)
Aliases:

Required: True
Position: 10
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -rampUpStartTime
Enter the start time of the autoscale process

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 11
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -rampUpLoadBalancingAlgorithm
How do you like the loadbalancing (DepthFirst, BreadthFirst)

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 12
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -rampUpMinimumHostsPct
How many

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: True
Position: 13
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -rampUpCapacityThresholdPct
{{ Fill rampUpCapacityThresholdPct Description }}

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: True
Position: 14
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -peakStartTime
Enter the time of the maximum amount of hosts

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 15
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -peakLoadBalancingAlgorithm
How do you like the loadbalancing (DepthFirst, BreadthFirst)

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 16
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -rampDownStartTime
What time needs the scaling plan shutdown hosts.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 17
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -rampDownLoadBalancingAlgorithm
How do you like the loadbalancing (DepthFirst, BreadthFirst)

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 18
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -rampDownMinimumHostsPct
Enter the percentage of hosts which needs to be online.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: True
Position: 19
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -rampDownCapacityThresholdPct
Enter the usage percentage when to start a new host.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: True
Position: 20
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -rampDownForceLogoffUsers
Force logoff users?

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: True
Position: 21
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -rampDownWaitTimeMinutes
Number of minutes to wait to stop hosts during ramp down period.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: True
Position: 22
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -rampDownNotificationMessage
Provide the message to send to end users.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 23
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -offPeakStartTime
Whats the scaling plans end time?

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 24
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -offPeakLoadBalancingAlgorithm
How do you like the loadbalancing (DepthFirst, BreadthFirst)

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 25
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
