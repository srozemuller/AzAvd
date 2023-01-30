---
external help file: Az.Avd-help.xml
Module Name: Az.Avd
online version:
schema: 2.0.0
---

# Enable-AvdInsightsApplicationGroup

## SYNOPSIS
Enables the AVD Diagnostics and will send it to a new LogAnalytics workspace

## SYNTAX

### Id (Default)
```
Enable-AvdInsightsApplicationGroup -Id <Object> -LAWorkspace <String> -LaResourceGroupName <String>
 -DiagnosticsName <String> [<CommonParameters>]
```

### Create-Friendly
```
Enable-AvdInsightsApplicationGroup -HostpoolName <String> -ResourceGroupName <String> -LAWorkspace <String>
 [-LASku <String>] -LaResourceGroupName <String> -LaLocation <String> -RetentionInDays <Int32>
 -DiagnosticsName <String> [-AutoCreate] [<CommonParameters>]
```

### HostpoolLevel
```
Enable-AvdInsightsApplicationGroup -HostpoolName <String> -ResourceGroupName <String> -LAWorkspace <String>
 -LaResourceGroupName <String> -DiagnosticsName <String> [<CommonParameters>]
```

### Create-Id
```
Enable-AvdInsightsApplicationGroup -Id <Object> -LAWorkspace <String> [-LASku <String>]
 -LaResourceGroupName <String> -LaLocation <String> -RetentionInDays <Int32> -DiagnosticsName <String>
 [-AutoCreate] [<CommonParameters>]
```

### Create-SingleLevel
```
Enable-AvdInsightsApplicationGroup -ApplicationGroupName <String> -ApplicationResourceGroup <String>
 -LAWorkspace <String> [-LASku <String>] -LaResourceGroupName <String> -LaLocation <String>
 -RetentionInDays <Int32> -DiagnosticsName <String> [-AutoCreate] [<CommonParameters>]
```

### SingleLevel
```
Enable-AvdInsightsApplicationGroup -ApplicationGroupName <String> -ApplicationResourceGroup <String>
 -LAWorkspace <String> -LaResourceGroupName <String> [<CommonParameters>]
```

## DESCRIPTION
The function will enable AVD diagnostics for a application group.
It will create a new Log Analytics workspace if no existing workspace is provided.

## EXAMPLES

### EXAMPLE 1
```
Enable-AvdInsightsApplicationGroup -HostPoolName avd-hostpool-001 -ResourceGroupName rg-avd-001 -LAWorkspace 'la-avd-workspace' -LaResourceGroupName 'rg-la-01' -DiagnosticsName "AvdInsights"
```

### EXAMPLE 2
```
Enable-AvdInsightsApplicationGroup -ApplicationGroupName avd-appgroup-01 -ApplicationResourceGroup rg-avd-001 -LAWorkspace 'la-avd-workspace' -LaResourceGroupName 'rg-la-01' -DiagnosticsName "AvdInsights"
```

### EXAMPLE 3
```
Enable-AvdInsightsApplicationGroup -ApplicationGroupName avd-appgroup-01 -ApplicationResourceGroup rg-avd-001 -LAWorkspace 'la-avd-workspace' -LaResourceGroupName 'rg-la-01' -LAWorkspace 'la-avd-workspace' -LaResourceGroupName 'la-rg' -LaLocation 'westeurope' -RetentionInDays 30 -AutoCreate -DiagnosticsName "AvdInsights"
```

### EXAMPLE 4
```
Enable-AvdInsightsApplicationGroup -Id /subscription/../applicationgroup/groupname -LAWorkspace 'la-avd-workspace' -LaResourceGroupName 'la-rg' -LaLocation 'westeurope' -RetentionInDays 30 -AutoCreate -DiagnosticsName "AvdInsights"
```

## PARAMETERS

### -HostpoolName
Enter the name of the hostpool you want to enable start vm on connnect.

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
Enter the application group's resource ID.

```yaml
Type: Object
Parameter Sets: Id
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

```yaml
Type: Object
Parameter Sets: Create-Id
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -ApplicationGroupName
Enter the application group's name.

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

### -ApplicationResourceGroup
Enter the application group's resource group.

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
Parameter Sets: (All)
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
Enter the diagnostics display name

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
