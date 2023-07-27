---
external help file: Az.Avd-help.xml
Module Name: Az.Avd
online version:
schema: 2.0.0
---

# New-AvdWorkbook

## SYNOPSIS
Creates a new workbook for AVD

## SYNTAX

```
New-AvdWorkbook [-ResourceGroupName] <String> [-WorkbookName] <String> [-WorkbookDescription] <String>
 [-Location] <String> [-Template] <String> [<CommonParameters>]
```

## DESCRIPTION
Creates a new AVD workbook based on a provided template.

## EXAMPLES

### EXAMPLE 1
```
New-AvdWorkbook -ResourceGroupName rg01 -Location westeurope -WorkbookName generalAvd -WorkbookDescription "All AVD Info" -Template ./AVDWorkbooks/generalEnvironment.json
```

## PARAMETERS

### -ResourceGroupName
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

### -WorkbookName
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

### -WorkbookDescription
Enter the hostpool ResourceId

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Location
{{ Fill Location Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Template
The workbook template in JSON format

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 5
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
