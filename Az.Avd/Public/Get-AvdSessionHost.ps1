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
    .PARAMETER Name
    Enter the session hosts name
    .PARAMETER Id
    Enter the sessionhost's resource ID
    .EXAMPLE
    Get-AvdSessionHost -HostpoolName avd-hostpool-personal -ResourceGroupName rg-avd-01 -Name avd-host-1.avd.domain
    .EXAMPLE
    Get-AvdSessionHost -HostpoolName avd-hostpool-personal -ResourceGroupName rg-avd-01
    .EXAMPLE
    Get-AvdSessionHost -Id sessionhostId
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

        [parameter(Mandatory, ParameterSetName = 'Resource', ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [string]$Id
    )
    Begin {
        Write-Verbose "Start searching session hosts"
        $baseUrl = "{0}/subscriptions/{1}/resourceGroups/{2}/providers/Microsoft.DesktopVirtualization/hostpools/{3}/sessionHosts" -f $global:AzureApiUrl, $global:subscriptionId, $ResourceGroupName, $HostpoolName
    }
    Process {
        switch ($PsCmdlet.ParameterSetName) {
            All {
                Write-Verbose 'Using base url for getting all session hosts in $hostpoolName'
            }
            Hostname {
                if ($Name -match "/") {
                    $Name = $Name.Split("/")[-1]
                }
                Write-Verbose "Looking for sessionhost $Name"
                $baseUrl = "{0}/{1}" -f $baseUrl, $Name
            }
            Resource {
                Write-Verbose "Looking for sessionhost base on resourceId $Id"
                if ($Id.Contains('Microsoft.Compute/virtualMachines')) {
                    Throw "Please use the session host's resource ID, not the virtual machine"
                }
                $baseUrl = "{0}{1}" -f $global:AzureApiUrl, $Id
            }
        }
        Write-Verbose $baseUrl
        $parameters = @{
            uri    = "{0}?api-version={1}" -f $baseUrl, $global:AvdApiVersion
            Method = "GET"
        }
        try {
            $allHosts = [System.Collections.ArrayList]@()
            $results = Request-Api @parameters
            if ($Id) {
                $HostpoolName = (GetHostpoolRgFromId -ResourceId $Id).HostPoolName
                $ResourceGroupName = (GetHostpoolRgFromId -ResourceId $Id).ResourceGroupName

            }
            $results | ForEach-Object {
                $_ | Add-Member -MemberType NoteProperty -Name HostpoolName -Value $HostpoolName
                $_ | Add-Member -MemberType NoteProperty -Name ResourceGroupName -Value $ResourceGroupName
                $allHosts.Add($_) >> $null
            }
            return $allHosts
        }
        catch {
            Write-Error "Sessionhost not found in $HostpoolName, $($_.Exception.Message)"
        }
    }
}

$id = "/subscriptions/398c5aee-6356-47fa-b141-2251e85cdb97/resourcegroups/rg-avd-01/providers/Microsoft.DesktopVirtualization/hostpools/avd-auto-hp/sessionhosts/avdauto-2"