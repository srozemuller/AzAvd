function Start-AvdSessionHost {
    <#
    .SYNOPSIS
    Starts AVD Session hosts in a specific hostpool.
    .DESCRIPTION
    This function starts sessionshosts in a specific Azure Virtual Desktop hostpool. If you want to start a specific session host then also provide the name, 
    .PARAMETER HostpoolName
    Enter the AVD Hostpool name
    .PARAMETER ResourceGroupName
    Enter the AVD Hostpool resourcegroup name
    .PARAMETER SessionHostName
    Enter the session hosts name
    .EXAMPLE
    Start-AvdSessionHost -HostpoolName avd-hostpool-personal -ResourceGroupName rg-avd-01
    .EXAMPLE
    Start-AvdSessionHost -HostpoolName avd-hostpool-personal -ResourceGroupName rg-avd-01 -SessionHostName avd-host-1.avd.domain
    #>
    [CmdletBinding(DefaultParameterSetName = 'All')]
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
        [ValidateNotNullOrEmpty()]
        [string]$Name,

        # [ValidatePattern('^(?:(?!\/).)*$', ErrorMessage = "It looks like you also provided a hostpool, a sessionhost name is enough. Provided value {0}")]
        [parameter(Mandatory, ParameterSetName = 'Resource', ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [object]$Id,

        [parameter(ParameterSetName = 'All')]
        [ValidateNotNullOrEmpty()]
        [switch]$Force
    )
    Begin {
        Write-Verbose "Starting session hosts"
        $sessionHostParameters = @{
            hostpoolName      = $HostpoolName
            resourceGroupName = $ResourceGroupName
        }
        $hostState = 'running'
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
            $sessionHosts = Get-AvdSessionHostResources @sessionHostParameters
        }
        catch {
            Throw "No sessionhosts ($name) found in $HostpoolName ($ResourceGroupName), $_"
        }
        $sessionHosts | ForEach-Object {
            try {
                Write-Verbose "[Start-AvdSessionHost] - Found $($sessionHosts.Count) host(s)"
                Write-Verbose "[Start-AvdSessionHost] - Starting $($_.name)"
                $apiVersion = "?api-version=2021-11-01"
                $powerOnParameters = @{
                    uri     = "{0}{1}/start{2}" -f $global:AzureApiUrl, $_.vmResources.id, $apiVersion
                    Method  = "POST"
                }
                Request-Api @powerOnParameters
                $initialState = Get-AvdSessionHostPowerState -Id $_.id
                if ($initialState.powerstate -eq $hostState) {
                    Write-Information "$($_.name) is already $hostState" -InformationAction Continue
                    Continue
                }
                else {
                    do {
                        $state = Get-AvdSessionHostPowerState -Id $_.id
                        Write-Information "[Start-AvdSessionHost] - Checking $($_.name) powerstate for $hostState, current state $($state.powerstate)" -InformationAction Continue
                        Start-Sleep 3
                    }
                    while ($state.powerstate -ne $hostState)
                }
            }
            catch {
                Throw "[Start-AvdSessionHost] - Not able to start $($_.name), $_"
            }
        }
    }
}