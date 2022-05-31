---
external help file: Az.Avd-help.xml
Module Name: Az.Avd
online version:
schema: 2.0.0
---

# Get-AvdSessionHost

## SYNOPSIS
Gets the current AVD Session hosts from a specific hostpool.

## SYNTAX

### All (Default)
```
Get-AvdSessionHost -HostpoolName <String> -ResourceGroupName <String> [<CommonParameters>]
```

### Hostname
```
Get-AvdSessionHost -HostpoolName <String> -ResourceGroupName <String> -SessionHostName <String>
 [<CommonParameters>]
```

## DESCRIPTION
This function will grab all the sessionhost from a specific Azure Virtual Desktop hostpool.

## EXAMPLES

### EXAMPLE 1
```
Get-AvdSessionHost -HostpoolName avd-hostpool-personal -ResourceGroupName rg-avd-01 -SessionHostName avd-host-1.avd.domain -AllowNewSession $true
```

### EXAMPLE 2
```
Get-AvdSessionHost -HostpoolName avd-hostpool-personal -ResourceGroupName rg-avd-01
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
Enter the sessionhosts name

```yaml
Type: String
Parameter Sets: Hostname
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
