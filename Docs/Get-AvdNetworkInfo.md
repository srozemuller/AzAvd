---
external help file: Az.Avd-help.xml
Module Name: Az.Avd
online version:
schema: 2.0.0
---

# Get-AvdNetworkInfo

## SYNOPSIS
Gets the sessionhost network information

## SYNTAX

### Hostpool (Default)
```
Get-AvdNetworkInfo -HostpoolName <String> -ResourceGroupName <String> [<CommonParameters>]
```

### Sessionhost
```
Get-AvdNetworkInfo -HostpoolName <String> -ResourceGroupName <String> [-SessionHostName <String>]
 [<CommonParameters>]
```

## DESCRIPTION
The function will help you getting insights about the AVD network configuration.

## EXAMPLES

### EXAMPLE 1
```
Get-AvdNetworkInfo -HostpoolName avd-hostpool -ResourceGroupName hostpool-resourcegroup
```

### EXAMPLE 2
```
Get-AvdNetworkInfo -HostpoolName avd-hostpool -ResourceGroupName hostpool-resourcegroup -SessionHostName avd-0.domain.local
```

## PARAMETERS

### -HostpoolName
Enter the AVD Hostpool name

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
Enter the AVD Hostpool resourcegroup name

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
This parameter accepts a single sessionhost name

```yaml
Type: String
Parameter Sets: Sessionhost
Aliases:

Required: False
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
