---
external help file: Az.Avd-help.xml
Module Name: Az.Avd
online version:
schema: 2.0.0
---

# Get-AvdDiagnosticSettings

## SYNOPSIS
Gets the AVD Diagnostics settings to an another LogAnalytics workspace or categories.

## SYNTAX

### Name (Default)
```
Get-AvdDiagnosticSettings -HostpoolName <String> -ResourceGroupName <String> [<CommonParameters>]
```

### Id
```
Get-AvdDiagnosticSettings -Id <String> [<CommonParameters>]
```

## DESCRIPTION
This command will help you updating the Log Analytics workspace or adding/removing log catagories.

## EXAMPLES

### EXAMPLE 1
```
Get-AvdDiagnosticSettings -HostPoolName avd-hostpool-001 -ResourceGroupName rg-avd-001
```

### EXAMPLE 2
```
Get-AvdDiagnosticSettings -HostPoolId "/subscriptions/...."
```

## PARAMETERS

### -HostpoolName
Enter the name of the hostpool you want to enable start vm on connnect.

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
Enter the name of the resourcegroup where the hostpool resides in.

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

### -Id
{{ Fill Id Description }}

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
