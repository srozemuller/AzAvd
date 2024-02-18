---
external help file: Az.Avd-help.xml
Module Name: Az.Avd
online version:
schema: 2.0.0
---

# Remove-AvdScalingPlan

## SYNOPSIS
Removes a Azure Virtual Desktop Scaling plan.

## SYNTAX

### Default (Default)
```
Remove-AvdScalingPlan [<CommonParameters>]
```

### ScalingPlanName
```
Remove-AvdScalingPlan -ScalingPlanName <String> -ResourceGroupName <String> [<CommonParameters>]
```

### HostpoolName
```
Remove-AvdScalingPlan -ResourceGroupName <String> -HostpoolName <String> [<CommonParameters>]
```

### ResourceGroup
```
Remove-AvdScalingPlan -ResourceGroupName <String> [<CommonParameters>]
```

### ResourceId
```
Remove-AvdScalingPlan -Id <String> [<CommonParameters>]
```

## DESCRIPTION
The function will get a Azure Virtual Desktop scaling plan based on the current subscription context, resourcegroup, its name or the provided hostpool.

## EXAMPLES

### EXAMPLE 1
```
Remove-AvdScalingPlan -ScalingPlanName sp-avd-weekdays -resourceGroupName rg-avd-01
```

### EXAMPLE 2
```
Remove-AvdScalingPlan -Id ResourceId
```

## PARAMETERS

### -ScalingPlanName
Enter the scaling plan name

```yaml
Type: String
Parameter Sets: ScalingPlanName
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ResourceGroupName
Enter the resource group name

```yaml
Type: String
Parameter Sets: ScalingPlanName, HostpoolName, ResourceGroup
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -HostpoolName
Enter the hostpool name

```yaml
Type: String
Parameter Sets: HostpoolName
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
Aliases: ResourceId

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
