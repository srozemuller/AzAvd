---
external help file: Az.Avd-help.xml
Module Name: Az.Avd
online version:
schema: 2.0.0
---

# New-AvdSessionHost

## SYNOPSIS
Deploys session hosts into a hostpool

## SYNTAX

### AADWithSig (Default)
```
New-AvdSessionHost -HostpoolName <String> -ResourceGroupName <String> -ImageVersionId <String>
 -SessionHostCount <Int32> [-InitialNumber <Int32>] -Prefix <String> -Version <String> -VmSize <String>
 -Location <String> -DiskType <String> [-LocalAdmin <String>] [-LocalPass <String>] -SubnetId <String>
 [-AzureAd] [-Intune] [-TrustedLaunch] [-MaxParallel <Int32>] [<CommonParameters>]
```

### NativeADWithSig
```
New-AvdSessionHost -HostpoolName <String> -ResourceGroupName <String> -ImageVersionId <String>
 -SessionHostCount <Int32> [-InitialNumber <Int32>] -Prefix <String> -Version <String> -VmSize <String>
 -Location <String> -DiskType <String> [-LocalAdmin <String>] [-LocalPass <String>] -SubnetId <String>
 -Domain <String> -OU <String> -DomainJoinAccount <String> -DomainJoinPassword <SecureString> [-Intune]
 [-TrustedLaunch] [-MaxParallel <Int32>] [<CommonParameters>]
```

### NativeADWithMarketPlace
```
New-AvdSessionHost -HostpoolName <String> -ResourceGroupName <String> -SessionHostCount <Int32>
 [-InitialNumber <Int32>] -Prefix <String> -Publisher <String> -Offer <String> -Sku <String> -VmSize <String>
 -Location <String> -DiskType <String> [-LocalAdmin <String>] [-LocalPass <String>] -SubnetId <String>
 -Domain <String> -OU <String> -DomainJoinAccount <String> -DomainJoinPassword <SecureString> [-Intune]
 [-TrustedLaunch] [-MaxParallel <Int32>] [<CommonParameters>]
```

### AADWithMarketPlace
```
New-AvdSessionHost -HostpoolName <String> -ResourceGroupName <String> -SessionHostCount <Int32>
 [-InitialNumber <Int32>] -Prefix <String> -Publisher <String> -Offer <String> -Sku <String> -VmSize <String>
 -Location <String> -DiskType <String> [-LocalAdmin <String>] [-LocalPass <String>] -SubnetId <String>
 [-AzureAd] [-Intune] [-TrustedLaunch] [-MaxParallel <Int32>] [<CommonParameters>]
```

## DESCRIPTION
Deploys new session hosts into the provided hostpool

## EXAMPLES

### EXAMPLE 1
```
New-AvdSessionHost -HostpoolName avd-hostpool -HostpoolResourceGroup rg-avd-01 -sessionHostCount 1 -ResourceGroupName rg-sessionhosts-01 -Publisher "MicrosoftWindowsDesktop" -Offer "windows-10" -Sku "21h1-ent-g2" -VmSize "Standard_D2s_v3"
-Location "westeurope" -diskType "Standard_LRS" -LocalAdmin "ladmin" -LocalPass "lpass" -Prefix "AVD" -SubnetId "/subscriptions/../resourceGroups/../providers/Microsoft.Network/virtualNetworks/../subnets/../" -Intune -AzureAd
```

### EXAMPLE 2
```
New-AvdSessionHost -HostpoolName avd-hostpool -HostpoolResourceGroup rg-avd-01 -sessionHostCount 1 -ResourceGroupName rg-sessionhosts-01 -imageVersionId "/subscriptions/..galleries/../images/../version/21.0.0" -VmSize "Standard_D2s_v3"
-Location "westeurope" -diskType "Standard_LRS" -LocalAdmin "ladmin" -LocalPass "lpass" -Prefix "AVD" -SubnetId "/subscriptions/../resourceGroups/../providers/Microsoft.Network/virtualNetworks/../subnets/../" -Domain domain.local -OU "OU=AVD,DC=domain,DC=local"
-DomainAdmin vmjoiner@domain.local -DomainPassword "P@sswrd123"
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
The session hosts resource group

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

### -ImageVersionId
The image resourceId, from existing image or image version

```yaml
Type: String
Parameter Sets: AADWithSig, NativeADWithSig
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SessionHostCount
Integer value how many session hosts will be deployed

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

### -InitialNumber
The start number of the sessionhost (use Get-AvdLatestSessionhost -numonly)

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

### -Prefix
Enter the session host prefix

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

### -Publisher
In case of an Azure Markeplace image, provide the publisher

```yaml
Type: String
Parameter Sets: NativeADWithMarketPlace, AADWithMarketPlace
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Offer
In case of an Azure Markeplace image, provide the offer

```yaml
Type: String
Parameter Sets: NativeADWithMarketPlace, AADWithMarketPlace
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Sku
In case of an Azure Markeplace image, provide the sku

```yaml
Type: String
Parameter Sets: NativeADWithMarketPlace, AADWithMarketPlace
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Version
In case of an Azure Markeplace image, provide the version (default latest)

```yaml
Type: String
Parameter Sets: AADWithSig, NativeADWithSig
Aliases:

Required: True
Position: Named
Default value: Latest
Accept pipeline input: False
Accept wildcard characters: False
```

### -VmSize
{{ Fill VmSize Description }}

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
Enter the session host location

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

### -DiskType
Enter the session host diskType

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

### -LocalAdmin
Enter the session host local admin account

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: (Get-RandomString -type string)
Accept pipeline input: False
Accept wildcard characters: False
```

### -LocalPass
Enter the session host local admins password

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: (Get-RandomString -type password)
Accept pipeline input: False
Accept wildcard characters: False
```

### -SubnetId
Enter the subnet resource ID where the session host is in

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

### -AzureAd
Provide this switch parameter if the session host is Azure AD joined, otherwise it is native AD joined

```yaml
Type: SwitchParameter
Parameter Sets: AADWithSig, AADWithMarketPlace
Aliases:

Required: True
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Domain
Provide the native domain name.
domain.local

```yaml
Type: String
Parameter Sets: NativeADWithSig, NativeADWithMarketPlace
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -OU
Enter the OU to store the hosts at

```yaml
Type: String
Parameter Sets: NativeADWithSig, NativeADWithMarketPlace
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DomainJoinAccount
Provide an account with domain join permissions, mostly domain admin

```yaml
Type: String
Parameter Sets: NativeADWithSig, NativeADWithMarketPlace
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DomainJoinPassword
The domain admin password, must be a secure string

```yaml
Type: SecureString
Parameter Sets: NativeADWithSig, NativeADWithMarketPlace
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Intune
Switch parameter if you want to add the session host into Intune.
Only supported with AzureAD enrollment.

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

### -TrustedLaunch
{{ Fill TrustedLaunch Description }}

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

### -MaxParallel
{{ Fill MaxParallel Description }}

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 5
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
