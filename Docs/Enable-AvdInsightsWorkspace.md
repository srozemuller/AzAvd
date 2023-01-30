---
external help file: Az.Avd-help.xml
Module Name: Az.Avd
online version:
schema: 2.0.0
---

# Enable-AvdInsightsWorkspace

## SYNOPSIS
Enables the AVD Diagnostics and will send it to a new LogAnalytics workspace

## SYNTAX

### Id (Default)
```
Enable-AvdInsightsWorkspace -Id <String> -LAWorkspace <String> -LaResourceGroupName <String>
 [-AdditionalCategories <Array>] -DiagnosticsName <String> [<CommonParameters>]
```

### Create-Friendly
```
Enable-AvdInsightsWorkspace -HostpoolName <String> -ResourceGroupName <String> -LAWorkspace <String>
 [-LASku <String>] -LaResourceGroupName <String> -LaLocation <String> [-AdditionalCategories <Array>]
 -RetentionInDays <Int32> -DiagnosticsName <String> [-AutoCreate] [<CommonParameters>]
```

### HostpoolLevel
```
Enable-AvdInsightsWorkspace -HostpoolName <String> -ResourceGroupName <String> -LAWorkspace <String>
 -LaResourceGroupName <String> [-AdditionalCategories <Array>] -DiagnosticsName <String> [<CommonParameters>]
```

### Create-Id
```
Enable-AvdInsightsWorkspace -Id <String> -LAWorkspace <String> [-LASku <String>] -LaResourceGroupName <String>
 -LaLocation <String> [-AdditionalCategories <Array>] -RetentionInDays <Int32> -DiagnosticsName <String>
 [-AutoCreate] [<CommonParameters>]
```

### Create-SingleLevel
```
Enable-AvdInsightsWorkspace -WorkspaceName <String> -WorkspaceResourceGroup <String> -LAWorkspace <String>
 [-LASku <String>] -LaResourceGroupName <String> -LaLocation <String> -AdditionalCategories <Array>
 -RetentionInDays <Int32> -DiagnosticsName <String> [-AutoCreate] [<CommonParameters>]
```

### SingleLevel
```
Enable-AvdInsightsWorkspace -WorkspaceName <String> -WorkspaceResourceGroup <String> -DiagnosticsName <String>
 [<CommonParameters>]
```

## DESCRIPTION
The function will enable AVD diagnostics for a workspace.
It will create a new Log Analytics workspace if no existing workspace is provided.

## EXAMPLES

### EXAMPLE 1
```
Enable-AvdInsightsWorkspace -HostPoolName avd-hostpool-001 -ResourceGroupName rg-avd-001 -LAWorkspace 'la-avd-workspace' -AdditionalCategories ("ConnectionGraphicsData","NetworkData") -DiagnosticsName "AvdInsights"
```

### EXAMPLE 2
```
Enable-AvdInsightsWorkspace -WorkspaceName avd-workspace-001 -WorkspaceResourceGroup rg-avd-001 -LAWorkspace 'la-avd-workspace' -AdditionalCategories ("ConnectionGraphicsData","NetworkData") -DiagnosticsName "AvdInsights"
```

### EXAMPLE 3
```
Enable-AvdInsightsWorkspace -Id /subscription/../workspace/avd-workspace -LAWorkspace 'la-avd-workspace' -AdditionalCategories ("ConnectionGraphicsData","NetworkData") -LaResourceGroupName 'la-rg' -LaLocation 'westeurope' -RetentionInDays 30 -AutoCreate -DiagnosticsName "AvdInsights"
```

## PARAMETERS

### -HostpoolName
{{ Fill HostpoolName Description }}

```yaml
Type: String
Parameter Sets: Create-Friendly, HostpoolLevel
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
Parameter Sets: Create-Friendly, HostpoolLevel
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
Parameter Sets: Id
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

```yaml
Type: String
Parameter Sets: Create-Id
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -WorkspaceName
Enter the name of the hostpool you want to enable start vm on connnect.

```yaml
Type: String
Parameter Sets: Create-SingleLevel, SingleLevel
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WorkspaceResourceGroup
{{ Fill WorkspaceResourceGroup Description }}

```yaml
Type: String
Parameter Sets: Create-SingleLevel, SingleLevel
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
Parameter Sets: Id, Create-Friendly, HostpoolLevel, Create-Id, Create-SingleLevel
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
Parameter Sets: Create-Friendly, Create-Id, Create-SingleLevel
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
Parameter Sets: Id, Create-Friendly, HostpoolLevel, Create-Id, Create-SingleLevel
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -LaLocation
{{ Fill LaLocation Description }}

```yaml
Type: String
Parameter Sets: Create-Friendly, Create-Id, Create-SingleLevel
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AdditionalCategories
The categories you like extra to save in Log Analytics, beside the mandatory categories for AVD Insights.

```yaml
Type: Array
Parameter Sets: Id, Create-Friendly, HostpoolLevel, Create-Id
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

```yaml
Type: Array
Parameter Sets: Create-SingleLevel
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
Parameter Sets: Create-Friendly, Create-Id, Create-SingleLevel
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -DiagnosticsName
{{ Fill DiagnosticsName Description }}

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

### -AutoCreate
Use this switch to auto create a Log Analtyics Workspace

```yaml
Type: SwitchParameter
Parameter Sets: Create-Friendly, Create-Id, Create-SingleLevel
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
