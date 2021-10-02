---
external help file: Az.Avd-help.xml
Module Name: Az.Avd
online version:
schema: 2.0.0
---

# Update-AvdDesktopApplication

## SYNOPSIS
Updates the Virtual Desktop ApplicationGroup desktop application

## SYNTAX

### Name (Default)
```
Update-AvdDesktopApplication -ApplicationGroupName <String> -ResourceGroupName <String> [-description <String>]
 [-friendlyName <String>] [<CommonParameters>]
```

### ResourceId
```
Update-AvdDesktopApplication -ResourceId <String> [-description <String>] [-friendlyName <String>]
 [<CommonParameters>]
```

## DESCRIPTION
The function will update the desktop application SessionDesktop with a friendlyname and/or displayname.

## EXAMPLES

### EXAMPLE 1
```
Update-AvdDesktopApplication -ApplicationGroupName avd-applicationgroup -ResourceGroupName rg-avd-01 -DisplayName "Update Desktop"
```

### EXAMPLE 2
```
Update-AvdDesktopApplication -ResourceId "/subscriptions/../applicationName" -DisplayName "Update Desktop"
```

## PARAMETERS

### -ApplicationGroupName
Enter the AVD application group name

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
Enter the AVD application group resourcegroup name

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
Enter the AVD application group resourceId

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

### -friendlyName
Provide a displayname, this is the name you see in the webclient and Remote Desktop Client.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
