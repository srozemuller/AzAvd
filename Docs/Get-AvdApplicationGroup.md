---
external help file: Az.Avd-help.xml
Module Name: Az.Avd
online version:
schema: 2.0.0
---

# Get-AvdApplicationGroup

## SYNOPSIS
Get AVD applicationgroup information with the assigned permissions.

## SYNTAX

### Name
```
Get-AvdApplicationGroup -Name <String> -ResourceGroupName <String> [<CommonParameters>]
```

### Hostpool
```
Get-AvdApplicationGroup -HostpoolName <String> -HostpoolResourceGroup <String> [<CommonParameters>]
```

### ResourceId
```
Get-AvdApplicationGroup -ResourceId <String> [<CommonParameters>]
```

## DESCRIPTION
With this function you can get information about an AVD application group.

## EXAMPLES

### EXAMPLE 1
```
Get-AvdApplicationGroup -Name applicationGroup -ResourceGroupName "rg-avd-001"
```

### EXAMPLE 2
```
Get-AvdApplicationGroup -ResourceId "/subscriptions/../applicationGroupname"
```

### EXAMPLE 3
```
Get-AvdApplicationGroup -HostpoolName "avd-hostpool" -HostpoolResourceGroup "rg-avd-001"
```

## PARAMETERS

### -Name
{{ Fill Name Description }}

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
Enter the name of the resourcegroup where the application group resides in.

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

### -HostpoolName
Enter the name of the hostpool to look in.

```yaml
Type: String
Parameter Sets: Hostpool
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -HostpoolResourceGroup
Enter the name of the resourcegroup where the hostpool resides in.

```yaml
Type: String
Parameter Sets: Hostpool
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ResourceId
Enter the applicationgroup resourceId.

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
