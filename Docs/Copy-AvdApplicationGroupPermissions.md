---
external help file: Az.Avd-help.xml
Module Name: Az.Avd
online version:
schema: 2.0.0
---

# Copy-AvdApplicationGroupPermissions

## SYNOPSIS
Copies application group permissions to another application group

## SYNTAX

### Name (Default)
```
Copy-AvdApplicationGroupPermissions -FromApplicationGroupName <String> -FromResourceGroupName <String>
 -ToApplicationGroupName <String> -ToResourceGroupName <String> [<CommonParameters>]
```

### ResourceId
```
Copy-AvdApplicationGroupPermissions -FromAppGroupId <String> -ToAppGroupId <String> [<CommonParameters>]
```

## DESCRIPTION
The function will help you copy permissions to another application group.
This based on an existing one.

## EXAMPLES

### EXAMPLE 1
```
Copy-AvdApplicationGroupPermissions -FromApplicationGroupName avd-appgroup-1 -FromResourceGroupName rg-avd-01 -ToApplicationGroupName avd-appgroup-2 -ToResourceGroupName rg-avd-01
```

### EXAMPLE 2
```
Copy-AvdApplicationGroupPermissions -FromAppGroupId "/subscriptions/.../FromAppgroup" -ToAppGroupId "/subscriptions/.../ToAppgroup"
```

## PARAMETERS

### -FromApplicationGroupName
Enter the AVD source application group name

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

### -FromResourceGroupName
Enter the AVD source application group resourcegroup name

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

### -ToApplicationGroupName
Enter the AVD destination application group name

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

### -ToResourceGroupName
Enter the AVD destination application group resourcegroup name

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

### -FromAppGroupId
Enter the AVD source application group resourceId

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

### -ToAppGroupId
Enter the AVD new application group resourceId

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
