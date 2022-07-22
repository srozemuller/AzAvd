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
New-AvdHostpool -HostpoolName <String> -ResourceGroupName <String> -Location <String> -HostPoolType <String>
 [-CustomRdpProperty <String>] [-AgentUpdate <Object>] [-FriendlyName <String>] [-Description <String>]
 [-LoadBalancerType <String>] [-ValidationEnvironment <Boolean>] [-StartVMOnConnect <Boolean>]
 [-PreferredAppGroupType <String>] [-PersonalDesktopAssignmentType <String>] [-VmTemplate <String>]
 [-MaxSessionLimit <Int32>] [-Force] [<CommonParameters>]
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

### EXAMPLE 4
```
New-AvdHostpool -hostpoolname avd-hostpool -resourceGroupName rg-avd-01 -location WestEurope -AgentUpdate @(@{dayOfWeek="Sunday";Hour=3},@{dayOfWeek="Monday";Hour=3})
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

### -Location
{{ Fill Location Description }}

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

### -HostPoolType
{{ Fill HostPoolType Description }}

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

### -CustomRdpProperty
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

### -AgentUpdate
Provide the agent update object, max 2 schedules supported.
If provided more than 2, the first 2 are selected.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -FriendlyName
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

### -Description
{{ Fill Description Description }}

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

### -LoadBalancerType
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

### -ValidationEnvironment
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

### -StartVMOnConnect
{{ Fill StartVMOnConnect Description }}

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

### -PreferredAppGroupType
{{ Fill PreferredAppGroupType Description }}

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

### -VmTemplate
{{ Fill VmTemplate Description }}

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

### -MaxSessionLimit
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
