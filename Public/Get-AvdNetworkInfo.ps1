#requires -module @{ModuleName = 'Az.ResourceGraph'; ModuleVersion = '0.7.6'}
Function Get-AvdNetworkInfo {
    <#
    .SYNOPSIS
    Gets the sessionhost network information 
    .DESCRIPTION
    The function will help you getting insights about the AVD network configuration. 
    .PARAMETER HostpoolName
    Enter the AVD Hostpool name
    .PARAMETER ResourceGroupName
    Enter the AVD Hostpool resourcegroup name
    .PARAMETER SessionHostName
    This parameter accepts a single sessionhost name
    .EXAMPLE
    Get-AvdNetworkInfo -HostpoolName <string> -ResourceGroupName <string>
    .EXAMPLE
    Get-AvdNetworkInfo -HostpoolName <string> -ResourceGroupName <string> -SessionHostName <string>
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

        [parameter(ParameterSetName = 'Sessionhost')]
        [ValidateNotNullOrEmpty()]
        [string]$SessionHostName
    )
    Begin {
        Write-Verbose "Start searching"
        AuthenticationCheck
    }
    Process {
        switch ($PsCmdlet.ParameterSetName) {
            Sessionhost {
                $Parameters = @{
                    HostPoolName      = $HostpoolName
                    ResourceGroupName = $ResourceGroupName
                    Name              = $SessionHostName
                }
            }
            Default {
                $Parameters = @{
                    HostPoolName      = $HostpoolName
                    ResourceGroupName = $ResourceGroupName
                }
            }
        }
        try {
            $SessionHosts = Get-AzWvdSessionHost @Parameters
        }
        catch {
            Throw "No sessionhosts found, $_"
        }
        $sessionhostsIds = [system.String]::Join("`",`"", $SessionHosts.ResourceId)
        $Query = 
        'resources
        | where type =~ "microsoft.compute/virtualmachines"
        and id in~ ("'+ $sessionhostsIds + '")
        | project vmId=tolower(id), vmName=name, vmResourceGroup=resourceGroup
        | join kind=leftouter(
            resources
            | where type =~ "microsoft.network/networkinterfaces"
            | extend vmId = tolower(properties.virtualMachine.id)
            | mv-expand ipConfig = properties.ipConfigurations
            | extend subnets = ipConfig.properties.subnet
            | extend ipAddress = ipConfig.properties.privateIPAddress
            | extend subnetName = split(subnets.id,"/")[-1]
            | project subnetId = tostring(subnets.id), tostring(vmId), nicName=name, ipAddress, nicId=id, subnetName
            | join kind=leftouter(
                resources
                | where type =~ "microsoft.network/networksecuritygroups"
                | extend subnet = properties.subnets
                | mvexpand subnet
                | project subnetId = tostring(subnet.id), nsgName=name, nsgId=id
            ) on subnetId
        ) on vmId
        | project vmId, vmName,vmResourceGroup,ipAddress, nicName, nicId, subnetName, subnetId, nsgName, nsgId
        '
        $Result = Search-AzGraph -Query $Query
        return $Result 
    }
}
