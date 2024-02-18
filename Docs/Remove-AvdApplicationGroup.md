---
external help file: Az.Avd-help.xml
Module Name: Az.Avd
online version:
schema: 2.0.0
---

# Remove-AvdApplicationGroup

## SYNOPSIS
Removes an AVD applicationgroup.

## SYNTAX

### All (Default)
```
Remove-AvdApplicationGroup -ResourceGroupName <String> [<CommonParameters>]
```

### Name
```
Remove-AvdApplicationGroup -Name <String> -ResourceGroupName <String> [<CommonParameters>]
```

### ResourceId
```
Remove-AvdApplicationGroup -ResourceId <String> [<CommonParameters>]
```

## DESCRIPTION
With this function you can remove an AVD application group.

## EXAMPLES

### EXAMPLE 1
```
Remove-AvdApplicationGroup -ApplicationGroupName applicationGroup -ResourceGroupName rg-avd-001
```

### EXAMPLE 2
```
Remove-AvdApplicationGroup -ResourceId "/subscriptions/../applicationGroupname"
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
Enter the name of the resourcegroup where the hostpool resides in.

```yaml
Type: String
Parameter Sets: All, Name
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
