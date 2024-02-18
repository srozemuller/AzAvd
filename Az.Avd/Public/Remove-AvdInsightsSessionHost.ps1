function Remove-AvdInsightsSessionHost {
    <#
    .SYNOPSIS
    Removes the AVD session host from AVD Insights.
    .DESCRIPTION
    The function will removed the monitoring extension from the session host.
    .PARAMETER HostpoolName
    Enter the name of the AVD hostpool's name.
    .PARAMETER ResourceGroupName
    Enter the name of the resourcegroup where the hostpool resides in.
    .PARAMETER Id
    Enter the session host's resource ID (NOT VM).
    .PARAMETER Name
    Enter the name of the session host.
    .PARAMETER Force
    Use this switch to force delete ALL session hosts from AVD Insights
    .EXAMPLE
    Remove-AvdInsightsSessionHost -HostPoolName avd-hostpool-001 -ResourceGroupName rg-avd-001 -Force
    .EXAMPLE
    Remove-AvdInsightsSessionHost -HostPoolName avd-hostpool-001 -ResourceGroupName rg-avd-001 -Name avd-0
    .EXAMPLE
    Remove-AvdInsightsSessionHost -Id /subscriptions/../sessionhosts/avd-0 
    #>
    [CmdletBinding(DefaultParameterSetName = 'HostName')]
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

        [parameter(Mandatory, ParameterSetName = 'Resource', ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [string]$Id,

        [parameter(ParameterSetName = 'All')]
        [ValidateNotNullOrEmpty()]
        [switch]$Force
    )
    Begin {
        Write-Verbose "[Remove-AvdInsightsSessionHost] - Start removing sessionhosts from insights"
        AuthenticationCheck
        $token = GetAuthToken -resource $global:AzureApiUrl
        $sessionHostParameters = @{
            hostpoolName      = $HostpoolName
            resourceGroupName = $ResourceGroupName
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
                Throw "Please provide proper parameters, at lease a hostpool and resourcegroup name"
            }
        }
        try {
            $sessionHosts = Get-AvdSessionHostResources @sessionHostParameters
        }
        catch {
            Throw "No sessionhosts ($name) found in $HostpoolName ($ResourceGroupName), $_"
        }
        try {
            Write-Information "[Remove-AvdInsightsSessionHost] -  Sessionhosts found, removing from AVD Insights" -InformationAction Continue
            $sessionHosts | ForEach-Object {
                $vmObject = $_
                $vmPowerState = Get-AvdSessionHostPowerState -Id $vmObject.id
                if ($vmPowerState.powerstate -ne 'running') {
                    Write-Warning "[Remove-AvdInsightsSessionHost] - Sessionhost $($_.name) not running, starting machine from $($vmPowerState.powerstate) state"
                    Start-AvdSessionHost -Id $vmObject.id
                }
                $requestParameters = @{
                    uri     = "{0}{1}/extensions/{2}?api-version={3}" -f $global:AzureApiUrl, $_.vmResources.id, "OMSExtenstion", "2022-08-01"
                    Method  = "DELETE"
                    Headers = $token
                }
                Invoke-RestMethod @requestParameters
                switch ($vmPowerState.powerstate) {
                    stopped {
                        Write-Information "[Remove-AvdInsightsSessionHost] - Sessionhost was $($vmPowerState.powerstate), bringing back to initial state" -InformationAction Continue
                        Stop-AvdSessionHost -Id $vmObject.id
                    }
                    deallocated {
                        Write-Information "[Remove-AvdInsightsSessionHost] - Sessionhost was $($vmPowerState.powerstate), bringing back to initial state" -InformationAction Continue
                        Stop-AvdSessionHost -Id $vmObject.id -Deallocate
                    }
                    default {
                        Write-Information "[Remove-AvdInsightsSessionHost] - Sessionhost was $($vmPowerState.powerstate), taking no further action" -InformationAction Continue
                    }
                }
            }
        }
        catch {
            Throw "[Remove-AvdInsightsSessionHost] - $_"
        }
        
    }
}