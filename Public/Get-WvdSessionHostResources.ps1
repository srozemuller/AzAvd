#requires -module @{ModuleName = 'Az.Resources'; ModuleVersion = '3.2.1'}
function Get-WvdSessionHostResources {
    <#
    .SYNOPSIS
    Gets the Virtual Machines Azure resource from a WVD Session Host
    .DESCRIPTION
    The function will help you getting the virtual machine resource information which is behind the WVD Session Host
    .PARAMETER SessionHost
    Enter the WVD Session Host name
    .EXAMPLE
    Get-WvdSessionHostResources -SessionHost SessionHostObject
    Add a comment to existing incidnet
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory, ParameterSetName = 'Hostpool')]
        [parameter(Mandatory, ParameterSetName = 'Sessionhost')]
        [ValidateNotNullOrEmpty()]
        [string]$HostpoolName,

        [parameter(Mandatory, ParameterSetName = 'Hostpool')]
        [parameter(Mandatory, ParameterSetName = 'Sessionhost')]
        [ValidateNotNullOrEmpty()]
        [string]$ResourceGroupName,

        [parameter(Mandatory, ParameterSetName = 'Sessionhost')]
        [ValidateNotNullOrEmpty()]
        [string]$SessionHostName
    )
    
    Begin {
        Write-Verbose "Start searching"
        AuthenticationCheck
    }
    Process {
        switch ($PsCmdlet.ParameterSetName) {
            Hostpool {
                $HostpoolParameters = @{
                    HostPoolName      = $HostpoolName
                    ResourceGroupName = $ResourceGroupName
                }
            }
            Default {
                $SessionHostParameters = @{
                    HostPoolName      = $HostpoolName
                    ResourceGroupName = $ResourceGroupName
                    Name              = $SessionHostName
                }
            }
        }
        if ($HostpoolParameters) {
            Write-Verbose "Hostpool parameters provided"
            try {
                $SessionHosts = Get-AzWvdsessionhost @HostpoolParameters
            }
            catch {
                Throw "No WVD Hostpool found with name $Hostpoolname in resourcegroup $ResourceGroupName or no sessionhosts"
            }
        }
        if ($SessionHostParameters) {
            Write-Verbose "Sessionhost parameters provided"
            try {
                $SessionHosts = Get-AzWvdsessionhost @SessionHostParameters
            }
            catch {
                Throw "No WVD Hostpool found with name $Hostpoolname in resourcegroup $ResourceGroupName or no sessionhosts"
            }
        }
        $VirtualMachines = @()
        foreach ($SessionHost in $SessionHosts) {
            Write-Verbose "Searching for $($SessionHost.Name)"
            $HasLatestVersion, $IsVirtualMachine = $False
            try {
                $Resource = Get-AzResource -resourceId $SessionHost.ResourceId
            }
            catch {
                Throw "$SessionHost has no Virtual Machine resource"
            }
            $VirtualMachines += Get-AzVm -name $Resource.Name
        }
    }
    End {
        return $VirtualMachines
    }

}
