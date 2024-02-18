---
external help file: Az.Avd-help.xml
Module Name: Az.Avd
online version:
schema: 2.0.0
---

# Remove-AvdWorkspace

## SYNOPSIS
Removes a new Azure Virtual Desktop workspace.

## SYNTAX

### Name (Default)
```
Remove-AvdWorkspace -Name <String> -ResourceGroupName <String> [<CommonParameters>]
```

### ResourceId
```
Remove-AvdWorkspace -ResourceId <String> [<CommonParameters>]
```

## DESCRIPTION
The function will remove Azure Virtual Desktop workspace.

## EXAMPLES

### EXAMPLE 1
```
Remove-AvdWorkspace -workspacename avd-workspace -resourceGroupName rg-avd-01
```

### EXAMPLE 2
```
Remove-AvdWorkspace -Id /../resourcegroups/resourceId
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
Enter the AVD Hostpool resourcegroup name

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
Enter the Azure location

```yaml
Type: String
Parameter Sets: ResourceId
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
