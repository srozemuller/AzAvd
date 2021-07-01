---
external help file: Az.Avd-help.xml
Module Name: Az.Avd
online version:
schema: 2.0.0
---

# Export-AvdConfig

## SYNOPSIS
Exports the WVD environment, based on the hostpool name.

## SYNTAX

### FileExport (Default)
```
Export-AvdConfig -HostpoolName <String> -ResourceGroupName <String> -FileName <String> -Format <Array>
 [<CommonParameters>]
```

### Console
```
Export-AvdConfig -HostpoolName <String> -ResourceGroupName <String> [-Console] [<CommonParameters>]
```

## DESCRIPTION
The function will help you exporting the complete WVD environment to common output types as HTML and CSV.

## EXAMPLES

### EXAMPLE 1
```
Export-WvdConfig -Hostpoolname wvd-hostpool-001 -ResourceGroupName rg-wvd-001 -Format HTML -Verbose -Filename WVDExport
```

### EXAMPLE 2
```
Export-WvdConfig -HostPoolName wvd-hostpool-001 -ResourceGroupName rg-wvd-001 -Format HTML,JSON -Verbose -Filename WVDExport
```

## PARAMETERS

### -HostpoolName
Enter the WVD hostpoolname name.

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
Enter the WVD hostpool resource group name.

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

### -FileName
Enter the filename.
Based on the format parameter the function will create a correct file.
Default filepath is in the execution directory.

```yaml
Type: String
Parameter Sets: FileExport
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Format
Enter the format you like.
For creating more formats use a comma.

```yaml
Type: Array
Parameter Sets: FileExport
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Console
{{ Fill Console Description }}

```yaml
Type: SwitchParameter
Parameter Sets: Console
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
