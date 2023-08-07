---
external help file: Az.Avd-help.xml
Module Name: Az.Avd
online version:
schema: 2.0.0
---

# Unpublish-AvdScalingPlan

## SYNOPSIS
Removes an Azure Virtual Desktop scaling plan from a host pool.

## SYNTAX

```
Unpublish-AvdScalingPlan [-Name] <String> [-ResourceGroupName] <String> [-HostPool] <Object>
 [<CommonParameters>]
```

## DESCRIPTION
The function will remove an Azure Virtual Desktop scaling plan to (a) hostpool(s).

## EXAMPLES

### EXAMPLE 1
```
Unpublish-AvdScalingPlan -Name 'ScalingPlan' -ResourceGroupName 'rg-avd-01' -AssignToHostpool @{"Hostpool-1" = "RG-AVD-01"}
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
Enter the AVD Hostpool names and resource groups (eg.
@{"Hostpool-1" = "RG-AVD-01"; "Hostpool-2" = "RG-AVD-02" }

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
