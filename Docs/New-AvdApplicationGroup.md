---
external help file: Az.Avd-help.xml
Module Name: Az.Avd
online version:
schema: 2.0.0
---

# New-AvdApplicationGroup

## SYNOPSIS
Creates a new AVD applicationgroup.

## SYNTAX

```
New-AvdApplicationGroup [-Name] <String> [[-Description] <String>] [[-FriendlyName] <String>]
 [-ResourceGroupName] <String> [-Location] <String> [[-Tags] <Object>] [-HostPoolArmPath] <String>
 [[-WorkspaceResourceId] <String>] [-ApplicationGroupType] <String> [<CommonParameters>]
```

## DESCRIPTION
With this function you can create a new AVD application group.

## EXAMPLES

### EXAMPLE 1
```
New-AvdApplicationGroup -Name applicationGroupname -ResourceGroupName rg-avd-001 -location WestEurope -ApplicationGroupType Desktop -HostPoolArmPath "/resourceID"
```

### EXAMPLE 2
```
New-AvdApplicationGroup -Name applicationGroupname -ResourceGroupName rg-avd-001 -location WestEurope -ApplicationGroupType Desktop -tags @{tag="value"}
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

### -Description
Enter the description of the application group.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -FriendlyName
Enter the friendlyName of the application group.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ResourceGroupName
Enter the name of the resourcegroup where to deploy the application group.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Location
Enter the location where to deploy application group.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Tags
If the resource needs tags, enter them in here.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -HostPoolArmPath
{{ Fill HostPoolArmPath Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 7
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WorkspaceResourceId
If there is a workspace allready, fill in the workspace resource ID where to assign the application group to.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 8
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ApplicationGroupType
{{ Fill ApplicationGroupType Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 9
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
