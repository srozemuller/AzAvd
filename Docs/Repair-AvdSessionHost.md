---
external help file: Az.Avd-help.xml
Module Name: Az.Avd
online version:
schema: 2.0.0
---

# Repair-AvdSessionHost

## SYNOPSIS
Repairing sessionhosts in an Azure Virtual Desktop hostpool.

## SYNTAX

### All (Default)
```
Repair-AvdSessionHost -HostpoolName <String> -ResourceGroupName <String> [<CommonParameters>]
```

### SingleObject
```
Repair-AvdSessionHost -HostpoolName <String> -ResourceGroupName <String> -SessionHostName <String>
 [<CommonParameters>]
```

### Id
```
Repair-AvdSessionHost -Id <Object> [<CommonParameters>]
```

## DESCRIPTION
The function will search for sessionhosts and will repair them in the Azure Virtual Desktop hostpool.
Usefull when a sessionhost is in a bad state.

## EXAMPLES

### EXAMPLE 1
```
Repair-AvdSessionHost -HostpoolName avd-hostpool-personal -ResourceGroupName rg-avd-01 -SessionHostName avd-host-1.avd.domain
```

### EXAMPLE 2
```
Repair-AvdSessionHost -Id /subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/rg-avd-01/providers/Microsoft.DesktopVirtualization/hostpools/avd-hostpool-personal/sessionhosts/avd-host-1.avd.domain
```

## PARAMETERS

### -HostpoolName
Enter the  AVD Hostpool name

```yaml
Type: String
Parameter Sets: All, SingleObject
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ResourceGroupName
Enter the  Hostpool resourcegroup name

```yaml
Type: String
Parameter Sets: All, SingleObject
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SessionHostName
Enter the sessionhosts name avd-hostpool/avd-host-1.avd.domain

```yaml
Type: String
Parameter Sets: SingleObject
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Id
Enter the sessionhosts resource id

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
