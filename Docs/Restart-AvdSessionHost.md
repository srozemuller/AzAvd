---
external help file: Az.Avd-help.xml
Module Name: Az.Avd
online version:
schema: 2.0.0
---

# Restart-AvdSessionHost

## SYNOPSIS
Restarts AVD Session hosts in a specific hostpool.

## SYNTAX

### All (Default)
```
Restart-AvdSessionHost -HostpoolName <String> -ResourceGroupName <String> -Name <String> [-Force]
 [<CommonParameters>]
```

### Hostname
```
Restart-AvdSessionHost -HostpoolName <String> -ResourceGroupName <String> -Name <String> [<CommonParameters>]
```

### Resource
```
Restart-AvdSessionHost -Id <Object> [<CommonParameters>]
```

## DESCRIPTION
This function restarts sessionshosts in a specific Azure Virtual Desktop hostpool.
If you want to start a specific session host then also provide the name,

## EXAMPLES

### EXAMPLE 1
```
Restart-AvdSessionHost -HostpoolName avd-hostpool-personal -ResourceGroupName rg-avd-01
```

### EXAMPLE 2
```
Restart-AvdSessionHost -HostpoolName avd-hostpool-personal -ResourceGroupName rg-avd-01 -SessionHostName avd-host-1.avd.domain
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
Parameter Sets: All, Hostname
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Id
{{ Fill Id Description }}

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

### -Force
{{ Fill Force Description }}

```yaml
Type: SwitchParameter
Parameter Sets: All
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
