---
external help file: Az.Wvd-help.xml
Module Name: Az.Wvd
online version:
schema: 2.0.0
---

# Get-WvdLatestSessionHost

## SYNOPSIS
Gets the latest session host from the WVD Hostpool

## SYNTAX

### Parameters (Default)
```
Get-WvdLatestSessionHost -HostpoolName <String> -ResourceGroupName <String> [-NumOnly] [<CommonParameters>]
```

### InputObject
```
Get-WvdLatestSessionHost -InputObject <PSObject> [<CommonParameters>]
```

## DESCRIPTION
The function will help you getting the latests session host from a WVD Hostpool. 
By running this function you will able to define the next number for deploying new session hosts.

## EXAMPLES

### EXAMPLE 1
```
Get-WvdLatestSessionHost -WvdHostpoolName wvd-hostpool -ResourceGroupName wvd-resourcegroup
```

## PARAMETERS

### -HostpoolName
Enter the WVD Hostpool name

```yaml
Type: String
Parameter Sets: Parameters
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
Parameter Sets: Parameters
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -NumOnly
With this switch parameter you will set, you will get the next sessionhost number returned.

```yaml
Type: SwitchParameter
Parameter Sets: Parameters
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -InputObject
You can put the hostpool object in here.

```yaml
Type: PSObject
Parameter Sets: InputObject
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
