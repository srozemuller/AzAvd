---
external help file: Az.Avd-help.xml
Module Name: Az.Avd
online version:
schema: 2.0.0
---

# New-AvdHostpool

## SYNOPSIS
Creates a new Azure Virtual Desktop hostpool.

## SYNTAX

```
New-AvdHostpool -HostpoolName <String> -ResourceGroupName <String> -location <String> -hostPoolType <String>
 [-customRdpProperty <String>] [-friendlyName <String>] [-description <String>] [-loadBalancerType <String>]
 [-validationEnvironment <Boolean>] [-startVMOnConnect <Boolean>] [-preferredAppGroupType <String>]
 [-PersonalDesktopAssignmentType <String>] [-vmTemplate <String>] [-maxSessionLimit <Int32>] [-Force]
 [<CommonParameters>]
```

## DESCRIPTION
The function will create a new Azure Virtual Desktop hostpool.

## EXAMPLES

### EXAMPLE 1
```
New-AvdHostpool -hostpoolname avd-hostpool -resourceGroupName rg-avd-01 -location WestEurope -hostPoolType "Personal"
```

### EXAMPLE 2
```
New-AvdHostpool -hostpoolname avd-hostpool -resourceGroupName rg-avd-01 -location WestEurope -customRdpProperty "targetisaadjoined:i:1"
```

### EXAMPLE 3
```
New-AvdHostpool -hostpoolname avd-hostpool -resourceGroupName rg-avd-01 -location WestEurope -vmTemplate "{"domain":"","osDiskType":"Premium_LRS","namePrefix":"avd","vmSize":{"cores":"2","ram":"8","id":"Standard_B2MS"},"galleryImageOffer":"","galleryImagePublisher":"","galleryImageSKU":"","imageType":"","imageUri":"","customImageId":"","useManagedDisks":"True","galleryItemId":null}"
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

### -location
{{ Fill location Description }}

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

### -hostPoolType
{{ Fill hostPoolType Description }}

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

### -customRdpProperty
If needed fill in the custom rdp properties (for example: targetisaadjoined:i:1 )

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

### -friendlyName
Change the host pool friendly name

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

### -description
{{ Fill description Description }}

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

### -loadBalancerType
Change the host pool loadBalancerType

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

### -validationEnvironment
Change the host pool validation environment

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -startVMOnConnect
{{ Fill startVMOnConnect Description }}

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -preferredAppGroupType
{{ Fill preferredAppGroupType Description }}

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

### -PersonalDesktopAssignmentType
{{ Fill PersonalDesktopAssignmentType Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: Automatic
Accept pipeline input: False
Accept wildcard characters: False
```

### -vmTemplate
{{ Fill vmTemplate Description }}

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

### -maxSessionLimit
Change the host pool max session limit (max 999999)

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Force
use the force parameter if you want to override the current customrdpproperties.
Otherwise it will add the provided properties.

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
