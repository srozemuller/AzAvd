function Connect-Avd {
    <#
    .SYNOPSIS
        Get an access token using either authorization code flow or device code flow, that can be used to authenticate and authorize against resources in Azure.
    .DESCRIPTION
        Get an access token using either authorization code flow or device code flow, that can be used to authenticate and authorize against resources in Azure.
    .PARAMETER TenantID
        Specify the tenant name or ID, e.g. tenant.onmicrosoft.com or <GUID>.
    .PARAMETER ClientID
        Application ID (Client ID) for an Azure AD service principal. Uses by default the 'Microsoft Azure PowerShell' service principal Application ID.
    .PARAMETER ClientSecret
        Application secret is using a custom Azure AD service principal.
    .PARAMETER RedirectUri
        Specify the Redirect URI (also known as Reply URL) of the custom Azure AD service principal.
    .PARAMETER DeviceCode
        Specify delegated login using devicecode flow, you will be prompted to navigate to https://microsoft.com/devicelogin
    .PARAMETER SubscriptionId
        Specify a subscription ID to set the Azure context. Can be changed later using Set-AvdContext.
    .PARAMETER Refresh
        Specify to refresh an existing access token.
    .EXAMPLE
        Connect-Avd -TenantID $Tenantid -SubscriptionId $SubscriptionId -DeviceCode
    .EXAMPLE
        Connect-Avd -ClientID xxxx -ClientSecret "xxxxx" -TenantID $Tenantid -SubscriptionId $SubscriptionId
    #>
    [CmdletBinding(DefaultParameterSetName = "ClientSecret")]
    param(
        [parameter(Mandatory, ParameterSetName = "DeviceCode")]
        [parameter(ParameterSetName = "ClientSecret")]
        [parameter(ParameterSetName = "Refresh")]
        [ValidateNotNullOrEmpty()]
        [string]$TenantID,

        [parameter(ParameterSetName = "ClientSecret", HelpMessage = "Application ID (Client ID) for an Azure AD service principal. Uses by default the 'Microsoft Azure PowerShell' service principal Application ID.")]
        [parameter(ParameterSetName = "DeviceCode")]
        [ValidateNotNullOrEmpty()]
        [string]$ClientID = "1950a258-227b-4e31-a9cf-717495945fc2",

        [parameter(ParameterSetName = "ClientSecret", HelpMessage = "Specify the Redirect URI (also known as Reply URL) of the custom Azure AD service principal.")]
        [parameter(ParameterSetName = "DeviceCode")]
        [ValidateNotNullOrEmpty()]
        [string]$RedirectUri = [string]::Empty,

        [parameter(Mandatory, HelpMessage = "Specify the subscription ID to connect to")]
        [ValidateNotNullOrEmpty()]
        [string]$SubscriptionId,

        [parameter(ParameterSetName = "ClientSecret", HelpMessage = "Specify the client secret of your registered application")]
        [string]$ClientSecret,

        [parameter(ParameterSetName = "ClientSecret", HelpMessage = "Specify the subscription ID to connect to")]
        [parameter(ParameterSetName = "DeviceCode", HelpMessage = "Specify the subscription ID to connect to")]
        [ValidateNotNullOrEmpty()]
        [string]$Scope = "https://management.azure.com//.default",

        [parameter(Mandatory, ParameterSetName = "DeviceCode", HelpMessage = "Specify to do delegated login using devicecode flow, you will be prompted to navigate to https://microsoft.com/devicelogin")]
        [switch]$DeviceCode,

        [parameter(ParameterSetName = "Refresh", HelpMessage = "Specify to refresh an existing access token.")]
        [string]$RefreshToken,

        [parameter(ParameterSetName = "AccessToken", HelpMessage = "Provide an access token to use for authentication.")]
        [string]$AccessToken
    )
    Begin {
        $global:TenantId = $TenantID
        if ($SubscriptionId) {
            Write-Verbose "Subscription ID provided, setting context to $SubscriptionId"
            $global:subscriptionId = $SubscriptionId
        }
        # Determine the correct RedirectUri (also known as Reply URL) to use with MSAL.PS
        if ($ClientID -eq "1950a258-227b-4e31-a9cf-717495945fc2") {
            $RedirectUri = "urn:ietf:wg:oauth:2.0:oob"
        }
        else {
            if (-not([string]::IsNullOrEmpty($ClientID))) {
                Write-Verbose -Message "Using custom Azure AD service principal specified with Application ID: $($ClientID)"

                # Adjust RedirectUri parameter input in case non was passed on command line
                if ([string]::IsNullOrEmpty($RedirectUri)) {
                    switch -Wildcard ($PSVersionTable["PSVersion"]) {
                        "5.*" {
                            $RedirectUri = "https://login.microsoftonline.com/common/oauth2/nativeclient"
                        }
                        "7.*" {
                            $RedirectUri = "http://localhost"
                        }
                    }
                }
            }
        }
        Write-Verbose -Message "Using RedirectUri with value: $($RedirectUri)"

        # Set default error action preference configuration
        $ErrorActionPreference = "Stop"
    }
    Process {
        Write-Verbose -Message "Using authentication flow: $($PSCmdlet.ParameterSetName)"
        try {
            switch ($PSCmdlet.ParameterSetName) {
                "DeviceCode" {
                    if ($null -ne $global:tokenRequest -and ($global:tokenRequest.scope -eq 'user_impersonation')){
                        throw "You allready are logged in with user_impersonation, disconnect first if you want to reauthenticate. Use Disconnect-Avd"
                    }
                    $clientBody = @{
                        client_id = $ClientId
                        tenant    = $TenantID
                        scope     = $Scope
                    }
                    $requestUrl = Invoke-WebRequest -Method POST -Uri "https://login.microsoftonline.com/$($TenantID)/oauth2/v2.0/devicecode" -Body $clientBody
                    $content = ($requestUrl.Content | ConvertFrom-Json)
                    if ([string]::IsNullOrEmpty($global:tokenRequest.access_token)) {
                        Write-Information "`n$($content.message)" -InformationAction Continue
                    }
                    # Get OAuth Token
                    $tokenBody = @{
                        grant_type = "urn:ietf:params:oauth:grant-type:device_code"
                        code       = $content.device_code
                        client_id  = $ClientId
                    }
                    while ([string]::IsNullOrEmpty($global:tokenRequest.access_token)) {
                        $global:tokenRequest = try {
                            Invoke-RestMethod -Method POST -Uri "https://login.microsoftonline.com/$TenantID/oauth2/token" -Body $tokenBody
                        }
                        catch {
                            $errorMessage = $_.ErrorDetails.Message | ConvertFrom-Json
                            # If not waiting for auth, throw error
                            if ($errorMessage.error -ne "authorization_pending") {
                                throw "Authorization is pending."
                            }
                        }
                    }
                }
                "ClientSecret" {
                    if ($null -ne $global:tokenRequest -and (!($global:tokenRequest.scope))){
                        throw "You allready are logged in with a service principal, disconnect first if you want to reauthenticate. Use Disconnect-Avd"
                    }
                    # Must be this URL. https://management.azure.com is not working while using the resource object. The scope object is ignored when providing management.azure.com
                    $Scope = 'https://management.core.windows.net/'
                    $tokenBody = @{
                        grant_type    = "client_credentials"
                        client_id     = $ClientID
                        client_secret = $ClientSecret
                        resource      = $Scope
                    }
                    $contentType = "application/x-www-form-urlencoded"
                    $global:tokenRequest = try {
                        Invoke-RestMethod -Method POST -Uri "https://login.microsoftonline.com/$TenantID/oauth2/token" -Body $tokenBody -ContentType $contentType
                    }
                    catch {
                        $errorMessage = $_.ErrorDetails.Message | ConvertFrom-Json
                        # If not waiting for auth, throw error
                        if ($errorMessage.error -ne "authorization_pending") {
                            throw "Authorization is pending."
                        }
                    }
                }
                "Refresh" {
                    Write-Verbose "Refreshing token"
                    $tokenBody = @{
                        grant_type    = "refresh_token"
                        client_id     = $ClientId
                        refresh_token = $RefreshToken
                        scope         = $global:tokenRequest.scope
                    }
                    $global:tokenRequest = try {
                        Invoke-RestMethod -Method POST -Uri "https://login.microsoftonline.com/$TenantID/oauth2/token" -Body $tokenBody
                    }
                    catch {
                        $errorMessage = $_.ErrorDetails.Message | ConvertFrom-Json
                        # If not waiting for auth, throw error
                    }
                }
                "AccessToken" {
                    Write-Verbose "Using provided access token, that is ease for me. Thank you for that."
                    $global:tokenRequest = [PSCustomObject]@{
                        access_token = $AccessToken
                    }
                }
            }
            Write-Verbose "Token is $($global:tokenRequest)"
            $global:authHeader = @{
                'Content-Type' = 'application/json'
                Authorization  = "Bearer {0}" -f $global:tokenRequest.access_token
            }
            Write-Information "Succesfully connected to scope $scope"
            return $global:authHeader
        }
        catch [System.Exception] {
            Write-Error -Message "An error occurred while constructing parameter input for access token retrieval. Error message: $($PSItem.Exception.Message)"
        }
    }
}