---
external help file: Az.Avd-help.xml
Module Name: Az.Avd
online version:
schema: 2.0.0
---

# New-AvdPersonalScalingPlan

## SYNOPSIS
Creates a new Azure Virtual Desktop Personal Scaling plan.

## SYNTAX

```
New-AvdPersonalScalingPlan [-Name] <String> [-ResourceGroupName] <String> [-Location] <String>
 [[-Description] <String>] [[-FriendlyName] <String>] [[-AssignToHostPool] <Object>] [[-TimeZone] <String>]
 [<CommonParameters>]
```

## DESCRIPTION
The function will create a new Azure Virtual Desktop scaling plan and will assign it to (a) hostpool(s).

## EXAMPLES

### EXAMPLE 1
```
New-AvdPersonalScalingPlan -Name 'ScalingPlan' -ResourceGroupName 'rg-avd-01' -Location 'WestEurope'
```

### EXAMPLE 2
```
New-AvdPersonalScalingPlan -Name 'ScalingPlan' -ResourceGroupName 'rg-avd-01' -Location 'WestEurope' -AssignToHostpool @{"Hostpool-1" = "RG-AVD-01"}
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

### -Location
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

### -Description
If needed fill in the description

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
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
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AssignToHostPool
Enter the AVD Hostpool names and resource groups (eg.
@{"Hostpool-1" = "RG-AVD-01"; "Hostpool-2" = "RG-AVD-02" }

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
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
Position: 7
Default value: (Get-TimeZone).StandardName
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
