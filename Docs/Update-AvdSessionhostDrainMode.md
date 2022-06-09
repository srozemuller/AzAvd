---
external help file: Az.Avd-help.xml
Module Name: Az.Avd
online version:
schema: 2.0.0
---

# Update-AvdSessionhostDrainMode

## SYNOPSIS
Updates sessionhosts for accepting or denying connections.

## SYNTAX

### InputObject
```
Update-AvdSessionhostDrainMode -InputObject <PSObject> -AllowNewSession <Boolean> [<CommonParameters>]
```

### Parameters
```
Update-AvdSessionhostDrainMode -HostpoolName <String> -ResourceGroupName <String> -SessionHostName <String>
 -AllowNewSession <Boolean> [<CommonParameters>]
```

## DESCRIPTION
The function will update sessionhosts drainmode to true or false.
This can be one sessionhost or all of them.

## EXAMPLES

### EXAMPLE 1
```
Update-AvdSessionhostDrainMode -HostpoolName avd-hostpool-personal -ResourceGroupName rg-avd-01 -SessionHostName avd-host-1.avd.domain -AllowNewSession $true
```

## PARAMETERS

### -InputObject
An sessionhost object or array of sessionhosts.

```yaml
Type: PSObject
Parameter Sets: InputObject
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -HostpoolName
Enter the AVD Hostpool name

```yaml
Type: String
Parameter Sets: Parameters
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
Parameter Sets: Parameters
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
Parameter Sets: Parameters
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AllowNewSession
Enter $true or $false.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: True
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
