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
        Write-Verbose "Start searching for resources"
        AuthenticationCheck
        $token = GetAuthToken -resource $Script:AzureApiUrl
        $apiVersion = "?api-version=2022-03-01"
    }
    Process {
        switch ($PsCmdlet.ParameterSetName) {
            Hostpool {
                $parameters = @{
                    HostPoolName      = $HostpoolName
                    ResourceGroupName = $ResourceGroupName
                }
            }
            Sessionhost {
                $parameters = @{
                    hostPoolName      = $HostpoolName
                    resourceGroupName = $ResourceGroupName
                    name   = $SessionHostName
                }
            }
        }
        try {
            $sessionHosts = Get-AvdSessionHost @parameters
        }
        catch {
            Throw "No sessionhosts ($name) found in $HostpoolName ($ResourceGroupName), $_"
        }        

        $sessionHosts | Foreach-Object {
            Write-Verbose "Searching for $($_.Name)"
            try {
                $requestParameters = @{
                    uri    = "{0}{1}{2}&`$expand=instanceView" -f $Script:AzureApiUrl, $_.properties.resourceId, $apiVersion
                    header = $token
                    method = "GET"
                }
                $resource = Invoke-RestMethod @requestParameters 
            }
            catch {
                Write-Warning "Sessionhost $($_.name) has no resources, consider deleting it. Use the Remove-AvdSessionHost command, $_. URI is $($requestparameters.uri)"
            }
            $_ | Add-Member -NotePropertyName vmResources -NotePropertyValue $resource -Force
        }
    }
    End {
        $sessionHosts
    }
}
