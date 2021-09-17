---
external help file: Az.Avd-help.xml
Module Name: Az.Avd
online version:
schema: 2.0.0
---

# Get-AvdHostPoolInfo

## SYNOPSIS
Get AVD Hostpool information, including the underlaying session hosts

## SYNTAX

```
Get-AvdHostPoolInfo [-HostPoolName] <String> [-ResourceGroupName] <String> [<CommonParameters>]
```

## DESCRIPTION
With this function you can get information about a AVD hostpool that includes the information about the underlaying session hosts.

## EXAMPLES

### EXAMPLE 1
```
Get-AVDHostPoolInfo -HostPoolName AVD-hostpool-001 -ResourceGroupName rg-AVD-001
```

## PARAMETERS

### -HostPoolName
Enter the name of the hostpool you want information from.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ResourceGroupName
Enter the name of the resourcegroup where the hostpool resides in.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
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
