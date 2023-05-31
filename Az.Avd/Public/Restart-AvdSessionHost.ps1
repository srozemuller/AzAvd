function Restart-AvdSessionHost {
    <#
    .SYNOPSIS
    Restarts AVD Session hosts in a specific hostpool.
    .DESCRIPTION
    This function restarts sessionshosts in a specific Azure Virtual Desktop hostpool. If you want to start a specific session host then also provide the name, 
    .PARAMETER HostpoolName
    Enter the AVD Hostpool name
    .PARAMETER ResourceGroupName
    Enter the AVD Hostpool resourcegroup name
    .PARAMETER SessionHostName
    Enter the session hosts name
    .EXAMPLE
    Restart-AvdSessionHost -HostpoolName avd-hostpool-personal -ResourceGroupName rg-avd-01
    .EXAMPLE
    Restart-AvdSessionHost -HostpoolName avd-hostpool-personal -ResourceGroupName rg-avd-01 -SessionHostName avd-host-1.avd.domain
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
    
        [parameter(Mandatory, ParameterSetName = 'All')]
        [parameter(Mandatory, ParameterSetName = 'Hostname')]
        [ValidateNotNullOrEmpty()]
        [string]$Name,

        [parameter(Mandatory, ParameterSetName = 'Resource', ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [object]$Id,

        [parameter(ParameterSetName = 'All')]
        [ValidateNotNullOrEmpty()]
        [switch]$Force
    )
    Begin {
        Write-Verbose "Starting session hosts"
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
                Write-Verbose "Restarting $($_.name)"
                $apiVersion = "?api-version=2021-11-01"
                $restartParameters = @{
                    uri     = "{0}{1}/restart{2}" -f $global:AzureApiUrl, $_.properties.resourceId, $apiVersion
                    Method  = "POST"
                    Headers = $token
                }
                Invoke-RestMethod @restartParameters
                Write-Information -MessageData "$($_.name) restarted" -InformationAction Continue
            }
            catch {
                Throw "Not able to restart $($_.name), $_"
            }
        }
    }       
}