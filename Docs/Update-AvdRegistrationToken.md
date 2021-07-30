---
external help file: Az.Avd-help.xml
Module Name: Az.Avd
online version:
schema: 2.0.0
---

# Update-AvdRegistrationToken

## SYNOPSIS
Will create a new registration token which you need to onboard new session hosts

## SYNTAX

```
Update-AvdRegistrationToken [-HostpoolName] <String> [-ResourceGroupName] <String> [[-HoursActive] <Int32>]
 [<CommonParameters>]
```

## DESCRIPTION
The function will create a new registration token, if needed, and will return the value which you need to onboard new session hosts

## EXAMPLES

### EXAMPLE 1
```
Update-AvdRegistrationToken -HostpoolName avd-hostpool -ResourceGroupName avd-resourcegroup
Add a comment to existing incidnet
```

## PARAMETERS

### -HostpoolName
Enter the AVD Hostpool name

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -ResourceGroupName
Enter the AVD Hostpool resourcegroup name

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -HoursActive
Optional, give the token availability in hours.
Default 4.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: 4
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
