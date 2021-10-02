---
external help file: Az.Avd-help.xml
Module Name: Az.Avd
online version:
schema: 2.0.0
---

# Get-AvdWorkspace

## SYNOPSIS
Gets a new Azure Virtual Desktop workspace.

## SYNTAX

### Name (Default)
```
Get-AvdWorkspace -Name <String> -ResourceGroupName <String> [<CommonParameters>]
```

### ResourceId
```
Get-AvdWorkspace -ResourceId <String> [<CommonParameters>]
```

## DESCRIPTION
The function will search for a given Azure Virtual Desktop workspace.

## EXAMPLES

### EXAMPLE 1
```
Get-AvdWorkspace -name avd-workspace -resourceGroupName rg-avd-01
```

### EXAMPLE 2
```
Get-AvdWorkspace -resourceId "/subscriptions/../workspacename"
```

## PARAMETERS

### -Name
Enter the AVD workspace name

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
Enter the AVD workspace resourcegroup name

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
Enter the AVD workspace resourceId

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
