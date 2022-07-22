---
external help file: Az.Avd-help.xml
Module Name: Az.Avd
online version:
schema: 2.0.0
---

# Update-AvdScheduledAgentsUpdate

## SYNOPSIS
Updates the scheduled agents update settings.

## SYNTAX

### UserLocalTimeZone (Default)
```
Update-AvdScheduledAgentsUpdate -HostpoolName <String> -ResourceGroupName <String> [-TimeZone <String>]
 -DayOfWeek <String> -Hour <Int32> [-Disable] [<CommonParameters>]
```

### AdditionalSchedule
```
Update-AvdScheduledAgentsUpdate -HostpoolName <String> -ResourceGroupName <String> [-TimeZone <String>]
 -DayOfWeek <String> -Hour <Int32> -ExtraDayOfWeek <String> -ExtraHour <Int32> [-Disable] [<CommonParameters>]
```

## DESCRIPTION
Updates the scheduled agents update settings in an Azure Virtual Desktop hostpool.

## EXAMPLES

### EXAMPLE 1
```
Update-AvdScheduledAgentsUpdate -HostpoolName avd-hostpool -ResourceGroupName rg-avd-01 -DayOfWeek Sunday -Hour 2
```

### EXAMPLE 2
```
Update-AvdScheduledAgentsUpdate -HostpoolName avd-hostpool -ResourceGroupName rg-avd-01 -DayOfWeek Sunday -Hour 2 -ExtraDayOfWeek Monday -ExtraHour 5
```

### EXAMPLE 3
```
Update-AvdScheduledAgentsUpdate -HostpoolName avd-hostpool -ResourceGroupName rg-avd-01 -DayOfWeek Sunday -Hour 2 -Timezone "W. Europe Standard Time"
```

## PARAMETERS

### -HostpoolName
Enter the AVD Hostpool name

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
Enter the AVD Hostpool resourcegroup name

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

### -TimeZone
Fill in a custom timezone, otherwise the session host's timezone is used

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DayOfWeek
Monday, Tuesday, etc.

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

### -Hour
Provide an hour between 0-24 hours

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -ExtraDayOfWeek
Extra schedule on Monday, Tuesday, etc.

```yaml
Type: String
Parameter Sets: AdditionalSchedule
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ExtraHour
Extra hour between 0-24

```yaml
Type: Int32
Parameter Sets: AdditionalSchedule
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Disable
Enter this switch parameter to disable the agent update

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
