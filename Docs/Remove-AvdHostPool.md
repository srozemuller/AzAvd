---
external help file: Az.Avd-help.xml
Module Name: Az.Avd
online version:
schema: 2.0.0
---

# Remove-AvdHostPool

## SYNOPSIS
Removes AVD Hostpool information.

## SYNTAX

### Name (Default)
```
Remove-AvdHostPool -HostPoolName <String> -ResourceGroupName <String> [-Force] [<CommonParameters>]
```

### ResourceId
```
Remove-AvdHostPool -ResourceId <String> [-Force] [<CommonParameters>]
```

## DESCRIPTION
With this function you can remove an AVD hostpool.

## EXAMPLES

### EXAMPLE 1
```
Remove-AvdHostPool -HostPoolName avd-hostpool-001 -ResourceGroupName rg-avd-001
```

### EXAMPLE 2
```
Remove-AvdHostPool -ResourceId "/subscription/../HostPoolName"
```

### EXAMPLE 3
```
Remove-AvdHostPool -HostPoolName avd-hostpool-001 -ResourceGroupName rg-avd-001 -Force
```

## PARAMETERS

### -HostPoolName
Enter the name of the hostpool you want remove.

```yaml
Type: String
Parameter Sets: Name
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ResourceGroupName
Enter the name of the resourcegroup where the hostpool resides in.

```yaml
Type: String
Parameter Sets: Name
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ResourceId
Enter the hostpool ResourceId

```yaml
Type: String
Parameter Sets: ResourceId
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
