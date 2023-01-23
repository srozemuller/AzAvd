---
external help file: Az.Avd-help.xml
Module Name: Az.Avd
online version:
schema: 2.0.0
---

# Get-AvdSessionHostPowerState

## SYNOPSIS
Get AVD Session host's powerstate.

## SYNTAX

### All (Default)
```
Get-AvdSessionHostPowerState -HostpoolName <String> -ResourceGroupName <String> [<CommonParameters>]
```

### Hostname
```
Get-AvdSessionHostPowerState -HostpoolName <String> -ResourceGroupName <String> -Name <String>
 [<CommonParameters>]
```

### Resource
```
Get-AvdSessionHostPowerState -Id <Object> [<CommonParameters>]
```

## DESCRIPTION
Searches for a specific session host or all sessions hosts in a AVD hostpool and returns the current power state.

## EXAMPLES

### EXAMPLE 1
```
Get-AvdSessionHostPowerState -HostpoolName avd-hostpool-personal -ResourceGroupName rg-avd-01
```

### EXAMPLE 2
```
Get-AvdSessionHostPowerState -HostpoolName avd-hostpool-personal -ResourceGroupName rg-avd-01 -Name avd-host-1.avd.domain
```

### EXAMPLE 3
```
Get-AvdSessionHostPowerState -Id /subscriptions/../sessionhosts/avd-0
```

## PARAMETERS

### -HostpoolName
Enter the AVD Hostpool name

```yaml
Type: String
Parameter Sets: All, Hostname
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
Parameter Sets: All, Hostname
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
{{ Fill Name Description }}

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
Enter the session host's resource ID

```yaml
Type: Object
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
