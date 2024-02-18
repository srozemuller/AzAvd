---
external help file: Az.Avd-help.xml
Module Name: Az.Avd
online version:
schema: 2.0.0
---

# Get-AvdHostPool

## SYNOPSIS
Get AVD Hostpool information.

## SYNTAX

### Name
```
Get-AvdHostPool -HostPoolName <String> -ResourceGroupName <String> [<CommonParameters>]
```

### ResourceId
```
Get-AvdHostPool -ResourceId <String> [<CommonParameters>]
```

## DESCRIPTION
With this function you can get information about an AVD hostpool.

## EXAMPLES

### EXAMPLE 1
```
Get-AvdHostPool
```

### EXAMPLE 2
```
Get-AvdHostPool -HostPoolName avd-hostpool-001 -ResourceGroupName rg-avd-001
```

### EXAMPLE 3
```
Get-AvdHostPool -ResourceId "/subscription/../HostPoolName"
```

## PARAMETERS

### -HostPoolName
Enter the name of the hostpool you want information from.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
