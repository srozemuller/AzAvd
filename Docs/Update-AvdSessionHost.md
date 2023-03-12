---
external help file: Az.Avd-help.xml
Module Name: Az.Avd
online version:
schema: 2.0.0
---

# Update-AvdSessionHost

## SYNOPSIS
Updating one or more sessionhosts.
Assign new users or put them in drainmode or not.

## SYNTAX

### Id (Default)
```
Update-AvdSessionHost [-AllowNewSession <Boolean>] [-AssignedUser <String>] [-FriendlyName <String>]
 -Id <Object> [-Force] [<CommonParameters>]
```

### Hostname
```
Update-AvdSessionHost -HostpoolName <String> -ResourceGroupName <String> [-AllowNewSession <Boolean>]
 [-AssignedUser <String>] [-FriendlyName <String>] -SessionHostName <String> [-Force] [<CommonParameters>]
```

### All
```
Update-AvdSessionHost -HostpoolName <String> -ResourceGroupName <String> [-AllowNewSession <Boolean>] [-Force]
 [<CommonParameters>]
```

## DESCRIPTION
The function will update the current sessionhosts assigned user and drainmode

## EXAMPLES

### EXAMPLE 1
```
Update-AvdSessionHost -HostpoolName avd-hostpool -ResourceGroupName rg-avd-01 -SessionHostName avd-hostpool/avd-host-1.avd.domain -AllowNewSession $true
```

### EXAMPLE 2
```
Update-AvdSessionHost -HostpoolName avd-hostpool -ResourceGroupName rg-avd-01 -SessionHostName avd-hostpool/avd-host-1.avd.domain -AssignedUser "" -Force
```

## PARAMETERS

### -HostpoolName
Enter the source AVD Hostpool name

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
Enter the source Hostpool resourcegroup name

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

### -AllowNewSession
Allowing new sessions or not.
(Default: true).

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: True
Accept pipeline input: False
Accept wildcard characters: False
```

### -AssignedUser
Enter the new username for the current sessionhost.
Only available if providing one sessionhost at a time.

```yaml
Type: String
Parameter Sets: Id, Hostname
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -FriendlyName
Enter a friendly name for the current sessionhost.

```yaml
Type: String
Parameter Sets: Id, Hostname
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SessionHostName
Enter the sessionhosts name avd-hostpool/avd-host-1.avd.domain

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
{{ Fill Id Description }}

```yaml
Type: Object
Parameter Sets: Id
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Force
{{ Fill Force Description }}

```yaml
Type: SwitchParameter
Parameter Sets: (All)
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
