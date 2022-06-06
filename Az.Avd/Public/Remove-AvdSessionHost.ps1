function Remove-AvdSessionHost {
    <#
    .SYNOPSIS
    Removing sessionhosts from an Azure Virtual Desktop hostpool.
    .DESCRIPTION
    The function will search for sessionhosts and will remove them from the Azure Virtual Desktop hostpool.
    .PARAMETER HostpoolName
    Enter the AVD Hostpool name
    .PARAMETER ResourceGroupName
    Enter the AVD Hostpool resourcegroup name
    .PARAMETER SessionHostName
    Enter the sessionhosts name
    .EXAMPLE
    Remove-AvdSessionHost -HostpoolName avd-hostpool-personal -ResourceGroupName rg-avd-01 -SessionHostName avd-host-1.avd.domain
    #>
    [CmdletBinding()]
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
        [parameter(ParameterSetName = 'Resource')]
        [parameter(ParameterSetName = 'Hostname')]
        [ValidateNotNullOrEmpty()]
        [switch]$DeleteResources,

        [parameter(ParameterSetName = 'All')]
        [ValidateNotNullOrEmpty()]
        [switch]$Force

    )
    Begin {
        Write-Verbose "Start removing sessionhosts"
        AuthenticationCheck
        $token = GetAuthToken -resource $Script:AzureApiUrl
        $apiVersion = "?api-version=2021-03-09-preview"
    }
    Process {
        switch ($PsCmdlet.ParameterSetName) {
            All {
                Write-Verbose "No specific host provided, starting all hosts in $hostpoolName"
                Write-Information -MessageData "HINT: use -Force to skip this message." -InformationAction Continue
                $confirmation = Read-Host "Are you sure you want to remove all session hosts? [y/n]"
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
                Write-Verbose "Starting $($_.name)"
                $apiVersion = "?api-version=2021-11-01"
                $deleteParameters = @{
                    uri     = "{0}{1}{2}" -f $Script:AzureApiUrl, $_.properties.resourceId, $apiVersion
                    Method  = "DELETE"
                    Headers = $token
                }
                Invoke-RestMethod @deleteParameters
                Write-Information -MessageData "$($_.name) deleted" -InformationAction Continue
            }
            catch {
                Throw "Not able to delete $($_.name), $_"
            }
        }
    }
}