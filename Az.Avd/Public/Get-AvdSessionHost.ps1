function Get-AvdSessionHost {
    <#
    .SYNOPSIS
    Gets the current AVD Session hosts from a specific hostpool.
    .DESCRIPTION
    This function will grab all the sessionhost from a specific Azure Virtual Desktop hostpool.
    .PARAMETER HostpoolName
    Enter the AVD Hostpool name
    .PARAMETER ResourceGroupName
    Enter the AVD Hostpool resourcegroup name
    .PARAMETER SessionHostName
    Enter the sessionhosts name
    .EXAMPLE
    Get-AvdSessionHost -HostpoolName avd-hostpool-personal -ResourceGroupName rg-avd-01 -SessionHostName avd-host-1.avd.domain -AllowNewSession $true 
    .EXAMPLE
    Get-AvdSessionHost -HostpoolName avd-hostpool-personal -ResourceGroupName rg-avd-01
    
    #>
    [CmdletBinding(DefaultParameterSetName = 'Resource')]
    param
    (
        [parameter(Mandatory, ParameterSetName = 'All')]
        [parameter(Mandatory, ParameterSetName = 'Hostname')]
        [ValidateNotNullOrEmpty()]
        [string]$HostpoolName,
    
        [parameter(Mandatory, ParameterSetName = 'All')]
        [parameter(Mandatory, ParameterSetName = 'Hostname')]
        [ValidateNotNullOrEmpty()]
        [string]$ResourceGroupName,
    
        [parameter(Mandatory, ParameterSetName = 'Hostname')]
        [ValidateNotNullOrEmpty()]
        [string]$Name,

        [parameter(Mandatory, ParameterSetName = 'Resource')]
        [ValidateNotNullOrEmpty()]
        [string]$Id


    )
    Begin {
        Write-Verbose "Start searching session hosts"
        AuthenticationCheck
        $token = GetAuthToken -resource $Script:AzureApiUrl
        $baseUrl = $Script:AzureApiUrl + "/subscriptions/" + $script:subscriptionId + "/resourceGroups/" + $ResourceGroupName + "/providers/Microsoft.DesktopVirtualization/hostpools/" + $HostpoolName + "/sessionHosts/"
        $apiVersion = "?api-version=2021-07-12"
    }
    Process {
        switch ($PsCmdlet.ParameterSetName) {
            All {
                Write-Verbose 'Using base url for getting all session hosts in $hostpoolName'
            }
            Hostname {
                Write-Verbose "Looking for sessionhost $Name"
                $baseUrl = "{0}{1}" -f $baseUrl, $Name 
            }
            Resource {
                Write-Verbose "Looking for sessionhost base on resourceId $ResourceId"
                $baseUrl = "{0}{1}" -f $Script:AzureApiUrl, $Id 
            }
        }
        $parameters = @{
            uri     = $baseUrl + $apiVersion
            Method  = "GET"
            Headers = $token
        }
        try {
            $results = Invoke-RestMethod @parameters
            if ($Name -or $Id) {
                $results | ForEach {
                    $_ | Add-Member -MemberType NoteProperty -Name HostpoolName -Value $HostpoolName
                    $_ | Add-Member -MemberType NoteProperty -Name ResourceGroupName -Value $ResourceGroupName
                }
                $results
            }
            else {
                $results.value
            }   
        }
        catch {
            Write-Error "No sessionhost results in $HostpoolName, $_"
        }
    }
}