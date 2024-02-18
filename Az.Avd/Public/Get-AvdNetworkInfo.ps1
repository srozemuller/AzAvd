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
    Get-AvdNetworkInfo -HostpoolName avd-hostpool -ResourceGroupName hostpool-resourcegroup
    .EXAMPLE
    Get-AvdNetworkInfo -HostpoolName avd-hostpool -ResourceGroupName hostpool-resourcegroup -SessionHostName avd-0.domain.local
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
        Write-Verbose "Start searching for networkinfo."
        AuthenticationCheck
        $token = GetAuthToken -resource $global:AzureApiUrl
        $apiVersion = "?api-version=2021-03-01"
    }
    Process {
        switch ($PsCmdlet.ParameterSetName) {
            Sessionhost {
                $Parameters = @{
                    HostPoolName      = $HostpoolName
                    ResourceGroupName = $ResourceGroupName
                    Name   = $SessionHostName
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
            $SessionHosts = Get-AvdSessionHostResources @Parameters
        }
        catch {
            Throw "No sessionhosts found, $_"
        }
        $SessionHosts | ForEach-Object {
            $nicParameters = @{
                uri = $global:AzureApiUrl + $_.vmResources.properties.networkprofile.networkinterfaces.id + $apiVersion
                Headers = $token    
                Method = "GET"
            }
            $nsgNicParameters = @{
                uri = $global:AzureApiUrl + $_.vmResources.properties.networkprofile.networkinterfaces.id + "/effectiveNetworkSecurityGroups" + $apiVersion
                Headers = $token    
                Method = "POST"
            }

            $requestNicInfo = Invoke-RestMethod @nicParameters
            try {
                $requestNicNsgInfo = (Invoke-RestMethod @nsgNicParameters).value
            }
            catch {
                $requestNicNsgInfo = $false
            }
            $networkInfo = $requestNicInfo.properties.ipConfigurations.properties
            $networkInfo | Add-Member -NotePropertyName nicId -NotePropertyValue $requestNicInfo.Id
            $networkInfo | Add-Member -NotePropertyName nicNsg -NotePropertyValue $requestNicNsgInfo

            $nsgSubnetParameters = @{
                uri = $global:AzureApiUrl+ $networkInfo.subnet.id + $apiVersion
                Headers = $token    
                Method = "GET"
            }
            $nsgSubnetInfo = Invoke-RestMethod @nsgSubnetParameters
            $result = [PSCustomObject]@{
                SessionHostName = $_.Name
                Id = $_.id
                VnetId = $nsgSubnetInfo.id -replace "/subnets/{0}" -f $nsgSubnetInfo.name,$null
                NetworkCardInfo = $networkInfo
                SubnetInfo = $nsgSubnetInfo
            }
            $result
        }
    }
}
