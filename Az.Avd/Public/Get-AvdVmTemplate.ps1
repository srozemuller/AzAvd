function Get-AvdVmTemplate {
    <#
    .SYNOPSIS
    Gets a VM template from an AVD hostpool. 
    .DESCRIPTION
    The function will search for an AVD VM template based on a hostpool
    .PARAMETER HostpoolName
    Enter the AVD Hostpool name
    .PARAMETER ResourceGroupName
    Enter the AVD Hostpool resourcegroup name
    .EXAMPLE
    Get-AvdVmTemplate -hostpoolname avd-hostpool -ResourceGroupName rg-avd-01
    #>
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$HostpoolName,
    
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$ResourceGroupName
    )
    Begin {
        Write-Verbose "Start searching for a VM template in $HostpoolName"
        AuthenticationCheck
        $hostpoolParameters = @{
            HostPoolName = $HostpoolName
            ResourceGroupName = $ResourceGroupName
        }
    }
    Process {
        try {
            Write-Information "Get VM template from hostpool $HostpoolName"
            $vmtemplate = Get-AvdHostPool @hostpoolParameters | Select-Object @{N="vmTemplate";E={$_.properties.vmtemplate}}
            $vmtemplate.vmTemplate | ConvertFrom-Json
        }
        catch {
            "Template not found, $_"
        }
    }
}