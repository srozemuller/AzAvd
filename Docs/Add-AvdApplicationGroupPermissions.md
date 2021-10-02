---
external help file: Az.Avd-help.xml
Module Name: Az.Avd
online version:
schema: 2.0.0
---

# Add-AvdApplicationGroupPermissions

## SYNOPSIS
Adds permissions to an Azure Virtual Desktop Applicationgroup

## SYNTAX

### Name (Default)
```
Add-AvdApplicationGroupPermissions [<CommonParameters>]
```

### User
```
Add-AvdApplicationGroupPermissions -ApplicationGroupName <String> -ResourceGroupName <String>
 [<CommonParameters>]
```

### PrincipalId
```
Add-AvdApplicationGroupPermissions -ApplicationGroupName <String> -ResourceGroupName <String>
 [<CommonParameters>]
```

### Group
```
Add-AvdApplicationGroupPermissions -ApplicationGroupName <String> -ResourceGroupName <String>
 [<CommonParameters>]
```

### ResourceId-PrincipalId
```
Add-AvdApplicationGroupPermissions -resourceId <String> -PrincipalId <String> [<CommonParameters>]
```

### ResourceId-Group
```
Add-AvdApplicationGroupPermissions -resourceId <String> -groupName <String> [<CommonParameters>]
```

### ResourceId-User
```
Add-AvdApplicationGroupPermissions -resourceId <String> -UserPrincipalName <String> [<CommonParameters>]
```

### Name-User
```
Add-AvdApplicationGroupPermissions -UserPrincipalName <String> [<CommonParameters>]
```

### Name-Group
```
Add-AvdApplicationGroupPermissions -groupName <String> [<CommonParameters>]
```

### Name-PrincipalId
```
Add-AvdApplicationGroupPermissions -PrincipalId <String> [<CommonParameters>]
```

## DESCRIPTION
The function will add permissions to an Azure Virtual Desktop Applicationgroup.
This can be a user or a group.

## EXAMPLES

### EXAMPLE 1
```
Add-AvdApplicationGroupPermissions -ApplicationGroupName avd-application-group -ResourceGroupName rg-avd-01 -UserPrincipalName user@domain.com
```

### EXAMPLE 2
```
Add-AvdApplicationGroupPermissions -ApplicationGroupName avd-application-group -ResourceGroupName rg-avd-01 -GroupName "All Users"
```

## PARAMETERS

### -ApplicationGroupName
Enter the AVD application group name

```yaml
Type: String
Parameter Sets: User, PrincipalId, Group
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ResourceGroupName
Enter the AVD application group resourcegroup name

```yaml
Type: String
Parameter Sets: User, PrincipalId, Group
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -resourceId
{{ Fill resourceId Description }}

```yaml
Type: String
Parameter Sets: ResourceId-PrincipalId, ResourceId-Group, ResourceId-User
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -UserPrincipalName
Provide the user principal name (eg.
user@domain.com)

```yaml
Type: String
Parameter Sets: ResourceId-User, Name-User
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -groupName
Provide the group name (eg.
All Users)

```yaml
Type: String
Parameter Sets: ResourceId-Group, Name-Group
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PrincipalId
{{ Fill PrincipalId Description }}

```yaml
Type: String
Parameter Sets: ResourceId-PrincipalId, Name-PrincipalId
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
