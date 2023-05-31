function Get-AvdSessionHostPowerState {
    <#
    .SYNOPSIS
    Get AVD Session host's powerstate.
    .DESCRIPTION
    Searches for a specific session host or all sessions hosts in a AVD hostpool and returns the current power state.
    .PARAMETER HostpoolName
    Enter the AVD Hostpool name
    .PARAMETER ResourceGroupName
    Enter the AVD Hostpool resourcegroup name
    .PARAMETER SessionHostName
    Enter the session host's name
    .PARAMETER Id
    Enter the session host's resource ID
    .EXAMPLE
    Get-AvdSessionHostPowerState -HostpoolName avd-hostpool-personal -ResourceGroupName rg-avd-01
    .EXAMPLE
    Get-AvdSessionHostPowerState -HostpoolName avd-hostpool-personal -ResourceGroupName rg-avd-01 -Name avd-host-1.avd.domain
    .EXAMPLE
    Get-AvdSessionHostPowerState -Id /subscriptions/../sessionhosts/avd-0 
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
        [object]$Id
    )
    Begin {
        Write-Verbose "[Get-AvdSessionHostPowerState] - Check session host's powerstate"
        $sessionHostParameters = @{
            hostpoolName      = $HostpoolName
            resourceGroupName = $ResourceGroupName
        }
        $returnObject = [System.Collections.ArrayList]@()
    }
    Process {
        switch ($PsCmdlet.ParameterSetName) {
            Hostname {
                $Name = ConcatSessionHostName -name $Name
                $sessionHostParameters.Add("Name", $Name)
            }
            Resource {
                Write-Verbose "[Get-AvdSessionHostPowerState] - Got a resource object, looking for $Id"
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
            Throw "[Get-AvdSessionHostPowerState] - No sessionhosts ($name) found in $HostpoolName ($ResourceGroupName), $_"
        }
        $sessionHosts | ForEach-Object {
            try {
                Write-Verbose "[Get-AvdSessionHostPowerState] - Found $($sessionHosts.Count) host(s)"
                $apiVersion = "?api-version=2021-11-01"
                $powerParameters = @{
                    uri     = "{0}{1}/instanceView{2}" -f $global:AzureApiUrl, $_.vmResources.id, $apiVersion
                    Method  = "GET"
                }
                $VmObject = Request-Api @powerParameters
                $powerState = $VmObject.statuses.code.Where({ $_ -match 'PowerState' })
                if ($powerState) {
                    $state = $powerState.Replace('PowerState/', $null)
                }
                $powerObject = @{
                    name       = $_.name
                    powerstate = $state
                }
                $returnObject.Add($powerObject) | Out-Null
            }
            catch {
                Throw "[Get-AvdSessionHostPowerState] - Not able to get powerstate from $($_.name), $_"
            }
        }
    }
    End {
        $returnObject
    }
}