---
external help file: Az.Avd-help.xml
Module Name: Az.Avd
online version:
schema: 2.0.0
---

# Disable-AvdScalingPlan

## SYNOPSIS
Disables an Azure Virtual Desktop scaling plan.

## SYNTAX

```
Disable-AvdScalingPlan [-Name] <String> [-ResourceGroupName] <String> [-HostPool] <Object> [<CommonParameters>]
```

## DESCRIPTION
The function will disable an Azure Virtual Desktop scaling plan for the given hostpool(s).

## EXAMPLES

### EXAMPLE 1
```
Disable-AvdScalingPlan -Name 'ScalingPlan' -ResourceGroupName 'rg-avd-01' -Hostpool @{"Hostpool-1" = "RG-AVD-01"}
```

## PARAMETERS

### -Name
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

### -HostPool
{{ Fill HostPool Description }}

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
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
