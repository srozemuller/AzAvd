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
.EXAMPLE
Get-AvdHostPool -HostPoolName avd-hostpool-001 -ResourceGroupName rg-avd-001
.EXAMPLE
Get-AvdHostPool -ResourceId "/subscription/../HostPoolName"
#>
    [CmdletBinding(DefaultParameterSetName = "Time")]
    param (
        [Parameter(Mandatory, ParameterSetName = "Name")]
        [ValidateNotNullOrEmpty()]
        [string]$HostPoolName,

        [Parameter(Mandatory, ParameterSetName = "Name")]
        [ValidateNotNullOrEmpty()]
        [string]$ResourceGroupName,

        [Parameter(Mandatory, ParameterSetName = "Time")]
        [ValidateNotNullOrEmpty()]
        [string]$ResourceId,

        [Parameter(Mandatory)]
        [int]$MaxVMsRemovedDuringUpdate,

        [Parameter()]
        [bool]$SaveOriginalDisk = $true,

        [Parameter()]
        [string]$logOffMessage = "Please save your work and sign out for this session host will be shut down for image update. Please log back in when you are ready",

        [Parameter()]
        [int]$LogoutDelayMinutes = 5,

        [Parameter(Mandatory,ParameterSetName = "Direct")]
        [switch]$Now,

        [Parameter(Mandatory,ParameterSetName = "Time")]
        [string]$DateTime
    )
    Begin {
        Write-Verbose "Start searching for hostpool $hostpoolName"
        AuthenticationCheck
        $token = GetAuthToken -resource $script:AzureApiUrl
        switch ($PsCmdlet.ParameterSetName) {
            Name {
                Write-Verbose "Name and ResourceGroup provided"
                $url = "{0}/subscriptions/{1}/resourceGroups/{2}/providers/Microsoft.DesktopVirtualization/hostpools/{3}/update?api-version={4}" -f $script:AzureApiUrl, $script:subscriptionId, $ResourceGroupName, $HostpoolName, $script:hostpoolUpdateApiVersion
            }
            ResourceId {
                Write-Verbose "ResourceId provided"
                $url = "{0}{1}/update?api-version={2}" -f $script:AzureApiUrl, $resourceId, $script:hostpoolUpdateApiVersion
            }
        }
    }
    Process {
        $sessionHosts = Get-AvdSessionHost -HostPoolResourceId $ResourceId
        if ($MaxVMsRemovedDuringUpdate -gt $sessionHosts.Count) {
            Write-Warning "MaxVMsRemovedDuringUpdate ($MaxVMsRemovedDuringUpdate) is higher than the amount of sessionhosts ($($sessionHosts.Count)) in the hostpool. Setting MaxVMsRemovedDuringUpdate to $($sessionHosts.Count - 1)"
            $MaxVMsRemovedDuringUpdate = $sessionHosts.Count - 1
        }
        if ($Now.IsPresent) {
            $ScheduledTime = $null
        }
        else {
            $timezone = $(Get-TimeZone).StandardName
            $ScheduledTime = @"
                {
                "dateTime" : "$DateTime",
                "timeZone" : "$timezone"
                }
"@ 
        }
        $body = @{
            parameters   = @{
                saveOriginalDisk          = $SaveOriginalDisk
                maxVMsRemovedDuringUpdate = $MaxVMsRemovedDuringUpdate
                maintenanceAlerts         = @()
                logOffDelayMinutes        = $LogoutDelayMinutes
                logOffMessage             = $LogOffMessage
                scheduledTime             = $ScheduledTime | ConvertFrom-Json
            }
            validateOnly = $false
        } | ConvertTo-Json
        $parameters = @{
            uri     = $url
            Method  = "POST"
            Headers = $token
            Body    = $body
        }
        $results = Invoke-RestMethod @parameters
        $results
    }
}
