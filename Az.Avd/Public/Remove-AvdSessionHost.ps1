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
    
        [parameter(Mandatory, ParameterSetName = 'Hostname', ValueFromPipelineByPropertyName)]
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
        [switch]$DeleteAssociated,

        [parameter(ParameterSetName = 'All')]
        [ValidateNotNullOrEmpty()]
        [switch]$Force

    )
    Begin {
        Write-Verbose "Start removing sessionhosts"
        AuthenticationCheck
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
                Write-Verbose "Starting $($_.name)"
                Remove-Resource -resourceId $_.properties.resourceId
                Write-Information -MessageData "$($_.name) deleted" -InformationAction Continue
                try {
                    if ($DeleteAssociated.IsPresent) {
                        Write-Verbose "Associated resources (disk & NIC) also will be removed"
                        Write-Verbose "Looking for network resources"
                        $_.vmResources.properties.networkprofile.networkInterfaces.id | ForEach-Object {
                            Remove-Resource -resourceId $_
                        }
                        Write-Verbose "Looking for OS disk"
                        Remove-Resource -resourceId $_.vmResources.properties.storageProfile.osDisk
                        Write-Verbose "Looking for data disks"
                        $_.vmResources.properties.storageProfile.dataDisks.ManagedDisk | ForEach-Object {
                            Remove-Resource -resourceId $_.id
                        }
                    }
                }
                catch {
                    Write-Error "Not able to remove associated resources, $_"
                }
            }
            catch {
                Throw "Not able to delete $($_.name), $_"
            }
        }
    }
}