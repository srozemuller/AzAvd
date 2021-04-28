---
external help file: Az.Wvd-help.xml
Module Name: Az.Wvd
online version:
schema: 2.0.0
---

# Get-WvdSessionHostResources

## SYNOPSIS
Gets the Virtual Machines Azure resource from a WVD Session Host

## SYNTAX

### Sessionhost
```
Get-WvdSessionHostResources -HostpoolName <String> -ResourceGroupName <String> -SessionHostName <String>
 [<CommonParameters>]
```

### Hostpool
```
Get-WvdSessionHostResources -HostpoolName <String> -ResourceGroupName <String> [<CommonParameters>]
```

## DESCRIPTION
The function will help you getting the virtual machine resource information which is behind the WVD Session Host

## EXAMPLES

### EXAMPLE 1
```
Get-WvdSessionHostResources -SessionHost SessionHostObject
Add a comment to existing incidnet
```

## PARAMETERS

### -HostpoolName
{{ Fill HostpoolName Description }}

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

### -ResourceGroupName
{{ Fill ResourceGroupName Description }}

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

### -SessionHostName
{{ Fill SessionHostName Description }}

```yaml
Type: String
Parameter Sets: Sessionhost
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
