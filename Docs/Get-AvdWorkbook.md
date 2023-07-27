---
external help file: Az.Avd-help.xml
Module Name: Az.Avd
online version:
schema: 2.0.0
---

# Get-AvdWorkbook

## SYNOPSIS
Get all worksbook related to AVD

## SYNTAX

### Name (Default)
```
Get-AvdWorkbook [-WorkbookName <Array>] [-ShowContent] [<CommonParameters>]
```

### ResourceId
```
Get-AvdWorkbook [-WorkbookName <Array>] [-Id <String>] [-ShowContent] [<CommonParameters>]
```

## DESCRIPTION
Searches at subscription level for all workbooks that are assigned to the AVD resource

## EXAMPLES

### EXAMPLE 1
```
Get-AvdWorkbook
```

### EXAMPLE 2
```
Get-AvdWorkbook -WorkbookName "Workbook 1"
```

### EXAMPLE 3
```
Get-AvdWorkbook -WorkbookName @("Workbook 1", "Workbook")
```

## PARAMETERS

### -WorkbookName
Enter the workbook name(s) to search for

```yaml
Type: Array
Parameter Sets: (All)
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
Accept pipeline input: False
Accept wildcard characters: False
```

### -ShowContent
{{ Fill ShowContent Description }}

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
