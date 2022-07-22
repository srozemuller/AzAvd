---
external help file: Az.Avd-help.xml
Module Name: Az.Avd
online version:
schema: 2.0.0
---

# Enable-AvdSessionHost

## SYNOPSIS
Enable login for sessionhosts.

## SYNTAX

### All (Default)
```
Enable-AvdSessionHost -HostpoolName <String> -ResourceGroupName <String> [-Force] [<CommonParameters>]
```

### Hostname
```
Enable-AvdSessionHost -HostpoolName <String> -ResourceGroupName <String> -Name <String> [<CommonParameters>]
```

### Resource
```
Enable-AvdSessionHost -Id <String> [<CommonParameters>]
```

## DESCRIPTION
The function gets a session host out of drainmode, which means that users are able to login to that host.

## EXAMPLES

### EXAMPLE 1
```
Enable-AvdSessionHost -HostpoolName avd-hostpool -ResourceGroupName rg-avd-01 -Nameavd-host-1.avd.domain
```

### EXAMPLE 2
```
Enable-AvdSessionHost -HostpoolName avd-hostpool -ResourceGroupName rg-avd-01 -Force
```

## PARAMETERS

### -HostpoolName
Enter the source AVD Hostpool name

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
Enter the source Hostpool resourcegroup name

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
Enter the sessionhosts name avd-host-1.avd.domain

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
Type: String
Parameter Sets: Resource
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Force
Use the -Force switch to disable session hosts without interaction

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
