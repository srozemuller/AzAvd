function Get-AvdSessionHostVmStatus {
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
    Get-AvdSessionHostVmStatus -Hostpoolname avd-hostpool -ResourceGroup rg-avd-01
    .EXAMPLE
    Get-AvdSessionHostVmStatus -Hostpoolname avd-hostpool -ResourceGroup rg-avd-01 -SessionHostName avd01.domain.local
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
        $apiVersion = "?api-version=2021-07-01"
    }
    Process {
        switch ($PsCmdlet.ParameterSetName) {
            Hostpool {
                $Parameters = @{
                    HostPoolName      = $HostpoolName
                    ResourceGroupName = $ResourceGroupName
                }
            }
            Sessionhost {
                $Parameters = @{
                    HostPoolName      = $HostpoolName
                    ResourceGroupName = $ResourceGroupName
                    SessionHostName   = $SessionHostName
                }
            }
        }
        $SessionHosts = Get-AvdSessionhost @Parameters
        if ($sessionHosts) {
            $sessionHosts | Foreach-Object {
                Write-Verbose "Searching for $($_.Name)"
                try {
                    $requestParameters = @{
                        uri = "{0}{1}/instanceView{2}" -f $Script:AzureApiUrl, $_.properties.resourceId, $apiVersion
                        header = $token
                        method = "GET"
                    }
                    Invoke-RestMethod @requestParameters 
                }
                catch {
                    Write-Warning "Sessionhost $($_.name) has no resources, consider deleting it. Use the Remove-AvdSessionHost command"
                }
            }
        }
        else {
            Write-Error "No AVD Hostpool found with name $Hostpoolname in resourcegroup $ResourceGroupName or no sessionhosts"
        }
    }
}
