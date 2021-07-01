---
external help file: Az.Avd-help.xml
Module Name: Az.Avd
online version:
schema: 2.0.0
---

# Enable-AvdDiagnostics

## SYNOPSIS
Enables the AVD Diagnostics and will send it to a new LogAnalytics workspace

## SYNTAX

### Existing (Default)
```
Enable-AvdDiagnostics [-HostpoolName <String>] [-ResourceGroupName <String>] [-AvdWorkspace <String>]
 [-LAWorkspace <String>] [-LaResourceGroupName <String>] [-Categories <Array>] [<CommonParameters>]
```

### Initial
```
Enable-AvdDiagnostics [-HostpoolName <String>] [-ResourceGroupName <String>] [-AvdWorkspace <String>]
 [-LAWorkspace <String>] [-LASku <String>] [-LaResourceGroupName <String>] [-diagnosticsName <String>]
 [-Categories <Array>] [-RetentionInDays <Int32>] [<CommonParameters>]
```

## DESCRIPTION
The function will enable AVD diagnostics for a hostpool. It will create a new Log Analytics workspace if no existing workspace is provided.

## EXAMPLES

### EXAMPLE 1
```
Enable-AvdDiagnostics -HostPoolName avd-hostpool-001 -ResourceGroupName rg-avd-001 -AvdWorkspace avd-workpace-001
```

## PARAMETERS

### -HostpoolName
Enter the name of the hostpool you want to enable start vm on connnect.

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

### -ResourceGroupName
Enter the name of the resourcegroup where the hostpool resides in.

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

### -AvdWorkspace
{{ Fill AvdWorkspace Description }}

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

### -LAWorkspace
Enter the name of the Log Analytics Workspace

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

### -LASku
{{ Fill LASku Description }}

```yaml
Type: String
Parameter Sets: Initial
Aliases:

Required: False
Position: Named
Default value: Standard
Accept pipeline input: False
Accept wildcard characters: False
```

### -LaResourceGroupName
{{ Fill LaResourceGroupName Description }}

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

### -diagnosticsName
{{ Fill diagnosticsName Description }}

```yaml
Type: String
Parameter Sets: Initial
Aliases:

Required: False
Position: Named
Default value: AVD-Diagnostics
Accept pipeline input: False
Accept wildcard characters: False
```

### -Categories
{{ Fill Categories Description }}

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

### -RetentionInDays
{{ Fill RetentionInDays Description }}

```yaml
Type: Int32
Parameter Sets: Initial
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
