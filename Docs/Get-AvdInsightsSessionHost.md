---
external help file: Az.Avd-help.xml
Module Name: Az.Avd
online version:
schema: 2.0.0
---

# Get-AvdInsightsSessionHost

## SYNOPSIS
Adds an AVD session host to the AVD Insights workbook.

## SYNTAX

### WorkspaceName (Default)
```
Get-AvdInsightsSessionHost -HostpoolName <String> -ResourceGroupName <String> [-Name <String>]
 -LAWorkspace <String> -LaResourceGroupName <String> [-Missing] [<CommonParameters>]
```

### WorkspaceId
```
Get-AvdInsightsSessionHost -HostpoolName <String> -ResourceGroupName <String> [-Name <String>]
 -WorkSpaceId <String> [-Missing] [<CommonParameters>]
```

### WorkspaceNameResourceId
```
Get-AvdInsightsSessionHost -Id <String> -LAWorkspace <String> -LaResourceGroupName <String> [-Missing]
 [<CommonParameters>]
```

### WorkspaceResourceId
```
Get-AvdInsightsSessionHost -Id <String> -WorkSpaceId <String> [-Missing] [<CommonParameters>]
```

## DESCRIPTION
The function will install the needed extensions on the AVD session host.

## EXAMPLES

### EXAMPLE 1
```
Get-AvdInsightsSessionHost -Id /subscriptions/../sessionhosts/avd-0 -WorkSpaceId /subscriptions/../Microsoft.OperationalInsights/workspaces/laworkspace
```

### EXAMPLE 2
```
Get-AvdInsightsSessionHost -Id /subscriptions/../sessionhosts/avd-0 -LAWorkspace laworkspace -LaResourceGroupName rg-la-01
```

## PARAMETERS

### -HostpoolName
{{ Fill HostpoolName Description }}

```yaml
Type: String
Parameter Sets: WorkspaceName, WorkspaceId
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ResourceGroupName
{{ Fill ResourceGroupName Description }}

```yaml
Type: String
Parameter Sets: WorkspaceName, WorkspaceId
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
{{ Fill Name Description }}

```yaml
Type: String
Parameter Sets: WorkspaceName, WorkspaceId
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Id
{{ Fill Id Description }}

```yaml
Type: String
Parameter Sets: WorkspaceNameResourceId, WorkspaceResourceId
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WorkSpaceId
Enter the Log Analytics Workspace's resource ID.

```yaml
Type: String
Parameter Sets: WorkspaceId, WorkspaceResourceId
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
Parameter Sets: WorkspaceName, WorkspaceNameResourceId
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
Parameter Sets: WorkspaceName, WorkspaceNameResourceId
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Missing
{{ Fill Missing Description }}

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
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
