---
external help file: Az.Avd-help.xml
Module Name: Az.Avd
online version:
schema: 2.0.0
---

# New-AvdWorkspace

## SYNOPSIS
Creates a new Azure Virtual Desktop workspace.

## SYNTAX

```
New-AvdWorkspace [-Name] <String> [-ResourceGroupName] <String> [-Location] <String> [[-FriendlyName] <String>]
 [[-Description] <String>] [[-ApplicationGroupReference] <Array>] [<CommonParameters>]
```

## DESCRIPTION
The function will create a new Azure Virtual Desktop workspace.

## EXAMPLES

### EXAMPLE 1
```
New-AvdWorkspace -workspacename avd-workspace -resourceGroupName rg-avd-01 -location WestEurope -description "Work in space"
```

### EXAMPLE 2
```
New-AvdWorkspace -workspacename avd-workspace -resourceGroupName rg-avd-01 -location WestEurope -ApplicationGroupReference @("id_1","id_2")
```

## PARAMETERS

### -Name
{{ Fill Name Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ResourceGroupName
Enter the AVD Hostpool resourcegroup name

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Location
Enter the Azure location

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -FriendlyName
Change the workspace friendly name

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Description
Enter a description

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
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
Position: 6
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
