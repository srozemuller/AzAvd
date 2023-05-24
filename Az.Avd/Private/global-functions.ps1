# In this file all global functions are configured.
function AuthenticationCheck {
    <#
    .SYNOPSIS
    PreCheck
    .DESCRIPTION
    This function is used as a precheck step by all the functions to test if authentication is Ok.
    .EXAMPLE
    precheck
    Run the test
    .NOTES
    NAME: precheck
    #>
    if ($null -eq $script:tokenRequest) {
        Throw "Please connect to AVD first using the Connect-Avd command"
    }
    if ($null -eq $script:subscriptionId){
        Write-Warning "No subscription ID provided yet"
        $script:subscriptionId = Read-Host -Prompt "Please fill in the subscription Id"
        Write-Information "Subscription ID is set, if you want to changed the context, use Set-AvdContext -SubscriptionID <GUID>" -InformationAction Continue
    }
}

function GetAuthToken {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]$Resource

    )
    $expireTime = Get-Date -UnixTimeSeconds $script:tokenRequest.expires_on
    if ((Get-Date) -gt $expireTime)
    {
        Write-Verbose "Current token has expired. Requesting a new token based on the refresh token."
        $script:authHeader = Connect-Avd -RefreshToken $script:tokenRequest.refresh_token -TenantID $TenantId
    }
    return $script:authHeader
}

function Create-CategoryArray ($Categories) {
    $categoryArray = @()
    $Categories | foreach {
        $category = @{
            Category = $_
            Enabled  = $true
        }
        $categoryArray += ($category)
    }
    return  $categoryArray
}

function Remove-Resource () {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$ResourceId,
        [Parameter(Mandatory)]
        [string]$apiVersion
    )
    try {
        Write-Information "Removing resource with ID $resourceId" -InformationAction Continue
        $apiVersion = "?api-version={0}" -f $apiVersion
        $deleteResourceParameters = @{
            uri     = "{0}{1}{2}" -f $Script:AzureApiUrl, $resourceId, $apiVersion
            Method  = "DELETE"
            Headers = (GetAuthToken -resource $Script:AzureApiUrl)
        }
        Invoke-RestMethod @deleteResourceParameters
    }
    catch {
        Write-Error "Removing $resourceId not succesful, $_"
    }
}


function Get-Resource () {
    [CmdletBinding(DefaultParameterSetName='default')]
    param (
        [Parameter(Mandatory, ParameterSetName = 'default')]
        [Parameter(Mandatory, ParameterSetName = 'api')]
        [string]$ResourceId,

        [Parameter()]
        [ValidateSet("GET", "POST")]
        [string]$Method = "GET",

        [Parameter(Mandatory, ParameterSetName = 'api')]
        [string]$ApiVersion,

        [Parameter(ParameterSetName = 'api')]
        [string]$UrlAddition

    )
    try {
        $token = (GetAuthToken -resource $Script:AzureApiUrl)
        switch ($PsCmdlet.ParameterSetName) {
            api {
                Write-Verbose 'API version provided, searching in specific API'
                $resourceParameters = @{
                    uri     = "{0}/{1}{2}?api-version={3}" -f $Script:AzureApiUrl, $ResourceId, $UrlAddition, $ApiVersion
                    Method  = $Method
                    Headers = $token
                }
                Write-Verbose "Request URI is $($resourceParameters.uri)"
            }
            default {
                Write-Information "Searching resource with ID $resourceId" -InformationAction Continue
                $subscriptionId = ($ResourceId | Select-String -Pattern '(?<=\/subscriptions\/)(.*?)(?=\/resourcegroups)').Matches.Groups[-1].Value
                $resourceParameters = @{
                    uri     = "{0}/subscriptions/{1}/resources?api-version=2014-04-01-preview&`$filter=resourceId eq '{2}'" -f $Script:AzureApiUrl, $subscriptionId, $ResourceId
                    Method  = $Method
                    Headers = $token
                }
            }
        }
        $resource = Invoke-RestMethod @resourceParameters
    }
    catch {
        Write-Verbose "$resourceId not found, $_"
        Throw $_
    }
    finally {
        $resource
    }
}


function CheckForce {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$Task,
        [Parameter(Mandatory)]
        [boolean]$Force
    )
    if (!$Force) {
        Write-Verbose "No specific host provided, starting all hosts in $hostpoolName"
        Write-Information -MessageData "HINT: use -Force to skip this message." -InformationAction Continue
        $confirmation = Read-Host "Are you sure you want to run $Task to all session hosts? [y/n]"
        while ($confirmation -ne "y") {
            if ($confirmation -eq 'n') {
                exit
            }
            $confirmation = Read-Host "Yes/No? [y/n]"
        }
    }
}

function ConcatSessionHostName {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$Name
    )
    if ($Name -match '^(?:(?!\/).)*$') {
        $Name = $Name.Split('/')[-1]
        Write-Verbose "It looks like you also provided a hostpool, a sessionhost name is enough. Provided value {0}"
        Write-Verbose "Picking only the hostname which is $Name"
    }
    else {
        Write-Verbose "Session hostname provided, looking for sessionhost $Name"
    }
    $name
}

function TestAzResource($resourceId,$apiVersion) {
    $testParameters = @{
        method = "GET"
        headers = GetAuthToken -resource $script:AzureApiUrl
        uri = "{0}{1}?api-version={2}" -f $script:AzureApiUrl, $resourceId, $apiVersion
    }
    Invoke-RestMethod @testParameters
}

function Get-RandomCharacters($length, $characters) {
    $random = 1..$length | ForEach-Object { Get-Random -Maximum $characters.length }
    $private:ofs = ""
    return [String]$characters[$random]
}
function Get-RandomString($type) {
    if ($type -eq 'string') {
        $username = Get-RandomCharacters -length 8 -characters 'abcdefghiklmnoprstuvwxyz'
        return $username
    }
    if ($type -eq 'password') {
        $password = Get-RandomCharacters -length 6 -characters 'abcdefghiklmnoprstuvwxyz'
        $password += Get-RandomCharacters -length 2 -characters 'ABCDEFGHKLMNOPRSTUVWXYZ'
        $password += Get-RandomCharacters -length 2 -characters '1234567890'
        $password += Get-RandomCharacters -length 2 -characters '!%&()=#+'
        return $password
    }
}