---
external help file: Az.Wvd-help.xml
Module Name: Az.Wvd
online version:
schema: 2.0.0
---

# Get-WvdImageVersionStatus

## SYNOPSIS
Gets the image version from where the session host is started from.

## SYNTAX

### Hostpool (Default)
```
Get-WvdImageVersionStatus -HostpoolName <String> -ResourceGroupName <String> [-NotLatest] [<CommonParameters>]
```

### Sessionhost
```
Get-WvdImageVersionStatus -HostpoolName <String> -ResourceGroupName <String> [-SessionHostName <String>]
 [-NotLatest] [<CommonParameters>]
```

## DESCRIPTION
The function will help you getting insights if there are session hosts started from an old version in relation to the Shared Image Gallery

## EXAMPLES

### EXAMPLE 1
```
Get-WvdImageVersionStatus -WvdHostpoolName wvd-hostpool -ResourceGroupName wvd-resourcegroup
Get-AzWvdHostpool -WvdHostpoolName wvd-hostpool -ResourceGroupName wvd-resourcegroup | Get-WvdImageVersionStatus
```

## PARAMETERS

### -HostpoolName
Enter the WVD Hostpool name

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
Enter the WVD Hostpool resourcegroup name

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

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -NotLatest
This is a switch parameter which let you control the output to show only the sessionhosts which are not started from the latest version.

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
