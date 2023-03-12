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

### Resource (Default)
```
Get-AvdSessionHost -Id <String> [<CommonParameters>]
```

### Hostname
```
Get-AvdSessionHost -HostpoolName <String> -ResourceGroupName <String> -Name <String> [<CommonParameters>]
```

### All
```
Get-AvdSessionHost -HostpoolName <String> -ResourceGroupName <String> [<CommonParameters>]
```

## DESCRIPTION
This function will grab all the sessionhost from a specific Azure Virtual Desktop hostpool.

## EXAMPLES

### EXAMPLE 1
```
Get-AvdSessionHost -HostpoolName avd-hostpool-personal -ResourceGroupName rg-avd-01 -Name avd-host-1.avd.domain
```

### EXAMPLE 2
```
Get-AvdSessionHost -HostpoolName avd-hostpool-personal -ResourceGroupName rg-avd-01
```

### EXAMPLE 3
```
Get-AvdSessionHost -Id sessionhostId
```

## PARAMETERS

### -HostpoolName
Enter the AVD Hostpool name

```yaml
Type: String
Parameter Sets: Hostname, All
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
Parameter Sets: Hostname, All
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
Enter the session hosts name

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

### -Id
Enter the sessionhost's resource ID

```yaml
Type: String
Parameter Sets: Resource
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
