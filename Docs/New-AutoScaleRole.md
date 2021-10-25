---
external help file: Az.Avd-help.xml
Module Name: az.avd
online version:
schema: 2.0.0
---

# New-AutoScaleRole

## SYNOPSIS
Creates a new RBAC role for AVD autoscaling

## SYNTAX

```
New-AutoScaleRole -RoleName <String> -RoleDescription <String> -ResourceGroupName <String> [-Assign]
 [<CommonParameters>]
```

## DESCRIPTION
The function will create a new RBAC role and assign it at subscription or resourcegroup level.

## EXAMPLES

### EXAMPLE 1
```
New-AutoScaleRole RoleName avd-autoscale RoleDescription "Plan for autoscale session hosts"
```

### EXAMPLE 2
```
New-AutoScaleRole RoleName avd-autoscale RoleDescription "Plan for autoscale session hosts" -resourcegroup rg-avd-001 -Assign
```

## PARAMETERS

### -RoleName
Enter the role name

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

### -RoleDescription
Enter the role description

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
If you like to scope at resourcegroup level, provide the resourcegroup name.
(Default subscription scope)

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

### -Assign
If you like to assign directly, use this switch parameter

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
