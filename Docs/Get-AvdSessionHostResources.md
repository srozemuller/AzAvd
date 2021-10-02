---
external help file: Az.Avd-help.xml
Module Name: Az.Avd
online version:
schema: 2.0.0
---

# Get-AvdSessionHostResources

## SYNOPSIS
Gets the Virtual Machines Azure resource from a AVD Session Host

## SYNTAX

### Hostpool (Default)
```
Get-AvdSessionHostResources -HostpoolName <String> -ResourceGroupName <String> [<CommonParameters>]
```

### Sessionhost
```
Get-AvdSessionHostResources -HostpoolName <String> -ResourceGroupName <String> -SessionHostName <String>
 [<CommonParameters>]
```

## DESCRIPTION
The function will help you getting the virtual machine resource information which is behind the AVD Session Host

## EXAMPLES

### EXAMPLE 1
```
Get-AvdSessionHostResources -Hostpoolname avd-hostpool -ResourceGroup rg-avd-01
```

### EXAMPLE 2
```
Get-AvdSessionHostResources -Hostpoolname avd-hostpool -ResourceGroup rg-avd-01
```

## PARAMETERS

### -HostpoolName
Enter the AVD hostpool name

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
Enter the AVD hostpool resourcegroup

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

### -SessionHostName
Enter the AVD Session Host name

```yaml
Type: String
Parameter Sets: Sessionhost
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
