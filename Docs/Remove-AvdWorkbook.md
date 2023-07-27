---
external help file: Az.Avd-help.xml
Module Name: Az.Avd
online version:
schema: 2.0.0
---

# Remove-AvdWorkbook

## SYNOPSIS
Removes the provided workbook

## SYNTAX

### Name (Default)
```
Remove-AvdWorkbook [-WorkbookName <Array>] [<CommonParameters>]
```

### ResourceId
```
Remove-AvdWorkbook [-Id <String>] [<CommonParameters>]
```

## DESCRIPTION
Removes the workbook that is provided

## EXAMPLES

### EXAMPLE 1
```
Get-AvdWorkbook | Remove-AvdWorkbook
```

### EXAMPLE 2
```
Remove-AvdWorkbook -WorkbookName "Workbook 1"
```

### EXAMPLE 3
```
Remove-AvdWorkbook -WorkbookName @("Workbook 1", "Workbook")
```

## PARAMETERS

### -WorkbookName
Enter the workbook name(s) to remove

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
{{ Fill Id Description }}

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
