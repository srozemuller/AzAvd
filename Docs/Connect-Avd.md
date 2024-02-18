---
external help file: Az.Avd-help.xml
Module Name: Az.Avd
online version:
schema: 2.0.0
---

# Connect-Avd

## SYNOPSIS
Get an access token using either authorization code flow or device code flow, that can be used to authenticate and authorize against resources in Azure.

## SYNTAX

### ClientSecret (Default)
```
Connect-Avd [-TenantID <String>] [-ClientID <String>] [-RedirectUri <String>] -SubscriptionId <String>
 [-ClientSecret <String>] [-Scope <String>] [<CommonParameters>]
```

### Refresh
```
Connect-Avd [-TenantID <String>] -SubscriptionId <String> [-RefreshToken <String>] [<CommonParameters>]
```

### DeviceCode
```
Connect-Avd -TenantID <String> [-ClientID <String>] [-RedirectUri <String>] -SubscriptionId <String>
 [-Scope <String>] [-DeviceCode] [<CommonParameters>]
```

### AccessToken
```
Connect-Avd -SubscriptionId <String> [-AccessToken <String>] [<CommonParameters>]
```

## DESCRIPTION
Get an access token using either authorization code flow or device code flow, that can be used to authenticate and authorize against resources in Azure.

## EXAMPLES

### EXAMPLE 1
```
Connect-Avd -TenantID $Tenantid -SubscriptionId $SubscriptionId -DeviceCode
```

### EXAMPLE 2
```
Connect-Avd -ClientID xxxx -ClientSecret "xxxxx" -TenantID $Tenantid -SubscriptionId $SubscriptionId
```

## PARAMETERS

### -TenantID
Specify the tenant name or ID, e.g.
tenant.onmicrosoft.com or \<GUID\>.

```yaml
Type: String
Parameter Sets: ClientSecret, Refresh
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

```yaml
Type: String
Parameter Sets: DeviceCode
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ClientID
Application ID (Client ID) for an Azure AD service principal.
Uses by default the 'Microsoft Azure PowerShell' service principal Application ID.

```yaml
Type: String
Parameter Sets: ClientSecret, DeviceCode
Aliases:

Required: False
Position: Named
Default value: 1950a258-227b-4e31-a9cf-717495945fc2
Accept pipeline input: False
Accept wildcard characters: False
```

### -RedirectUri
Specify the Redirect URI (also known as Reply URL) of the custom Azure AD service principal.

```yaml
Type: String
Parameter Sets: ClientSecret, DeviceCode
Aliases:

Required: False
Position: Named
Default value: [string]::Empty
Accept pipeline input: False
Accept wildcard characters: False
```

### -SubscriptionId
Specify a subscription ID to set the Azure context.
Can be changed later using Set-AvdContext.

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

### -ClientSecret
Application secret is using a custom Azure AD service principal.

```yaml
Type: String
Parameter Sets: ClientSecret
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Scope
Specify the subscription ID to connect to

```yaml
Type: String
Parameter Sets: ClientSecret, DeviceCode
Aliases:

Required: False
Position: Named
Default value: Https://management.azure.com//.default
Accept pipeline input: False
Accept wildcard characters: False
```

### -DeviceCode
Specify delegated login using devicecode flow, you will be prompted to navigate to https://microsoft.com/devicelogin

```yaml
Type: SwitchParameter
Parameter Sets: DeviceCode
Aliases:

Required: True
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -RefreshToken
Specify to refresh an existing access token.

```yaml
Type: String
Parameter Sets: Refresh
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AccessToken
Provide an access token to use for authentication.

```yaml
Type: String
Parameter Sets: AccessToken
Aliases:

Required: False
Position: Named
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
