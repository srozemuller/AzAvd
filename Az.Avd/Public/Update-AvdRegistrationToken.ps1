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
        } | ConvertTo-Json
        $parameters = @{
            uri     = "{0}/subscriptions/{1}/resourceGroups/{2}/providers/Microsoft.DesktopVirtualization/hostpools/{3}?api-version={4}" -f $global:AzureApiUrl, $global:subscriptionId, $ResourceGroupName, $HostpoolName, $global:hostpoolApiVersion
            Method  = "PATCH"
            body    = $body
        }
        $results = Request-Api @parameters
        $results
    }
}
