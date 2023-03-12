---
external help file: Az.Avd-help.xml
Module Name: Az.Avd
online version:
schema: 2.0.0
---

# Grant-AvdSessionHost

## SYNOPSIS
Assigns a user to a session host

## SYNTAX

### Hostname (Default)
```
Grant-AvdSessionHost -HostpoolName <String> -ResourceGroupName <String> -Name <String> -AssignedUser <String>
 [<CommonParameters>]
```

### Resource
```
Grant-AvdSessionHost -AssignedUser <String> -Id <String> [<CommonParameters>]
```

## DESCRIPTION
The function assigns an user to an AVD session host

## EXAMPLES

### EXAMPLE 1
```
Grant-AvdSessionHost -HostpoolName avd-hostpool -ResourceGroupName rg-avd-01 -Name avd-hostpool/avd-host-1.avd.domain -AllowNewSession $true
```

### EXAMPLE 2
```
Grant-AvdSessionHost -HostpoolName avd-hostpool -ResourceGroupName rg-avd-01 -SessionHostName avd-hostpool/avd-host-1.avd.domain -AssignedUser "" -Force
```

## PARAMETERS

### -HostpoolName
Enter the source AVD Hostpool name

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

### -ResourceGroupName
Enter the source Hostpool resourcegroup name

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

### -AssignedUser
Enter the new username for the current sessionhost.
Only available if providing one sessionhost at a time.

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

### -Id
Enter

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
