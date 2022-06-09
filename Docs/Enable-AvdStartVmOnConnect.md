---
external help file: Az.Avd-help.xml
Module Name: Az.Avd
online version:
schema: 2.0.0
---

# Enable-AvdStartVmOnConnect

## SYNOPSIS
Enable AVD Start VM on Connect

## SYNTAX

### Initial (Default)
```
Enable-AvdStartVmOnConnect [-HostpoolName <String>] [-ResourceGroupName <String>]
 [-HostsResourceGroup <String>] [-RoleName <String>] [-Force] [<CommonParameters>]
```

### Update
```
Enable-AvdStartVmOnConnect [-HostpoolName <String>] [-ResourceGroupName <String>] -HostsResourceGroup <String>
 [-RoleName <String>] [-Force] [<CommonParameters>]
```

## DESCRIPTION
This function will enable the start VM on connect option in the hostpool and will configure the Azure AD permissions.
It will create a new role (AVD Start VM on connect) in the Azure AD

## EXAMPLES

### EXAMPLE 1
```
Enable-AvdStartVmOnConnect -HostPoolName avd-hostpool-001 -ResourceGroupName rg-avd-001
```

## PARAMETERS

### -HostpoolName
Enter the name of the hostpool you want to enable start vm on connnect.

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

### -ResourceGroupName
Enter the name of the resourcegroup where the hostpool resides in.

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

### -HostsResourceGroup
{{ Fill HostsResourceGroup Description }}

```yaml
Type: String
Parameter Sets: Initial
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

```yaml
Type: String
Parameter Sets: Update
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RoleName
{{ Fill RoleName Description }}

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

### -Force
Set these parameter to force changing the ValidationEnvironment to true.

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
