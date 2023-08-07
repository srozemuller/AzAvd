---
external help file: Az.Avd-help.xml
Module Name: Az.Avd
online version:
schema: 2.0.0
---

# Remove-AvdScalingPlanSchedule

## SYNOPSIS
Modifies the scaling plan for a specified resource group.

## SYNTAX

### FriendlyName (Default)
```
Remove-AvdScalingPlanSchedule [-Name <String>] -ScalingPlanName <String> -ResourceGroupName <String>
 [<CommonParameters>]
```

### ResourceId
```
Remove-AvdScalingPlanSchedule -Id <String> [<CommonParameters>]
```

### PlanId
```
Remove-AvdScalingPlanSchedule -PlanResourceId <String> [<CommonParameters>]
```

## DESCRIPTION
The Set-ScalingPlan cmdlet modifies the scaling plan for a specified resource group.
It allows you to configure different scaling settings for either pooled or personal desktops, depending on the ParameterSetName.

## EXAMPLES

### EXAMPLE 1
```
Remove-AvdScalingPlanSchedule -Name "MondaySchedule" -ResourceGroupName 'rg-avd-01' -ScalingPlanName 'sp-avd-weekdays'
```

### EXAMPLE 2
```
Remove-AvdScalingPlanSchedule -Id "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-avd-01/providers/Microsoft.DesktopVirtualization/scalingPlans/sp-avd-weekdays/schedules/MondaySchedule"
```

## PARAMETERS

### -Name
Specifies the name of the schedule to remove.

```yaml
Type: String
Parameter Sets: FriendlyName
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ScalingPlanName
Specifies the name of the scaling plan to modify.

```yaml
Type: String
Parameter Sets: FriendlyName
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
Parameter Sets: FriendlyName
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Id
{{ Fill Id Description }}

```yaml
Type: String
Parameter Sets: ResourceId
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -PlanResourceId
{{ Fill PlanResourceId Description }}

```yaml
Type: String
Parameter Sets: PlanId
Aliases:

Required: True
Position: Named
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
