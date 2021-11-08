#requires -module @{ModuleName = 'Az.Resources'; ModuleVersion = '3.2.1'}
function Get-AvdSessionHostResources {
    <#
    .SYNOPSIS
    Gets the Virtual Machines Azure resource from a AVD Session Host
    .DESCRIPTION
    The function will help you getting the virtual machine resource information which is behind the AVD Session Host
    .PARAMETER HostpoolName
    Enter the AVD hostpool name
    .PARAMETER ResourceGroupName
    Enter the AVD hostpool resourcegroup
    .PARAMETER SessionHostName
    Enter the AVD Session Host name
    .EXAMPLE
    Get-AvdSessionHostResources -Hostpoolname avd-hostpool -ResourceGroup rg-avd-01
    .EXAMPLE
    Get-AvdSessionHostResources -Hostpoolname avd-hostpool -ResourceGroup rg-avd-01
    #>
    [CmdletBinding(DefaultParameterSetName = 'Hostpool')]
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
        AuthenticationCheck
    }
    Process {
        switch ($PsCmdlet.ParameterSetName) {
            Hostpool {
                $Parameters = @{
                    HostPoolName      = $HostpoolName
                    ResourceGroupName = $ResourceGroupName
                }
            }
            Sessionhost {
                $Parameters = @{
                    HostPoolName      = $HostpoolName
                    ResourceGroupName = $ResourceGroupName
                    SessionHostName   = $SessionHostName
                }
            }
        }
        $SessionHosts = Get-AvdSessionhost @Parameters
        if ($sessionHosts) {
            $VirtualMachines = @()
            $SessionHosts | Foreach-Object {
                Write-Verbose "Searching for $($_.Name)"
                $HasLatestVersion, $IsVirtualMachine = $False
                try {
                    $Resource = Get-AzResource -resourceId $_.Properties.ResourceId
                }
                catch {
                    Throw "$($_.Name) has no Virtual Machine resource"
                }
                $VirtualMachines += Get-AzVm -name $Resource.Name
            }
        }
        else {
            Write-Error "No AVD Hostpool found with name $Hostpoolname in resourcegroup $ResourceGroupName or no sessionhosts"
        }
    }
    End {
        $VirtualMachines
    }
}
