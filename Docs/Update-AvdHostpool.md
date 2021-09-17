---
external help file: Az.Avd-help.xml
Module Name: Az.Avd
online version:
schema: 2.0.0
---

# Update-AvdHostpool

## SYNOPSIS
Removing sessionhosts from an Azure Virtual Desktop hostpool.

## SYNTAX

```
Update-AvdHostpool -HostpoolName <String> -ResourceGroupName <String> [-customRdpProperty <String>]
 [-friendlyName <String>] [-loadBalancerType <String>] [-validationEnvironment <Boolean>]
 [-maxSessionLimit <Int32>] [-Force] [<CommonParameters>]
```

## DESCRIPTION
The function will search for sessionhosts and will remove them from the Azure Virtual Desktop hostpool.

## EXAMPLES

### EXAMPLE 1
```
Update-AvdHostpool
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

### -customRdpProperty
If needed fill in the custom rdp properties (for example: targetisaadjoined:i:1 )

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

### -friendlyName
Change the host pool friendly name

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

### -loadBalancerType
Change the host pool loadBalancerType

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

### -validationEnvironment
Change the host pool validation environment

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -maxSessionLimit
Change the host pool max session limit (max 999999)

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Force
use the force parameter if you want to override the current customrdpproperties.
Otherwise it will add the provided properties.

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
