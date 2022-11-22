---
external help file: Az.Avd-help.xml
Module Name: Az.Avd
online version:
schema: 2.0.0
---

# Add-AvdSessionHostTags

## SYNOPSIS
Add tags to the session host's VM resource

## SYNTAX

### Id (Default)
```
Add-AvdSessionHostTags -Id <String> -Tags <Object> [<CommonParameters>]
```

### Name
```
Add-AvdSessionHostTags -HostpoolName <String> -ResourceGroupName <String> -SessionHostName <String>
 -Tags <Object> [<CommonParameters>]
```

## DESCRIPTION
Based on the session host name, remove tags to the VM resource.

## EXAMPLES

### EXAMPLE 1
```
Add-AvdSessionHostTags -HostpoolName avd-hostpool -ResourceGroupName rg-avd-01 -SessionHostName avd-hostpool/avd-host-1.avd.domain -Tags @{Tag="Value"}
```

### EXAMPLE 2
```
Add-AvdSessionHostTags -Id /subscriptions/...
```

## PARAMETERS

### -HostpoolName
Enter the AVD hostpool name

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
Enter the AVD hostpool resourcegroup name

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

### -Id
Enter the sessionhost's resource ID

```yaml
Type: String
Parameter Sets: Id
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -SessionHostName
Enter the sessionhost's name like avd-hostpool/avd-host-1.avd.domain

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

### -Tags
Enter the tags to add.
Provide an object.

```yaml
Type: Object
Parameter Sets: (All)
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
