---
external help file: Az.Avd-help.xml
Module Name: Az.Avd
online version:
schema: 2.0.0
---

# Set-AvdContext

## SYNOPSIS
Set the current setting to a new context.
Context is starting at subscription level.

## SYNTAX

```
Set-AvdContext [-SubscriptionId] <Guid> [<CommonParameters>]
```

## DESCRIPTION
In the case you need to set a new subscription context, use this command.

## EXAMPLES

### EXAMPLE 1
```
Set-AvdContext -SubscriptionId $SubscriptionId
```

## PARAMETERS

### -SubscriptionId
Enter the subscription ID as \<GUID\>.

```yaml
Type: Guid
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
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
