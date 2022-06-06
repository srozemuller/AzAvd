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
                Write-Verbose "Got Name $Name"
                if ($Name -match '^(?:(?!\/).)*$') {
                    $Name = $Name.Split('/')[-1]
                    Write-Verbose "It looks like you also provided a hostpool, a sessionhost name is enough. Provided value {0}"
                    Write-Verbose "Picking only the hostname which is $Name"
                }
                else {
                    Write-Verbose "Session hostname provided, looking for sessionhost $Name"
                }
                $sessionHostParameters.Add("SessionhostName", $Name)
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
        ForEach ($sh in $sessionHosts) {
            try {
                Write-Verbose "Found $($sessionHosts.Count) host(s)"
                Write-Verbose "Starting $($sh.name), with id $($sh.id)"
                Remove-Resource -resourceId $sh.id -apiVersion "2022-02-10-preview"
                Write-Information -MessageData "$($sh.name) deleted" -InformationAction Continue
                Remove-Resource -resourceId $sh.vmresources.id -apiVersion "2022-03-01"
                Write-Information -MessageData "$($sh.name) deleted" -InformationAction Continue
                try {
                    if ($DeleteAssociated.IsPresent) {
                        Write-Warning "Delete associated resources provided."
                        Write-Verbose "Associated resources (disk & NIC) also will be removed"
                        Write-Information "Looking for network resources" -InformationAction Continue
                        $sh.vmResources.properties.networkprofile.networkInterfaces.id | ForEach-Object {
                            Remove-Resource -resourceId $_ -apiVersion "2022-01-01"
                        }
                        Write-Information "Looking for OS disk" -InformationAction Continue
                        Remove-Resource -resourceId $sh.vmResources.properties.storageProfile.osDisk
                        Write-Information "Looking for data disks" -InformationAction Continue
                        $sh.vmResources.properties.storageProfile.dataDisks.ManagedDisk | ForEach-Object {
                            Remove-Resource -resourceId $_.id -apiVersion "2022-03-02"
                        }
                    }
                }
                catch {
                    Write-Error "Not able to remove associated resources, $_"
                }
            }
            catch {
                Throw "Not able to delete $($sh.name), $_"
            }
        }
    }
}