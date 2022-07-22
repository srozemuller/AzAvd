---
external help file: Az.Avd-help.xml
Module Name: Az.Avd
online version:
schema: 2.0.0
---

# Get-AvdSessionHostResources

## SYNOPSIS
Gets the Azure resources from a AVD Session Host

## SYNTAX

### All (Default)
```
Get-AvdSessionHostResources -HostpoolName <String> -ResourceGroupName <String> [<CommonParameters>]
```

### Hostname
```
Get-AvdSessionHostResources -HostpoolName <String> -ResourceGroupName <String> -Name <String>
 [<CommonParameters>]
```

### Resource
```
Get-AvdSessionHostResources -Id <String> [<CommonParameters>]
```

## DESCRIPTION
The function will help you getting the associated Azure resource information which is behind the AVD Session Host

## EXAMPLES

### EXAMPLE 1
```
Get-AvdSessionHostResources -Hostpoolname avd-hostpool -ResourceGroup rg-avd-01
```

### EXAMPLE 2
```
Get-AvdSessionHostResources -Hostpoolname avd-hostpool -ResourceGroup rg-avd-01 -Name avd-0
```

### EXAMPLE 3
```
Get-AvdSessionHostResources -Id sessionhostId
```

## PARAMETERS

### -HostpoolName
Enter the AVD hostpool name

```yaml
Type: String
Parameter Sets: All, Hostname
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ResourceGroupName
Enter the AVD hostpool resourcegroup

```yaml
Type: String
Parameter Sets: All, Hostname
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
Parameter Sets: Hostname
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
Parameter Sets: Resource
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
