---
external help file: Az.Avd-help.xml
Module Name: Az.Avd
online version:
schema: 2.0.0
---

# Export-AvdWorkbook

## SYNOPSIS
Exports the provided workbook

## SYNTAX

### Name (Default)
```
Export-AvdWorkbook [-WorkbookName <Array>] [-ExportPath <String>] [<CommonParameters>]
```

### ResourceId
```
Export-AvdWorkbook [-Id <String>] [-ExportPath <String>] [<CommonParameters>]
```

## DESCRIPTION
Exports the workbook to a JSON formatted file on the provided file location

## EXAMPLES

### EXAMPLE 1
```
Get-AvdWorkbook -WorkbookName "Workbook 1" | Export-AvdWorkbook
```

### EXAMPLE 2
```
Export-AvdWorkbook -WorkbookName @("Workbook 1", "Workbook") -ExportPath .\
```

## PARAMETERS

### -WorkbookName
Enter the workbook name(s) to export

```yaml
Type: Array
Parameter Sets: Name
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Id
Enter the workbook resource ID

```yaml
Type: String
Parameter Sets: ResourceId
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -ExportPath
The path to export the JSON files to

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: .\
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
