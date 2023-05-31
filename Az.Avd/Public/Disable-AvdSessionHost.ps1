function Disable-AvdSessionHost {
    <#
    .SYNOPSIS
    Disable login for sessionhosts.
    .DESCRIPTION
    The function sets a session host into drainmode, which means that users are not able to login to that host. 
    .PARAMETER HostpoolName
    Enter the source AVD Hostpool name
    .PARAMETER ResourceGroupName
    Enter the source Hostpool resourcegroup name
    .PARAMETER Name
    Enter the sessionhosts name avd-host-1.avd.domain
    .PARAMETER Id
    Enter the session host's resource ID
    .PARAMETER Force
    Use the -Force switch to disable session hosts without interaction
    .EXAMPLE
    Disable-AvdSessionHost -HostpoolName avd-hostpool -ResourceGroupName rg-avd-01 -Name avd-host-1.avd.domain
    .EXAMPLE
    Disable-AvdSessionHost -HostpoolName avd-hostpool -ResourceGroupName rg-avd-01 -Force
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
        Write-Verbose "Ssession hosts"
        AuthenticationCheck
        $token = GetAuthToken -resource $global:AzureApiUrl
        $apiVersion = "?api-version=2022-02-10-preview"
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
        }
        try {
            $sessionHosts = Get-AvdSessionHost @sessionHostParameters
        }
        catch {
            Throw "No sessionhosts ($name) found in $HostpoolName ($ResourceGroupName), $_"
        }
        try {
            $sessionHosts | ForEach-Object {
                Write-Verbose "Found $($_.Count) host(s)"
                Write-Verbose "Disable login for $($_.name)"
                $body = @{
                    properties = @{
                        AllowNewSession = $false
                    }
                }
                $disableParameters = @{
                    uri     = "{0}{1}{2}" -f $global:AzureApiUrl, $_.id, $apiVersion
                    Method  = "PATCH"
                    Headers = $token
                    Body    = $body | ConvertTo-Json
                }
                Invoke-RestMethod @disableParameters
                Write-Information -MessageData "Login is disabled for $($_.name)" -InformationAction Continue
            }
        }
        catch {
            Throw "Not able to disable login for $($_.name), $_"
        }
    }
}
