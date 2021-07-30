---
external help file: Az.Avd-help.xml
Module Name: Az.Avd
online version:
schema: 2.0.0
---

# Move-AvdSessionhost

## SYNOPSIS
Moving sessionhosts from an Azure Virtual Desktop hostpool to a new one.

## SYNTAX

```
Move-AvdSessionhost -fromHostpoolName <String> -fromResourceGroupName <String> -toHostpoolName <String>
 -toResourceGroupName <String> [-sessionHostName <String>] [<CommonParameters>]
```

## DESCRIPTION
The function will move sessionhosts to a new Azure Virtual Desktop hostpool.

## EXAMPLES

### EXAMPLE 1
```
Move-AvdSessionhost -FromHostpoolName avd-hostpool -FromResourceGroupName rg-avd-01 -ToHostpoolName avd-hostpool-02 -ToResourceGroupName rg-avd-02 -SessionHostName avd-host-1.avd.domain
```

## PARAMETERS

### -fromHostpoolName
Enter the source AVD Hostpool name

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

### -fromResourceGroupName
Enter the source Hostpool resourcegroup name

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

### -toHostpoolName
Enter the destination AVD Hostpool name

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

### -toResourceGroupName
Enter the destination Hostpool resourcegroup name

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

### -sessionHostName
Enter the sessionhosts name avd-hostpool/avd-host-1.avd.domain

```yaml
Type: String
Parameter Sets: (All)
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
