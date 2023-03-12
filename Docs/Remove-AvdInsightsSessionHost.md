---
external help file: Az.Avd-help.xml
Module Name: Az.Avd
online version:
schema: 2.0.0
---

# Remove-AvdInsightsSessionHost

## SYNOPSIS
Removes the AVD session host from AVD Insights.

## SYNTAX

### HostName (Default)
```
Remove-AvdInsightsSessionHost [<CommonParameters>]
```

### Hostname
```
Remove-AvdInsightsSessionHost -HostpoolName <String> -ResourceGroupName <String> -Name <String>
 [<CommonParameters>]
```

### All
```
Remove-AvdInsightsSessionHost -HostpoolName <String> -ResourceGroupName <String> [-Force] [<CommonParameters>]
```

### Resource
```
Remove-AvdInsightsSessionHost -Id <String> [<CommonParameters>]
```

## DESCRIPTION
The function will removed the monitoring extension from the session host.

## EXAMPLES

### EXAMPLE 1
```
Remove-AvdInsightsSessionHost -HostPoolName avd-hostpool-001 -ResourceGroupName rg-avd-001 -Force
```

### EXAMPLE 2
```
Remove-AvdInsightsSessionHost -HostPoolName avd-hostpool-001 -ResourceGroupName rg-avd-001 -Name avd-0
```

### EXAMPLE 3
```
Remove-AvdInsightsSessionHost -Id /subscriptions/../sessionhosts/avd-0
```

## PARAMETERS

### -HostpoolName
Enter the name of the AVD hostpool's name.

```yaml
Type: String
Parameter Sets: Hostname, All
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
Parameter Sets: Hostname, All
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
Enter the name of the session host.

```yaml
Type: String
Parameter Sets: Hostname
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Id
Enter the session host's resource ID (NOT VM).

```yaml
Type: String
Parameter Sets: Resource
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Force
Use this switch to force delete ALL session hosts from AVD Insights

```yaml
Type: SwitchParameter
Parameter Sets: All
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
