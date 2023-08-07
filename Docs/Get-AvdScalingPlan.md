---
external help file: Az.Avd-help.xml
Module Name: Az.Avd
online version:
schema: 2.0.0
---

# Get-AvdScalingPlan

## SYNOPSIS
Get a Azure Virtual Desktop Scaling plan.

## SYNTAX

### Default (Default)
```
Get-AvdScalingPlan [<CommonParameters>]
```

### ScalingPlanName
```
Get-AvdScalingPlan -Name <String> -ResourceGroupName <String> [<CommonParameters>]
```

### HostpoolName
```
Get-AvdScalingPlan -ResourceGroupName <String> -HostpoolName <String> [<CommonParameters>]
```

### ResourceGroup
```
Get-AvdScalingPlan -ResourceGroupName <String> [<CommonParameters>]
```

### ResourceId
```
Get-AvdScalingPlan -Id <String> [<CommonParameters>]
```

## DESCRIPTION
The function will get a Azure Virtual Desktop scaling plan based on the current subscription context, resourcegroup, its name or the provided hostpool.

## EXAMPLES

### EXAMPLE 1
```
Get-AvdScalingPlan -ScalingPlanName sp-avd-weekdays -resourceGroupName rg-avd-01
```

### EXAMPLE 2
```
Get-AvdScalingPlan -HostpoolName Hostpool-1 -resourceGroupName rg-avd-01
```

### EXAMPLE 3
```
Get-AvdScalingPlan -ResourceGroupName rg-avd-01
```

### EXAMPLE 4
```
Get-AvdScalingPlan
```

## PARAMETERS

### -Name
{{ Fill Name Description }}

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
