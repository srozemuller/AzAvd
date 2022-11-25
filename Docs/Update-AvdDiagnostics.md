---
external help file: Az.Avd-help.xml
Module Name: Az.Avd
online version:
schema: 2.0.0
---

# Update-AvdDiagnostics

## SYNOPSIS
Updates the AVD Diagnostics settings to an another LogAnalytics workspace or categories.

## SYNTAX

### Category (Default)
```
Update-AvdDiagnostics -HostpoolName <String> -ResourceGroupName <String> [-DiagnosticsName <String>]
 -Categories <Array> [<CommonParameters>]
```

### LAWS
```
Update-AvdDiagnostics -HostpoolName <String> -ResourceGroupName <String> -LAWorkspace <String>
 -LaResourceGroupName <String> [-DiagnosticsName <String>] [-Categories <Array>] [<CommonParameters>]
```

## DESCRIPTION
This command will help you updating the Log Analytics workspace or adding/removing log catagories.

## EXAMPLES

### EXAMPLE 1
```
Update-AvdDiagnostics -HostPoolName avd-hostpool-001 -ResourceGroupName rg-avd-001 -AvdWorkspace avd-workpace-001 -DiagnosticsName
```

## PARAMETERS

### -HostpoolName
Enter the name of the hostpool you want to enable start vm on connnect.

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
Enter the name of the resourcegroup where the hostpool resides in.

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

### -LAWorkspace
Enter the name of the Log Analytics Workspace

```yaml
Type: String
Parameter Sets: LAWS
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -LaResourceGroupName
{{ Fill LaResourceGroupName Description }}

```yaml
Type: String
Parameter Sets: LAWS
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DiagnosticsName
{{ Fill DiagnosticsName Description }}

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

### -Categories
{{ Fill Categories Description }}

```yaml
Type: Array
Parameter Sets: Category
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

```yaml
Type: Array
Parameter Sets: LAWS
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
