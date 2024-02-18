function Start-AvdHostPoolUpdate {
    <#
.SYNOPSIS
Get AVD Hostpool information.
.DESCRIPTION
With this function you can get information about an AVD hostpool.
.PARAMETER HostPoolName
Enter the name of the hostpool you want information from.
.PARAMETER ResourceGroupName
Enter the name of the resourcegroup where the hostpool resides in.
.PARAMETER ResourceId
Enter the hostpool ResourceId
.PARAMETER MaxVMsRemovedDuringUpdate
Enter the number of sessionhosts that can be removed during the update.
.PARAMETER SaveOriginalDisk
Enter if you want to save the original disk.
.PARAMETER logOffMessage
Enter the message that will be shown to the user when the sessionhost is removed.
.PARAMETER LogoutDelayMinutes
Enter the number of minutes the user has to log off.
.EXAMPLE
Start-AvdHostPoolUpdate -Resourceid /subscriptions/xxx/resourceGroups/rg-avd/providers/Microsoft.DesktopVirtualization/hostpools/AVD-Hostpool/ -MaxVMsRemovedDuringUpdate 2
.EXAMPLE
Start-AvdHostPoolUpdate -Hostpoolname AVD-Hostpool -ResourceGroupName rg-avd -MaxVMsRemovedDuringUpdate 2
#>
    [CmdletBinding(DefaultParameterSetName = "ResourceID")]
    param (
        [Parameter(Mandatory, ParameterSetName = "Name")]
        [ValidateNotNullOrEmpty()]
        [string]$HostPoolName,

        [Parameter(Mandatory, ParameterSetName = "Name")]
        [ValidateNotNullOrEmpty()]
        [string]$ResourceGroupName,

        [Parameter(Mandatory, ParameterSetName = "ResourceID")]
        [ValidateNotNullOrEmpty()]
        [string]$ResourceId,

        [Parameter(Mandatory)]
        [int]$MaxVMsRemovedDuringUpdate,

        [Parameter()]
        [bool]$SaveOriginalDisk = $true,

        [Parameter()]
        [string]$logOffMessage = "Please save your work and sign out for this session host will be shut down for image update. Please log back in when you are ready",

        [Parameter()]
        [int]$LogoutDelayMinutes = 5
    )
    Begin {
        Write-Verbose "Start searching for hostpool $hostpoolName"
        AuthenticationCheck
        switch ($PsCmdlet.ParameterSetName) {
            Name {
                Write-Verbose "Name and ResourceGroup provided"
                $url = "{0}/subscriptions/{1}/resourceGroups/{2}/providers/Microsoft.DesktopVirtualization/hostpools/{3}/sessionHostManagements/default/initiateSessionHostUpdate?api-version={4}" -f $script:AzureApiUrl, $script:subscriptionId, $ResourceGroupName, $HostpoolName, $script:hostpoolUpdateApiVersion
                $sessionHosts = Get-AvdSessionHost -HostpoolName $HostPoolName -ResourceGroupName $ResourceGroupName
            }
            ResourceId {
                Write-Verbose "ResourceId provided"
                $sessionHosts = Get-AvdSessionHost -HostPoolResourceId $ResourceId
                $url = "{0}{1}/sessionHostManagements/default/initiateSessionHostUpdate?api-version={2}" -f $script:AzureApiUrl, $resourceId, $script:hostpoolUpdateApiVersion
            }
        }
    }
    Process {
        try {
            Write-Verbose "Found $($sessionHosts.Count) session hosts"
            if ($MaxVMsRemovedDuringUpdate -gt $sessionHosts.Count) {
                Write-Warning "MaxVMsRemovedDuringUpdate ($MaxVMsRemovedDuringUpdate) is higher than the amount of sessionhosts ($($sessionHosts.Count)) in the hostpool. Setting MaxVMsRemovedDuringUpdate to $($sessionHosts.Count - 1)"
                $MaxVMsRemovedDuringUpdate = $sessionHosts.Count - 1
            }
            $body = @{
                parameters   = @{
                    saveOriginalDisk          = $SaveOriginalDisk
                    maxVMsRemovedDuringUpdate = $MaxVMsRemovedDuringUpdate
                    maintenanceAlerts         = @()
                    logOffDelayMinutes        = $LogoutDelayMinutes
                    logOffMessage             = $LogOffMessage
                    scheduledTime             = $null
                }
                validateOnly = $false
            } | ConvertTo-Json
            $parameters = @{
                uri     = $url
                Method  = "POST"
                Headers = $script:authHeader
                Body    = $body
            }
            $response = Request-Api @parameters
            return $response
        }
        catch {
            Write-Error $_.Exception.Response
        }
    }
}
