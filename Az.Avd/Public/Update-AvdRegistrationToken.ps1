function Update-AvdRegistrationToken {
    <#
    .SYNOPSIS
    Will create a new registration token which you need to onboard new session hosts
    .DESCRIPTION
    The function will create a new registration token, if needed, and will return the value which you need to onboard new session hosts
    .PARAMETER HostpoolName
    Enter the AVD Hostpool name
    .PARAMETER ResourceGroupName
    Enter the AVD Hostpool resourcegroup name
    .PARAMETER HoursActive
    Optional, give the token availability in hours. Default 4.
    .EXAMPLE
    Update-AvdRegistrationToken -HostpoolName avd-hostpool -ResourceGroupName avd-resourcegroup
    #>
    [CmdletBinding()]
    param (
        
        [parameter(mandatory = $true, ValueFromPipeline)]
        [ValidateNotNullOrEmpty()]
        [string]$HostpoolName,

        [parameter(mandatory = $true, ValueFromPipeline)]
        [ValidateNotNullOrEmpty()]
        [string]$ResourceGroupName,

        [parameter(mandatory = $false)]
        [int]$HoursActive = 4
    )
    Begin {
        Write-Verbose "Start updating registration token"
        AuthenticationCheck
        $token = GetAuthToken -resource $global:AzureApiUrl
        $apiVersion = "?api-version=2019-12-10-preview"
        $hostpoolUrl = $global:AzureApiUrl + "/subscriptions/" + $global:subscriptionId + "/resourceGroups/" + $ResourceGroupName + "/providers/Microsoft.DesktopVirtualization/hostpools/" + $HostpoolName + $apiVersion
    }
    Process {
        $now = get-date
        $body = @{
            properties = @{
                registrationInfo = @{
                    expirationTime = $now.AddHours($HoursActive)
                    registrationTokenOperation = "Update"
                }
            }
        }
        $parameters = @{
            uri     = $hostpoolUrl
            Method  = "PATCH"
            Headers = $token
            body    = $body | ConvertTo-Json
        }
        $results = Invoke-RestMethod @parameters
        $results
    }
}
