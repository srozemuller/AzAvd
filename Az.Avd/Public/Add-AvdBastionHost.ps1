function Add-AvdBastionHost {
    <#
    .SYNOPSIS
    Adds an Azure Bastion host to the current AVD environment.
    .DESCRIPTION
    Based on hostpool information a Bastion host is created 
    .PARAMETER HostpoolName
    Enter the AVD hostpool name
    .PARAMETER ResourceGroupName
    Enter the AVD hostpool resourcegroup name
    .PARAMETER Id
    Enter the sessionhost's resource ID
    .PARAMETER BastionHostName
    Enter the tags to add. Provide an object.
    .PARAMETER BastionHostLocation
    Enter the sessionhost's name like avd-hostpool/avd-host-1.avd.domain

    .EXAMPLE
    Add-AvdSessionHostTags -HostpoolName avd-hostpool -ResourceGroupName rg-avd-01 -SessionHostName avd-hostpool/avd-host-1.avd.domain -Tags @{Tag="Value"}
    .EXAMPLE
    Add-AvdSessionHostTags -Id /subscriptions/...
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
        [string]$Id,
        
        [parameter(Mandatory)]
        [string]$BastionHostName,

        [parameter()]
        [string]$BastionHostLocation,

        [parameter()]
        [switch]$DisableCopyPaste,

        [parameter()]
        [string]$DnsName,

        [parameter()]
        [switch]$EnableFileCopy,

        [parameter()]
        [switch]$EnableIpConnect,

        [parameter()]
        [switch]$EnableShareableLink,
        
        [parameter()]
        [switch]$EnableTunneling,

        [parameter()]
        [int]$ScaleUnits,

        [parameter()]
        [string]$Sku = "Basic",

        [parameter(Mandatory)]
        [string]$PublicIpId,

        [parameter(Mandatory)]
        [string]$SubnetId
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
                Write-Error "Please provide a session host name or id"
            }
        }            
        $vnetBaseId = (Get-AvdNetworkInfo @parameters | Select-Object -First 1).VnetId 
        $vnetUri = "{0}{1}?api-version=2022-05-01" -f $Script:AzureApiUrl, $vnetBaseId
        $vnetBaseUrl = ($vnetBaseId | Select-String -Pattern '^(.*?)Microsoft.Network').Matches.Value
        $vnetInfo = Invoke-RestMethod -Uri $vnetUri -Method GET -Headers $token
        if (!$BastionHostLocation) {
            Write-Verbose "No location provided, picking current virtual network location"
            $BastionHostLocation = $vnetInfo.location
        }
        $ipconfig = @{
                name       = "IpConf"
                properties = @{
                    subnet          = @{
                        id = $SubnetId
                    }
                    publicIPAddress = @{
                        id = $PublicIpId
                    }
                }
            }
        $bastionBody = @{
            location   = $BastionHostLocation
            sku        = @{
                name = $Sku
            }
            properties = @{
                ipConfigurations = @(
                    $ipconfig
                )
            }
        }
        if ($DisableCopyPaste.IsPresent) { $bastionBody.properties.Add("disableCopyPaste", $true) }
        if ($null -ne $DnsName) { $bastionBody.properties.Add("dnsName", $DnsName) }
        if ($EnableFileCopy.IsPresent) { $bastionBody.properties.Add("EnableFileCopy", $true) }
        if ($EnableIpConnect.IsPresent) { $bastionBody.properties.Add("EnableIpConnect", $true) }
        if ($EnableShareableLink.IsPresent) { $bastionBody.properties.Add("EnableShareableLink", $true) }
        if ($EnableTunneling.IsPresent) { $EnableTunneling.properties.Add("EnableTunneling", $true) }
        if ($null -ne $ScaleUnits) { $bastionBody.properties.Add("ScaleUnits", $ScaleUnits) }

        try {
            $requestParameters = @{
                uri    = "{0}{1}/bastionHosts/{2}?api-version={3}" -f $Script:AzureApiUrl, $vnetBaseUrl, $BastionHostName , $apiVersion
                header = $token
            }
            $deployment = Invoke-RestMethod @requestParameters -Method PUT -Body ($bastionBody | ConvertTo-Json -Depth 10)
            do {
                Write-Information "Deploying Bastion host, status is: $($deployment.properties.provisioningState)" -InformationAction Continue
                $deployment = Invoke-RestMethod @requestParameters
                Start-Sleep 5
            }
            while ($deployment.properties.provisioningState -eq 'Updating')
            Write-Information "Bastion host deployed, status is: $($deployment.properties.provisioningState)" -InformationAction Continue   
        }
        catch {
            Write-Warning "Bastion host not created, $_"
        }
    }
}