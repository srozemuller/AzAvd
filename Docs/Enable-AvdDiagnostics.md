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

### Friendly (Default)
```
Enable-AvdDiagnostics -HostpoolName <String> -ResourceGroupName <String> -LAWorkspace <String>
 -LaResourceGroupName <String> [-DiagnosticsName <String>] -Categories <Array> [<CommonParameters>]
```

### Create-Friendly
```
Enable-AvdDiagnostics -HostpoolName <String> -ResourceGroupName <String> -LAWorkspace <String>
 [-LASku <String>] -LaResourceGroupName <String> [-DiagnosticsName <String>] -LaLocation <String>
 -Categories <Array> -RetentionInDays <Int32> [-AutoCreate] [<CommonParameters>]
```

### Create-Id
```
Enable-AvdDiagnostics -Id <String> -LAWorkspace <String> [-LASku <String>] -LaResourceGroupName <String>
 [-DiagnosticsName <String>] -LaLocation <String> -Categories <Array> -RetentionInDays <Int32> [-AutoCreate]
 [<CommonParameters>]
```

### Id
```
Enable-AvdDiagnostics -Id <String> -LAWorkspace <String> -LaResourceGroupName <String>
 [-DiagnosticsName <String>] -Categories <Array> [<CommonParameters>]
```

## DESCRIPTION
The function will enable AVD diagnostics for a hostpool.
It will create a new Log Analytics workspace if no existing workspace is provided.

## EXAMPLES

### EXAMPLE 1
```
Enable-AvdDiagnostics -HostPoolName avd-hostpool-001 -ResourceGroupName rg-avd-001 -LAWorkspace 'la-avd-workspace' -Categories ("Checkpoint","Error")
```

### EXAMPLE 2
```
Enable-AvdDiagnostics -Id /subscription/.../ -LAWorkspace 'la-avd-workspace' -Categories ("Checkpoint","Error") -LaResourceGroupName 'la-rg' -LaLocation 'westeurope' -RetentionInDays 30 -AutoCreate
```

## PARAMETERS

### -HostpoolName
Enter the name of the hostpool you want to enable start vm on connnect.

```yaml
Type: String
Parameter Sets: Friendly, Create-Friendly
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
Parameter Sets: Friendly, Create-Friendly
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Id
Enter the host pool's resource ID.

```yaml
Type: String
Parameter Sets: Create-Id
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

```yaml
Type: String
Parameter Sets: Id
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
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -LASku
Enter the name of the Log Analytics SKU

```yaml
Type: String
Parameter Sets: Create-Friendly, Create-Id
Aliases:

Required: False
Position: Named
Default value: Standard
Accept pipeline input: False
Accept wildcard characters: False
```

### -LaResourceGroupName
Enter the name of the Log Analyics Workspace resource group

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

### -DiagnosticsName
The diagnostics name shown in the hostpool diagnostics overview

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: AVD-Diagnostics
Accept pipeline input: False
Accept wildcard characters: False
```

### -LaLocation
{{ Fill LaLocation Description }}

```yaml
Type: String
Parameter Sets: Create-Friendly, Create-Id
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Categories
The categories you like to save in Log Analytics

```yaml
Type: Array
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RetentionInDays
How long should the data be saved

```yaml
Type: Int32
Parameter Sets: Create-Friendly, Create-Id
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -AutoCreate
Use this switch to auto create a Log Analtyics Workspace

```yaml
Type: SwitchParameter
Parameter Sets: Create-Friendly, Create-Id
Aliases:

Required: True
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
