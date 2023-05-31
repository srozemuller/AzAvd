function Add-AvdSessionHostTags {
    <#
    .SYNOPSIS
    Add tags to the session host's VM resource
    .DESCRIPTION
    Based on the session host name, remove tags to the VM resource.
    .PARAMETER HostpoolName
    Enter the AVD hostpool name
    .PARAMETER ResourceGroupName
    Enter the AVD hostpool resourcegroup name
    .PARAMETER Tags
    Enter the tags to add. Provide an object.
    .PARAMETER SessionHostName
    Enter the sessionhost's name like avd-hostpool/avd-host-1.avd.domain
    .PARAMETER Id
    Enter the sessionhost's resource ID
    .EXAMPLE
    Add-AvdSessionHostTags -HostpoolName avd-hostpool -ResourceGroupName rg-avd-01 -SessionHostName avd-hostpool/avd-host-1.avd.domain -Tags @{Tag="Value"}
    .EXAMPLE
    Add-AvdSessionHostTags -Id /subscriptions/...
    #>
    [CmdletBinding(DefaultParameterSetName = 'Id')]
    param
    (
        [parameter(Mandatory, ParameterSetName = 'Name')]
        [ValidateNotNullOrEmpty()]
        [string]$HostpoolName,
    
        [parameter(Mandatory, ParameterSetName = 'Name')]
        [ValidateNotNullOrEmpty()]
        [string]$ResourceGroupName,

        [parameter(Mandatory, ParameterSetName = 'Id', ValueFromPipelineByPropertyName)]
        [string]$Id,
        
        [parameter(Mandatory, ParameterSetName = 'Name')]
        [string]$SessionHostName,

        [parameter(Mandatory)]
        [object]$Tags
    )
    Begin {
        Write-Verbose "Start adding tags to session hosts"
        AuthenticationCheck
        $token = GetAuthToken -resource $global:AzureApiUrl
        $apiVersion = "2022-08-01"
    }
    Process {
        switch ($PsCmdlet.ParameterSetName) {
            Id {
                $sessionHosts = Get-AvdSessionHostResources -Id $SessionHostId
            }
            Name {
                $sessionHosts = Get-AvdSessionHostResources -HostpoolName $HostpoolName -ResourceGroupName $ResourceGroupName -Name $SessionHostName
            }
            default {
                Write-Error "Please provide a session host name or id"
            }
        }       
        $updateBody = @{
            tags = $Tags
        } 
        $sessionHosts | Foreach-Object {
            Write-Verbose "Searching for $($_.Name)"
            $updateBody.Add('location',$_.vmResources.location)
            try {
                $requestParameters = @{
                    uri    = "{0}{1}?api-version={2}" -f $global:AzureApiUrl, $_.vmResources.id, $apiVersion
                    header = $token
                    method = "PUT"
                    body   = $updateBody | ConvertTo-Json -Depth 5
                }
                Invoke-RestMethod @requestParameters 
            }
            catch {
                Write-Warning "Sessionhost $($_.vmResources.name) not updated, $_"
            }
        }
    }
}