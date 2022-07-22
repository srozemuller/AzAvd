function Update-AvdScheduledAgentsUpdate {
    <#
    .SYNOPSIS
    Updates the scheduled agents update settings.
    .DESCRIPTION
    Updates the scheduled agents update settings in an Azure Virtual Desktop hostpool.
    .PARAMETER HostpoolName
    Enter the AVD Hostpool name
    .PARAMETER ResourceGroupName
    Enter the AVD Hostpool resourcegroup name
    .PARAMETER TimeZone
    Fill in a custom timezone, otherwise the session host's timezone is used
    .PARAMETER DayOfWeek
    Monday, Tuesday, etc.
    .PARAMETER Hour
    Provide an hour between 0-24 hours
    .PARAMETER ExtraDayOfWeek
    Extra schedule on Monday, Tuesday, etc.
    .PARAMETER ExtraHour
    Extra hour between 0-24
    .EXAMPLE
    Update-AvdScheduledAgentsUpdate -HostpoolName avd-hostpool -ResourceGroupName rg-avd-01 -DayOfWeek Sunday -Hour 2
    .EXAMPLE
    Update-AvdScheduledAgentsUpdate -HostpoolName avd-hostpool -ResourceGroupName rg-avd-01 -DayOfWeek Sunday -Hour 2 -ExtraDayOfWeek Monday -ExtraHour 5
    .EXAMPLE
    Update-AvdScheduledAgentsUpdate -HostpoolName avd-hostpool -ResourceGroupName rg-avd-01 -DayOfWeek Sunday -Hour 2 -Timezone "W. Europe Standard Time"
    #>
    [CmdletBinding(DefaultParameterSetName = "UserLocalTimeZone")]
    param
    (
        [parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$HostpoolName,
    
        [parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$ResourceGroupName,
    
        [parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$TimeZone,

        [parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [ValidateSet("Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday")]
        [string]$DayOfWeek,

        [parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [ValidatePattern('2[0-4]|1[0-9]|[1-9]')]
        [int]$Hour,


        [parameter(Mandatory, ParameterSetName = "AdditionalSchedule")]
        [ValidateNotNullOrEmpty()]
        [ValidateSet("Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday")]
        [string]$ExtraDayOfWeek,

        [parameter(Mandatory, ParameterSetName = "AdditionalSchedule")]
        [ValidateNotNullOrEmpty()]
        [ValidatePattern('2[0-4]|1[0-9]|[1-9]')]
        [int]$ExtraHour
    )
    Begin {
        Write-Verbose "Start searching"
        AuthenticationCheck
        $token = GetAuthToken -resource $Script:AzureApiUrl
        $url = "{0}/subscriptions/{1}/resourceGroups/{2}/providers/Microsoft.DesktopVirtualization/hostpools/{3}?api-version={4}" -f $Script:AzureApiUrl, $script:subscriptionId, $ResourceGroupName, $HostpoolName, $script:hostpoolApiVersion 
        $parameters = @{
            uri     = $url
            Headers = $token
        }
    }
    Process {
        if ($TimeZone) {
            $maintenanceWindowTimeZone = $TimeZone
            $useSessionHostLocalTime = $false
        }
        else {
            Write-Verbose "Local timezone used."
            $maintenanceWindowTimeZone = $null
            $useSessionHostLocalTime = $true
        }
        $body = @{
            properties = @{
                agentUpdate = @{
                    type        = "Scheduled"
                    maintenanceWindowTimeZone = $maintenanceWindowTimeZone
                    useSessionHostLocalTime   = $useSessionHostLocalTime
                    maintenanceWindows        = @(
                        @{
                            dayOfWeek = $DayOfWeek
                            hour      = $Hour
                        }
                    )
                }
            }
        }    
        if ($PSCmdlet.ParameterSetName -eq "AdditionalSchedule") {
            $additionalSchedule = @(
                @{
                    dayOfWeek = $ExtraDayOfWeek
                    hour      = $ExtraHour
                }
            )
            $body.properties.maintenanceWindows += $additionalSchedule
        }    
        $jsonBody = $body | ConvertTo-Json -Depth 5
        $jsonBody
        $parameters = @{
            uri     = $url
            Method  = "PATCH"
            Headers = $token
            Body    = $jsonBody
        }
        try {
            $results = Invoke-RestMethod @parameters
        }
        catch {
            Throw $_
        }
        $results
    }
}