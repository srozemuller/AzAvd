---
external help file: Az.Avd-help.xml
Module Name: Az.Avd
online version:
schema: 2.0.0
---

# New-AvdVmTemplate

## SYNOPSIS
Creates a VM template in the AVD hostpool.

## SYNTAX

```
New-AvdVmTemplate [-HostpoolName] <String> [-ResourceGroupName] <String> [[-Domain] <String>]
 [[-GalleryImageOffer] <String>] [[-GalleryImagePublisher] <String>] [[-GalleryImageSku] <String>]
 [[-ImageType] <String>] [[-ImageUri] <String>] [[-CustomImageId] <String>] [-NamePrefix] <String>
 [[-UseManagedDisks] <String>] [-OsDiskType] <String> [-VmSku] <String> [-VmCores] <String> [-VmRam] <String>
 [[-CustomObject] <Object>] [<CommonParameters>]
```

## DESCRIPTION
The function will create an AVD VM template for session hosts.
This template is configured in the hostpool

## EXAMPLES

### EXAMPLE 1
```
New-AvdVmTemplate-HostpoolName avd-hostpool -ResourceGroupName rg-avd-01 -domain domain.local -namePrefix avd -vmSku 'Standard_B2ms' -vmCores 2 -vmRam 8 -osDiskType "Premium_LRS" -CustomObject $customObjects
```

### EXAMPLE 2
```
New-AvdVmTemplate -HostpoolName avd-hostpool -ResourceGroupName rg-avd-01 -domain domain.local -namePrefix avd -vmSku 'Standard_B2ms' -vmCores 2 -vmRam 8 -osDiskType "Premium_LRS"
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
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Domain
Enter the sessionhosts domain

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -GalleryImageOffer
Enter the gallery image offer

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -GalleryImagePublisher
Enter the gallery image publisher

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -GalleryImageSku
Enter the gallery image sku

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ImageType
Enter the image type.
(default: CustomImage)

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ImageUri
The url of an image (.vhd)

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 8
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CustomImageId
The resourceId of an image or image version

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 9
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -NamePrefix
The sessionhosts name prefix (avd-)

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 10
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -UseManagedDisks
The use of a managed disk or not (default: True)

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 11
Default value: True
Accept pipeline input: False
Accept wildcard characters: False
```

### -OsDiskType
The OS disk type ("Standard_LRS", "Premium_LRS", "StandardSSD_LRS")

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 12
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -VmSku
This is the part of the VMsize information.
(eg.
Standard_B2ms)

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 13
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -VmCores
This is the part of the VMsize information.
How many cores.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 14
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -VmRam
This is the part of the VMsize information.
The RAM size in GB.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 15
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CustomObject
Can be used to add extra values into the template.
Please provide a PSCustomObject.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 16
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
