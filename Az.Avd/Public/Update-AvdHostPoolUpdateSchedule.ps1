function Update-AvdHostPoolUpdateSchedule {
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
Start-AvdHostPoolUpdate -Resourceid /subscriptions/xxx/resourceGroups/rg-avd/providers/Microsoft.DesktopVirtualization/hostpools/AVD-Hostpool/ -MaxVMsRemovedDuringUpdate 2
.EXAMPLE
Start-AvdHostPoolUpdate -Hostpoolname AVD-Hostpool -ResourceGroupName rg-avd -MaxVMsRemovedDuringUpdate 2
#>
    [CmdletBinding(DefaultParameterSetName = "ResourceID-Change")]
    param (
        [Parameter(Mandatory, ParameterSetName = "Name-Change")]
        [Parameter(Mandatory, ParameterSetName = "Name-Delete")]
        [ValidateNotNullOrEmpty()]
        [string]$HostPoolName,

        [Parameter(Mandatory, ParameterSetName = "Name-Change")]
        [Parameter(Mandatory, ParameterSetName = "Name-Delete")]
        [ValidateNotNullOrEmpty()]
        [string]$ResourceGroupName,

        [Parameter(Mandatory, ParameterSetName = "ResourceID-Change")]
        [Parameter(Mandatory, ParameterSetName = "ResourceID-Delete")]
        [ValidateNotNullOrEmpty()]
        [string]$ResourceId,

        [Parameter(Mandatory, ParameterSetName = "Name-Change")]
        [Parameter(Mandatory, ParameterSetName = "ResourceID-Change")]
        [datetime]$DateTime,

        [Parameter(ParameterSetName = "Name-Change")]
        [Parameter(ParameterSetName = "ResourceID-Change")]
        [string]$Timezone = [System.TimeZoneInfo]::Local.StandardName,

        [Parameter(Mandatory, ParameterSetName = "Name-Delete")]
        [Parameter(Mandatory, ParameterSetName = "ResourceID-Delete")]
        [switch]$Delete
    )
    Begin {
        Write-Verbose "Start searching for hostpool $hostpoolName"
        AuthenticationCheck
        $token = GetAuthToken -resource $script:AzureApiUrl
        switch -Wildcard ($PsCmdlet.ParameterSetName) {
            Name* {
                Write-Verbose "Name and ResourceGroup provided"
                $ResourceId = "/subscriptions/{0}/resourceGroups/{1}/providers/Microsoft.DesktopVirtualization/hostpools/{2}" -f $script:subscriptionId, $ResourceGroupName, $HostpoolName
            }
            ResourceId* {
                Write-Verbose "ResourceId provided, thank you :)"
            }
        }
        $url = "{0}{1}/update?api-version={2}" -f $script:AzureApiUrl, $ResourceId, $script:hostpoolUpdateApiVersion
        $controlUrl = "{0}{1}/controlUpdate?api-version={2}" -f $script:AzureApiUrl, $ResourceId, $script:hostpoolUpdateApiVersion
        $currentState = Get-AvdHostPoolUpdateState -ResourceId $ResourceId
        if (($currentState.updateProgress.UpdateStatus -eq "Scheduled") -or ($currentState.updateProgress.UpdateStatus -eq "InProgress")) {
            Write-Verbose "Hostpool update is schedule or in progress, cancelling update"
            $body = @{
                action  = "Cancel"
                message = $Message
            } | ConvertTo-Json
            $parameters = @{
                uri     = $controlUrl
                Method  = "POST"
                Headers = $token
                Body    = $body
            }
            $response = Invoke-WebRequest @parameters -SkipHttpErrorCheck
        }
        else {
            Write-Information "Hostpool update is not scheduled or in progress, no need to cancel" -InformationAction Continue
        }
    }
    Process {
        try {
            switch -Wildcard ($PsCmdlet.ParameterSetName) {
                *Change {
                    try {
                        Write-Verbose "Updating hostpool update schedule"
                        $currentConfig = Get-AvdHostpoolUpdate -ResourceId $ResourceId
                        $scheduledTime = @{
                            "dateTime" = $DateTime.ToString("yyyy-MM-ddTHH:mm:ssZ")
                            "timeZone" = $Timezone      
                        }
                        $currentConfig.hostPoolUpdateConfiguration.scheduledTime = $scheduledTime
                        $body = @{
                            parameters   = $currentConfig.hostPoolUpdateConfiguration
                            validateOnly = $false
                        } | ConvertTo-Json
                        $parameters = @{
                            uri     = $url
                            Method  = "POST"
                            Headers = $token
                            Body    = $body
                        }
                        $request = Invoke-WebRequest @parameters -SkipCertificateCheck
                        Write-Information "Hostpool update has been scheduled, was date: $($currentConfig.hostPoolUpdateConfiguration.ScheduledTime.dateTime), timeZone: $($currentConfig.hostPoolUpdateConfiguration.ScheduledTime.TimeZone)" -InformationAction Continue
                        $request
                    }
                    catch {
                        Write-Error "Something went wrong, please check the error below, $_"
                    }
                }
                *Delete {
                    if ($response.StatusCode -eq 204) {
                        Write-Information "Hostpool update schedule canceled, was date: $($currentConfig.hostPoolUpdateConfiguration.ScheduledTime.dateTime), timeZone: $($currentConfig.hostPoolUpdateConfiguration.ScheduledTime.TimeZone)" -InformationAction Continue
                    }
                    else {
                        Write-Error "Something went wrong, please check the error below"
                        Throw $response
                    }
                }
            }
        }
        catch {
            Write-Error $_.Exception
        }
    }
}
