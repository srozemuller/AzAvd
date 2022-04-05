---
external help file: Az.Avd-help.xml
Module Name: Az.Avd
online version:
schema: 2.0.0
---

# Get-AvdVmTemplate

## SYNOPSIS
Gets a VM template from an AVD hostpool.

## SYNTAX

```
Get-AvdVmTemplate [-HostpoolName] <String> [-ResourceGroupName] <String> [<CommonParameters>]
```

## DESCRIPTION
The function will search for an AVD VM template based on a hostpool

## EXAMPLES

### EXAMPLE 1
```
Get-AvdVmTemplate -hostpoolname avd-hostpool -ResourceGroupName rg-avd-01
```

## PARAMETERS

### -HostpoolName
Enter the AVD Hostpool name

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
Enter the AVD Hostpool resourcegroup name

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
