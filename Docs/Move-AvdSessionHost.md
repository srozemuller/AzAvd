---
external help file: Az.Avd-help.xml
Module Name: Az.Avd
online version:
schema: 2.0.0
---

# Move-AvdSessionHost

## SYNOPSIS
Moving sessionhosts from an Azure Virtual Desktop hostpool to a new one.

## SYNTAX

### All (Default)
```
Move-AvdSessionHost -FromHostpoolName <String> -FromResourceGroupName <String> -ToHostpoolName <String>
 -ToResourceGroupName <String> [-Force] [<CommonParameters>]
```

### SingleObject
```
Move-AvdSessionHost -FromHostpoolName <String> -FromResourceGroupName <String> -ToHostpoolName <String>
 -ToResourceGroupName <String> -SessionHostName <String> [-Force] [<CommonParameters>]
```

### ResourceID
```
Move-AvdSessionHost -ToHostpoolName <String> -ToResourceGroupName <String> -Id <String> [-Force]
 [<CommonParameters>]
```

## DESCRIPTION
The function will move sessionhosts to a new Azure Virtual Desktop hostpool.

## EXAMPLES

### EXAMPLE 1
```
Move-AvdSessionHost -FromHostpoolName avd-hostpool -FromResourceGroupName rg-avd-01 -ToHostpoolName avd-hostpool-02 -ToResourceGroupName rg-avd-02 -SessionHostName avd-host-1.avd.domain
```

### EXAMPLE 2
```
Move-AvdSessionHost -Id /subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/rg-avd-01/providers/Microsoft.DesktopVirtualization/hostPools/avd-hostpool/sessionHosts/avd-host-1.avd.domain -ToHostpoolName avd-hostpool-02 -ToResourceGroupName rg-avd-02
```

## PARAMETERS

### -FromHostpoolName
Enter the source AVD Hostpool name

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

### -FromResourceGroupName
Enter the source Hostpool resourcegroup name

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

### -ToHostpoolName
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

### -ToResourceGroupName
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
Type: String
Parameter Sets: ResourceID
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Force
Force the move of the sessionhost

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
