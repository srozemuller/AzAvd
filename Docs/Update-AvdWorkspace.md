---
external help file: Az.Avd-help.xml
Module Name: Az.Avd
online version:
schema: 2.0.0
---

# Update-AvdWorkspace

## SYNOPSIS
Updates a new Azure Virtual Desktop workspace.

## SYNTAX

### Name (Default)
```
Update-AvdWorkspace -Name <String> -ResourceGroupName <String> -location <String> [-friendlyName <String>]
 [-description <String>] [-ApplicationGroupReference <Array>] [<CommonParameters>]
```

### ResourceId
```
Update-AvdWorkspace -ResourceId <String> -location <String> [-friendlyName <String>] [-description <String>]
 [-ApplicationGroupReference <Array>] [<CommonParameters>]
```

## DESCRIPTION
The function will update an existing Azure Virtual Desktop workspace.

## EXAMPLES

### EXAMPLE 1
```
Update-AvdWorkspace -name avd-workspace -resourceGroupName rg-avd-01 -location WestEurope -description "Work in space"
```

### EXAMPLE 2
```
Update-AvdWorkspace -name avd-workspace -resourceGroupName rg-avd-01 -location WestEurope -ApplicationGroupReference @("id_1","id_2")
```

### EXAMPLE 3
```
Update-AvdWorkspace -resourceId "/subscriptions/../workspacename" -location WestEurope -ApplicationGroupReference @("id_1","id_2")
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
{{ Fill ResourceId Description }}

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

### -location
Enter the Azure location

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

### -friendlyName
Change the workspace friendly name

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -description
Enter a description

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ApplicationGroupReference
Provide the application group resource IDs where the workspace assign to.

```yaml
Type: Array
Parameter Sets: (All)
Aliases:

Required: False
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
