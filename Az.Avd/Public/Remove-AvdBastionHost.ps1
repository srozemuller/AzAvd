function Remove-AvdBastionHost {
    <#
    .SYNOPSIS
    Removes an Azure Bastion host to the current AVD environment.
    .DESCRIPTION
    Based on hostpool information a Bastion host is removed 
    .PARAMETER HostpoolName
    Enter the AVD hostpool name
    .PARAMETER ResourceGroupName
    Enter the AVD hostpool resourcegroup name
    .PARAMETER Id
    Enter the AVD hostpool's resource ID
    .EXAMPLE
    Add-AvdSessionHostTags -HostpoolName avd-hostpool -ResourceGroupName rg-avd-01 -SessionHostName avd-hostpool/avd-host-1.avd.domain -Tags @{Tag="Value"}
    .EXAMPLE
    Get-AvdHostPool @avdParams | Remove-AvdBastionHost -DeletePublicIp -Verbose
    #>
    [CmdletBinding(DefaultParameterSetName = 'ResourceId')]
    param
    (
        [parameter(Mandatory, ParameterSetName = 'Name')]
        [ValidateNotNullOrEmpty()]
        [string]$HostpoolName,
    
        [parameter(Mandatory, ParameterSetName = 'Name')]
        [ValidateNotNullOrEmpty()]
        [string]$ResourceGroupName,

        [parameter(Mandatory, ParameterSetName = 'ResourceId', ValueFromPipelineByPropertyName)]
        [string]$Id
    )
    Begin {
        Write-Verbose "Start adding bastion host to AVD network"
        AuthenticationCheck
        $token = GetAuthToken -resource $Script:AzureApiUrl
        $apiVersion = "2022-05-01"
    }
    Process {
        switch ($PsCmdlet.ParameterSetName) {
            Name {
                $parameters = @{
                    HostPoolName      = $HostpoolName
                    ResourceGroupName = $ResourceGroupName
                }
            }
            ResourceId {
                $parameters = @{
                    HostpoolId = $Id
                }
            }
            default {
                Write-Error "Please provide a host pool name & resourcegroup or id"
            }
        }            
        $vnetBaseId = (Get-AvdNetworkInfo @parameters | Select-Object -First 1).VnetId 
        $vnetUri = "{0}{1}?api-version=2022-05-01" -f $Script:AzureApiUrl, $vnetBaseId
        $vnetBaseUrl = ($vnetBaseId | Select-String -Pattern '^(.*?)Microsoft.Network').Matches.Value
        $vnetInfo = Invoke-RestMethod -Uri $vnetUri -Method GET -Headers $token
        $bastionSubnet = $vnetInfo.properties.subnets.Where({ $_.Name -eq 'AzureBastionSubnet' })
        try {
            $requestParameters = @{
                uri    = "{0}{1}/bastionHosts?api-version={2}" -f $Script:AzureApiUrl, $vnetBaseUrl , $apiVersion
                header = $token
            }
            $bastionHosts = Invoke-RestMethod @requestParameters -Method GET
            $bHost = $bastionHosts.value | Where-Object { ($bastionSubnet.id -eq $_.properties.ipConfigurations.properties.subnet.id) } 
            $deleteParameters = @{
                uri    = "{0}{1}?api-version={2}" -f $Script:AzureApiUrl, $bHost.id , $apiVersion
                header = $token
            }
            Invoke-RestMethod @deleteParameters -Method DELETE
            Write-Information "Bastion host $($bhost.name) is removed from $($vnetInfo.name)" -InformationAction Continue
        }
        catch {
            Write-Error "Bastion host not removed, $_"
        }
    }
}