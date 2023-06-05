function Stop-AvdSessionHost {
    <#
    .SYNOPSIS
    Stops AVD Session hosts in a specific hostpool.
    .DESCRIPTION
    This function stops sessionshosts in a specific Azure Virtual Desktop hostpool. If you want to start a specific session host then also provide the name, 
    .PARAMETER HostpoolName
    Enter the AVD Hostpool name
    .PARAMETER ResourceGroupName
    Enter the AVD Hostpool resourcegroup name
    .PARAMETER SessionHostName
    Enter the session hosts name
    .EXAMPLE
    Stop-AvdSessionHost -HostpoolName avd-hostpool-personal -ResourceGroupName rg-avd-01
    .EXAMPLE
    Stop-AvdSessionHost -HostpoolName avd-hostpool-personal -ResourceGroupName rg-avd-01 -SessionHostName avd-host-1.avd.domain
    #>
    [CmdletBinding(DefaultParameterSetName = 'Hostname')]
    param
    (
        [parameter(Mandatory, ParameterSetName = 'All')]
        [parameter(Mandatory, ParameterSetName = 'Hostname')]
        [ValidateNotNullOrEmpty()]
        [string]$HostpoolName,

        [parameter(Mandatory, ParameterSetName = 'All')]
        [parameter(Mandatory, ParameterSetName = 'Hostname')]
        [ValidateNotNullOrEmpty()]
        [string]$ResourceGroupName,

        [parameter(Mandatory, ParameterSetName = 'Hostname')]
        [parameter(Mandatory, ParameterSetName = 'All')]
        [ValidateNotNullOrEmpty()]
        [string]$Name,

        # [ValidatePattern('^(?:(?!\/).)*$', ErrorMessage = "It looks like you also provided a hostpool, a sessionhost name is enough. Provided value {0}")]
        [parameter(Mandatory, ParameterSetName = 'Resource', ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [object]$Id,

        [parameter(ParameterSetName = 'All')]
        [parameter(ParameterSetName = 'Resource')]
        [parameter(ParameterSetName = 'Hostname')]
        [ValidateNotNullOrEmpty()]
        [switch]$Deallocate,

        [parameter(ParameterSetName = 'All')]
        [ValidateNotNullOrEmpty()]
        [switch]$Force
    )
    Begin {
        Write-Verbose "Stopping session hosts"
        $sessionHostParameters = @{
            hostpoolName      = $HostpoolName
            resourceGroupName = $ResourceGroupName
        }
        $task = 'powerOff'
        $hostState = 'stopped'
        if ($Deallocate.IsPresent) {
            $task = 'deallocate'
            $hostState = 'deallocated'
        }
    }
    Process {
        switch ($PsCmdlet.ParameterSetName) {
            All {
                CheckForce -Force:$force -Task $MyInvocation.MyCommand
            }
            Hostname {
                $Name = ConcatSessionHostName -name $Name
                $sessionHostParameters.Add("Name", $Name)
            }
            Resource {
                Write-Verbose "Got a resource object, looking for $Id"
                $sessionHostParameters = @{
                    Id = $Id
                }
            }
            default {
            }
        }
        try {
            $sessionHosts = Get-AvdSessionHost @sessionHostParameters
        }
        catch {
            Throw "No sessionhosts ($name) found in $HostpoolName ($ResourceGroupName), $_"
        }
        $sessionHosts | ForEach-Object {
            try {
                Write-Verbose "Found $($sessionHosts.Count) host(s)"
                Write-Verbose "Stopping host $($_.name)"
                $powerOffParameters = @{
                    uri     = "{0}{1}/{2}?api-version={3}" -f $global:AzureApiUrl, $_.properties.resourceId, $task, $global:vmApiVersion
                    Method  = "POST"
                }
                Request-Api @powerOffParameters
                $initialState = Get-AvdSessionHostPowerState -Id $_.id
                if ($initialState.powerstate -eq $hostState) {
                    Write-Information "$($_.name) is already $hostState" -InformationAction Continue
                    Continue
                }
                else {
                    do {
                        $state = Get-AvdSessionHostPowerState -Id $_.id
                        Write-Information "[Stop-AvdSessionHost] - Checking $($_.name) powerstate for $hostState, current state $($state.powerstate)" -InformationAction Continue
                        Start-Sleep 3
                    }
                    while ($state.powerstate -ne $hostState)
                }
            }
            catch {
                Continue
                "Not able to stop $($_.name), $_"
            }
        }
    }
}