function Grant-AvdSessionHost {
    <#
    .SYNOPSIS
    Assigns a user to a session host
    .DESCRIPTION
    The function assigns an user to an AVD session host
    .PARAMETER HostpoolName
    Enter the source AVD Hostpool name
    .PARAMETER ResourceGroupName
    Enter the source Hostpool resourcegroup name
    .PARAMETER AssignedUser
    Enter the new username for the current sessionhost. Only available if providing one sessionhost at a time. 
    .PARAMETER Name
    Enter the sessionhosts name avd-host-1.avd.domain
    .PARAMETER Id
    Enter 
    .EXAMPLE
    Grant-AvdSessionHost -HostpoolName avd-hostpool -ResourceGroupName rg-avd-01 -Name avd-hostpool/avd-host-1.avd.domain -AllowNewSession $true
    .EXAMPLE
    Grant-AvdSessionHost -HostpoolName avd-hostpool -ResourceGroupName rg-avd-01 -SessionHostName avd-hostpool/avd-host-1.avd.domain -AssignedUser "" -Force
    #>
    [CmdletBinding(DefaultParameterSetName = 'Hostname')]
    param
    (
        [parameter(Mandatory, ParameterSetName = 'Hostname')]
        [ValidateNotNullOrEmpty()]
        [string]$HostpoolName,
    
        [parameter(Mandatory, ParameterSetName = 'Hostname')]
        [ValidateNotNullOrEmpty()]
        [string]$ResourceGroupName,
    
        [parameter(Mandatory, ParameterSetName = 'Hostname')]
        [ValidateNotNullOrEmpty()]
        [string]$Name,

        [parameter(Mandatory, ParameterSetName = 'Hostname')]
        [parameter(Mandatory, ParameterSetName = 'Resource')]
        [AllowEmptyString()]
        [string]$AssignedUser,

        [parameter(Mandatory, ParameterSetName = 'Resource', ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [string]$Id        
    )
    Begin {
        Write-Verbose "Start moving session hosts"
        AuthenticationCheck
        $token = GetAuthToken -resource $global:AzureApiUrl
        $apiVersion = "2021-09-03-preview"
        if ($Force.IsPresent) {
            $forceString = "true"
        }
        else {
            $forceString = "false"
        }
        $sessionHostParameters = @{
            hostpoolName      = $HostpoolName
            resourceGroupName = $ResourceGroupName
        }
    }
    Process {
        switch ($PsCmdlet.ParameterSetName) {
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
            $sessionHost = Get-AvdSessionHost @sessionHostParameters
        }
        catch {
            Throw "No sessionhosts ($name) found in $HostpoolName ($ResourceGroupName), $_"
        }
        try {
            Write-Verbose "Found $($sessionHost.Count) host(s)"
            Write-Verbose "Starting $($_.name)"
            $body = @{
                properties = @{
                    AssignedUser = $AssignedUser
                }
            }
            $assignParameters = @{
                uri     = "{0}{1}/{2}&force={3}" -f $global:AzureApiUrl, $sessionHost.properties.resourceId, $apiVersion, $forceString
                Method  = "PATCH"
                Headers = $token
                Body    = $body | ConvertTo-Json
            }
            Invoke-RestMethod @assignParameters
            Write-Information -MessageData "$($_.name) stopped" -InformationAction Continue
        }
        catch {
            Throw "Not able to assign $AssignedUser to $($_.name), $_"
        }
    }
}
