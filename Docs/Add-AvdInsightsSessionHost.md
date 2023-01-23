---
external help file: Az.Avd-help.xml
Module Name: Az.Avd
online version:
schema: 2.0.0
---

# Add-AvdInsightsSessionHost

## SYNOPSIS
Adds an AVD session host to the AVD Insights workbook.

## SYNTAX

### Id (Default)
```
Add-AvdInsightsSessionHost -Id <String> -WorkSpaceId <String> [<CommonParameters>]
```

### WorkspaceName
```
Add-AvdInsightsSessionHost -Id <String> -LAWorkspace <String> -LaResourceGroupName <String>
 [<CommonParameters>]
```

## DESCRIPTION
The function will install the needed extensions on the AVD session host.

## EXAMPLES

### EXAMPLE 1
```
Add-AvdInsightsSessionHost -Id /subscriptions/../sessionhosts/avd-0 -WorkSpaceId /subscriptions/../Microsoft.OperationalInsights/workspaces/laworkspace
```

### EXAMPLE 2
```
Add-AvdInsightsSessionHost -Id /subscriptions/../sessionhosts/avd-0 -LAWorkspace laworkspace -LaResourceGroupName rg-la-01
```

## PARAMETERS

### -Id
Enter the session host's resource ID (Not VM, use Get-AvdSessionHost or Get-AvdSessionHostResources to get the ID).

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -WorkSpaceId
Enter the Log Analytics Workspace's resource ID.

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
Parameter Sets: WorkspaceName
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -LaResourceGroupName
Enter the name of the Log Analyics Workspace resource group

```yaml
Type: String
Parameter Sets: WorkspaceName
Aliases:

Required: True
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
