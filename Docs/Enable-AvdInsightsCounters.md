---
external help file: Az.Avd-help.xml
Module Name: Az.Avd
online version:
schema: 2.0.0
---

# Enable-AvdInsightsCounters

## SYNOPSIS
Create sources in a (new) LogAnalytics workspace

## SYNTAX

### Id (Default)
```
Enable-AvdInsightsCounters -Id <String> [<CommonParameters>]
```

### Create-Friendly
```
Enable-AvdInsightsCounters -LAWorkspace <String> [-LASku <String>] -LaResourceGroupName <String>
 -LaLocation <String> -RetentionInDays <Int32> [-AutoCreate] [<CommonParameters>]
```

### WorkspaceName
```
Enable-AvdInsightsCounters -LAWorkspace <String> -LaResourceGroupName <String> [<CommonParameters>]
```

## DESCRIPTION
The function creates the needed sources in a Log Analytics workspace for AVD Insights.

## EXAMPLES

### EXAMPLE 1
```
Enable-AvdInsightsCounters -Id /subscription/../workspaces/la-workspace
```

### EXAMPLE 2
```
Enable-AvdInsightsCounters -LAWorkspace 'la-avd-workspace' -LaResourceGroupName 'rg-la-01'
```

### EXAMPLE 3
```
Enable-AvdInsightsCounters -LAWorkspace 'la-avd-workspace' -LaResourceGroupName 'rg-la-01' -LaSku 'standard' -LaLocation 'WestEurope' -RetentionInDays 30 -Autocreate
```

## PARAMETERS

### -Id
Enter the Log Analytics Workspace's resource ID.

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

### -LAWorkspace
Enter the name of the Log Analytics Workspace

```yaml
Type: String
Parameter Sets: Create-Friendly, WorkspaceName
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
Parameter Sets: Create-Friendly
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
Parameter Sets: Create-Friendly, WorkspaceName
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
Parameter Sets: Create-Friendly
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
Parameter Sets: Create-Friendly
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
Parameter Sets: Create-Friendly
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
