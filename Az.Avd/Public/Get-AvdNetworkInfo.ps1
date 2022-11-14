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

        [Parameter(Mandatory, ParameterSetName = "ResourceId")]
        [ValidateNotNullOrEmpty()]
        [string]$HostpoolId
    )
    Begin {
        Write-Verbose "Start searching for networkinfo."
        AuthenticationCheck
        $token = GetAuthToken -resource $script:AzureApiUrl
        $apiVersion = "?api-version=2021-03-01"
        $totalResults = [System.Collections.ArrayList]@()
    }
    Process {
        switch ($PsCmdlet.ParameterSetName) {
            Sessionhost {
                $parameters = @{
                    HostPoolName      = $HostpoolName
                    ResourceGroupName = $ResourceGroupName
                    Name   = $SessionHostName
                }
            }
            Hostpool {
                $parameters = @{
                    HostPoolName      = $HostpoolName
                    ResourceGroupName = $ResourceGroupName
                }
            }
            ResourceId {
                $parameters = @{
                    HostpoolId  = $HostpoolId
                }
            }
            default {
                Write-Error "Please provide a hostpool and hostpool resourcegroup or, hostpool resourceId"
            }
        }
        try {
            $SessionHosts = Get-AvdSessionHostResources @parameters
        }
        catch {
            Throw "No sessionhosts found, $_"
        }
        $SessionHosts | ForEach-Object {
            $nicParameters = @{
                uri = $script:AzureApiUrl + $_.vmResources.properties.networkprofile.networkinterfaces.id + $apiVersion
                Headers = $token    
                Method = "GET"
            }
            $nsgNicParameters = @{
                uri = $script:AzureApiUrl + $_.vmResources.properties.networkprofile.networkinterfaces.id + "/effectiveNetworkSecurityGroups" + $apiVersion
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
                uri = $Script:AzureApiUrl+ $networkInfo.subnet.id + $apiVersion
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
            $totalResults.Add($result) | Out-Null
        }
    }
    End {
        $totalResults
    }
}
