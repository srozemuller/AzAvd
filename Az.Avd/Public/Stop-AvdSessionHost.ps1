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
    [CmdletBinding(DefaultParameterSetName = 'All')]
    param
    (
        [parameter(Mandatory, ParameterSetName = 'All')]
        [parameter(Mandatory, ParameterSetName = 'Resource', ValueFromPipelineByPropertyName)]
        [parameter(Mandatory, ParameterSetName = 'Hostname', ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [string]$HostpoolName,
    
        [parameter(Mandatory, ParameterSetName = 'All')]
        [parameter(Mandatory, ParameterSetName = 'Resource', ValueFromPipelineByPropertyName)]
        [parameter(Mandatory, ParameterSetName = 'Hostname', ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [string]$ResourceGroupName,
    
        [parameter(Mandatory, ParameterSetName = 'All')]
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
        Write-Verbose "Stopping session hosts"
        AuthenticationCheck
        $token = GetAuthToken -resource $Script:AzureApiUrl
        $sessionHostParameters = @{
            hostpoolName      = $HostpoolName
            resourceGroupName = $ResourceGroupName
        }
    }
    Process {
        switch ($PsCmdlet.ParameterSetName) {
            All {
                Write-Verbose "No specific host provided, starting all hosts in $hostpoolName"
                Write-Information -MessageData "HINT: use -Force to skip this message." -InformationAction Continue
                $confirmation = Read-Host "Are you sure you want to stop all session hosts? [y/n]"
                while ($confirmation -ne "y") {
                    if ($confirmation -eq 'n') { exit }
                    $confirmation = Read-Host "Yes/No? [y/n]"
                }
            }
            Hostname {
                if ($Name -match '^(?:(?!\/).)*$') {
                    $Name = $Name.Split('/')[-1]
                    Write-Verbose "It looks like you also provided a hostpool, a sessionhost name is enough. Provided value {0}"
                    Write-Verbose "Picking only the hostname which is $Name"
                }
                else {
                    Write-Verbose "Session hostname provided, looking for sessionhost $Name"
                }
                $sessionHostParameters.Add("Name", $Name)
            }
            Resource {
                Write-Verbose "Got a resource object, looking for $Id"
                $sessionHostParameters = @{
                    Id =  $Id
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
                Write-Verbose "Stopping $($_.name)"
                $apiVersion = "?api-version=2021-11-01"
                $powerOffParameters = @{
                    uri     = "{0}{1}/powerOff{2}" -f $Script:AzureApiUrl, $_.properties.resourceId, $apiVersion
                    Method  = "POST"
                    Headers = $token
                }
                Invoke-RestMethod @powerOffParameters
                Write-Information -MessageData "$($_.name) stopped" -InformationAction Continue
            }
            catch {
                Throw "Not able to stop $($_.name), $_"
            }
        }
    }       
}