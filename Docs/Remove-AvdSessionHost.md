---
external help file: Az.Avd-help.xml
Module Name: Az.Avd
online version:
schema: 2.0.0
---

# Remove-AvdSessionHost

## SYNOPSIS
Removing sessionhosts from an Azure Virtual Desktop hostpool.

## SYNTAX

### HostName (Default)
```
Remove-AvdSessionHost [<CommonParameters>]
```

### Hostname
```
Remove-AvdSessionHost -HostpoolName <String> -ResourceGroupName <String> -Name <String> [-DeleteAssociated]
 [<CommonParameters>]
```

### All
```
Remove-AvdSessionHost -HostpoolName <String> -ResourceGroupName <String> [-DeleteAssociated] [-Force]
 [<CommonParameters>]
```

### Resource
```
Remove-AvdSessionHost -Id <String> [-DeleteAssociated] [<CommonParameters>]
```

## DESCRIPTION
The function will search for sessionhosts and will remove them from the Azure Virtual Desktop hostpool.

## EXAMPLES

### EXAMPLE 1
```
Remove-AvdSessionHost -HostpoolName avd-hostpool-personal -ResourceGroupName rg-avd-01 -SessionHostName avd-host-1.avd.domain
```

## PARAMETERS

### -HostpoolName
Enter the AVD Hostpool name

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
Enter the AVD Hostpool resourcegroup name

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

### -DeleteAssociated
{{ Fill DeleteAssociated Description }}

```yaml
Type: SwitchParameter
Parameter Sets: Hostname, All, Resource
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Force
{{ Fill Force Description }}

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
