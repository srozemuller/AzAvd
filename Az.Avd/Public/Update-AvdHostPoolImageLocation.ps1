function Update-AvdHostPoolImageLocation {
    <#
.SYNOPSIS
Get AVD Hostpool information.
.DESCRIPTION
With this function you can get information about an AVD hostpool.
.PARAMETER HostPoolName
Enter the name of the hostpool you want information from.
.PARAMETER ResourceGroupName
Enter the name of the resourcegroup where the hostpool resides in.
.PARAMETER ResourceId
Enter the hostpool ResourceId
.PARAMETER ImageResourceId
Enter the image gallery resource id
.EXAMPLE
Update-AvdHostPoolImageLocation -HostPoolName avd-hostpool-001 -ResourceGroupName rg-avd-001 -ImageResourceId "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-avd-001/providers/Microsoft.Compute/galleries/avd-image-gallery/images/avd-image"
.EXAMPLE
Update-AvdHostPoolImageLocation -ResourceId "/subscription/../HostPoolName" -ImageResourceId "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-avd-001/providers/Microsoft.Compute/galleries/avd-image-gallery/images/avd-image/versions/1.0.0"
#>
    [CmdletBinding(DefaultParameterSetName = "Name")]
    param (
        [Parameter(Mandatory, ParameterSetName = "Name")]
        [ValidateNotNullOrEmpty()]
        [string]$HostPoolName,

        [Parameter(Mandatory, ParameterSetName = "Name")]
        [ValidateNotNullOrEmpty()]
        [string]$ResourceGroupName,

        [Parameter(Mandatory, ParameterSetName = "ResourceId")]
        [ValidateNotNullOrEmpty()]
        [string]$ResourceId,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$ImageResourceId
    )
    Begin {
        Write-Verbose "Start searching for hostpool $hostpoolName"
        AuthenticationCheck
        $token = GetAuthToken -resource $script:AzureApiUrl
        switch ($PsCmdlet.ParameterSetName) {
            Name {
                Write-Verbose "Name and ResourceGroup provided"
                $ResourceId = "/subscriptions/{1}/resourceGroups/{2}/providers/Microsoft.DesktopVirtualization/hostpools/{3}" -f $script:subscriptionId, $ResourceGroupName, $HostpoolName
                $url = "{0}{1}/sessionHostConfigurations/default?api-version={4}" -f $script:AzureApiUrl, $ResourceId, $script:hostpoolUpdateApiVersion
                id = "{0}/sessionHostConfigurations/default" -f $ResourceId 
            }
            ResourceId {
                Write-Verbose "ResourceId provided, thank you for that :)"
                $url = "{0}{1}/sessionHostConfigurations/default?api-version={2}" -f $script:AzureApiUrl, $ResourceId, $script:hostpoolUpdateApiVersion
                $id = $ResourceId
                Write-Verbose "Url: $url"
                Write-Verbose "Id: $id"
            }
        }
        try {
            TestAzResource -resourceId $ImageResourceId -apiVersion "2022-08-03" | Out-Null
        }
        catch {
            Throw "Resource $ImageResourceId does not exist, $_"
        }
    }
    Process {
        try {
            $currentConfig = Get-AvdHostPoolUpdateConfiguration -ResourceId $ResourceId
            $currentConfig.properties.imageInfo.customInfo.resourceId = $ImageResourceId
            $body = @{
                id = "{0}/sessionHostConfigurations/default" -f $id
                name = "{0}/default" -f $ResourceId
                type = "Microsoft.DesktopVirtualization/sessionHostConfigurations"
            }
            $body.Add("properties", $currentConfig.properties)
            $parameters = @{
                uri     = $url
                Method  = "PUT"
                Headers = $token
                Body    = $body | ConvertTo-Json -Depth 4
            }
            $results = Invoke-WebRequest @parameters -SkipHttpErrorCheck
            $results
        }
        catch {
            Write-Error $_.Exception.Response
        }
    }
}
