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
        ForEach ($sh in $sessionHosts) {
            try {
                Write-Verbose "Found $($sessionHosts.Count) host(s)"
                Write-Verbose "Starting $($sh.name), with id $($sh.id)"
                Remove-Resource -resourceId $sh.id -apiVersion "2022-02-10-preview"
                Write-Information -MessageData "$($sh.name) deleted" -InformationAction Continue
                
                # Store VM resource ID for later verification
                $vmResourceId = $sh.vmresources.id
                Remove-Resource -resourceId $vmResourceId -apiVersion "2022-03-01"
                Write-Information -MessageData "VM $($sh.name) deletion initiated" -InformationAction Continue
                
                # Wait for VM to be actually deleted before proceeding with associated resources
                if ($DeleteAssociated.IsPresent) {
                    Write-Verbose "Waiting for VM deletion to complete..."
                    # seconds to wait
                    $maxWait = 60
                    $waited = 0
                    $vmDeleted = $false
                    
                    while (-not $vmDeleted -and $waited -lt $maxWait) {
                        Start-Sleep -Seconds 5
                        $waited += 5
                        try {
                            # Try to get the VM - if it fails, it's deleted
                            $testVm = Get-Resource -ResourceId $vmResourceId -ApiVersion "2022-03-01" -ErrorAction Stop
                            Write-Verbose "VM still exists, waiting... ($waited/$maxWait seconds)"
                        }
                        catch {
                            Write-Verbose "VM successfully deleted after $waited seconds"
                            $vmDeleted = $true
                        }
                    }
                    
                    if (-not $vmDeleted) {
                        Write-Warning "VM deletion check timed out after $maxWait seconds, proceeding anyway..."
                    }
                }
            }
            catch {
                "Not able to delete session host $($sh.name) from hostpool, $_"
                Continue
            }
            try {
                if ($DeleteAssociated.IsPresent) {
                    # Deallocate first before deleting all resources
                    if ($sh.vmresources.properties.instanceview.statuses.displayStatus -eq 'VM deallocated') {
                        Write-Warning "Delete associated resources provided."
                        Write-Verbose "Associated resources (disk & NIC) also will be removed"
                        
                        Write-Information "Looking for network resources" -InformationAction Continue
                        $sh.vmResources.properties.networkprofile.networkInterfaces.id | ForEach-Object {
                            $nicId = $_
                            Write-Verbose "Removing NIC: $nicId"
                            $maxRetries = 3
                            $retryCount = 0
                            $removed = $false
                            
                            while (-not $removed -and $retryCount -lt $maxRetries) {
                                try {
                                    Remove-Resource -resourceId $nicId -apiVersion "2022-01-01"
                                    Write-Information "NIC removed: $nicId" -InformationAction Continue
                                    $removed = $true
                                }
                                catch {
                                    $retryCount++
                                    if ($retryCount -lt $maxRetries) {
                                        Write-Warning "Failed to remove NIC (attempt $retryCount/$maxRetries) - it may still be attached. Waiting 10 seconds..."
                                        Start-Sleep -Seconds 10
                                    }
                                    else {
                                        Write-Error "Failed to remove NIC after $maxRetries attempts: $_"
                                    }
                                }
                            }
                        }
                        
                        Write-Information "Looking for OS disk" -InformationAction Continue
                        Remove-Resource -resourceId $sh.vmResources.properties.storageProfile.osDisk.managedDisk.id -apiVersion "2022-03-02"
                        Write-Information "Looking for data disks" -InformationAction Continue
                        if ($sh.vmResources.properties.storageProfile.dataDisks.ManagedDisk) {
                            Write-Verbose "Data disks found, removing them also"
                            $sh.vmResources.properties.storageProfile.dataDisks.ManagedDisk.id | ForEach-Object {
                                Remove-Resource -resourceId $_ -apiVersion "2022-03-02"
                            }
                        }
                    }
                    else {
                        Write-Warning "Skipped resources removal for session host $($sh.name), VM is not deallocated"
                    }
                }
            }
            catch {
                Write-Error "Not able to remove associated resources, properly allready removed, $_"
                Continue
            }
        }
    }
}