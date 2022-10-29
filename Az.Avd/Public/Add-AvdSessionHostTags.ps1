function Add-AvdSessionHostTags {
    <#
    .SYNOPSIS
    Add tags to the session host's VM resource
    .DESCRIPTION
    Based on the session host name, add tags to the VM resource.
    .PARAMETER HostpoolName
    Enter the source AVD Hostpool name
    .PARAMETER ResourceGroupName
    Enter the source Hostpool resourcegroup name
    .PARAMETER Tags
    Enter the tags to add. Provide an object.
    .PARAMETER SessionHostName
    Enter the sessionhosts name avd-hostpool/avd-host-1.avd.domain
    .PARAMETER Id
    Enter the sessionhost resource ID
    .EXAMPLE
    Add-AvdSessionHostTags -HostpoolName avd-hostpool -ResourceGroupName rg-avd-01 -SessionHostName avd-hostpool/avd-host-1.avd.domain -Tags @{Tag="Value"}
    .EXAMPLE
    Add-AvdSessionHostTags -Id sessionhostResourceId -Tags @{Tag="Value"}
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
        $token = GetAuthToken -resource $Script:AzureApiUrl
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
                    uri    = "{0}{1}?api-version={2}" -f $Script:AzureApiUrl, $_.vmResources.id, $apiVersion
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