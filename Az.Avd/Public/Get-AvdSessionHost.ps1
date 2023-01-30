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
        AuthenticationCheck
        $token = GetAuthToken -resource $Script:AzureApiUrl
        $baseUrl = "{0}/subscriptions/{1}/resourceGroups/{2}/providers/Microsoft.DesktopVirtualization/hostpools/{3}/sessionHosts/" -f $Script:AzureApiUrl, $script:subscriptionId, $ResourceGroupName, $HostpoolName
        $apiVersion = "?api-version=2021-07-12"
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
                $baseUrl = "{0}{1}" -f $baseUrl, $Name 
            }
            Resource {
                Write-Verbose "Looking for sessionhost base on resourceId $Id"
                if ($Id.Contains('Microsoft.Compute/virtualMachines')) {
                    Throw "Please use the session host's resource ID, not the virtual machine"
                }
                $baseUrl = "{0}{1}" -f $Script:AzureApiUrl, $Id 
            }
        }
        $parameters = @{
            uri     = "{0}{1}" -f $baseUrl, $apiVersion
            Method  = "GET"
            Headers = $token
        }
        try {
            $allHosts = [System.Collections.ArrayList]@()
            $results = Invoke-RestMethod @parameters
            if ($Name -or $Id) {
                $results | ForEach-Object {
                    $_ | Add-Member -MemberType NoteProperty -Name HostpoolName -Value $HostpoolName
                    $_ | Add-Member -MemberType NoteProperty -Name ResourceGroupName -Value $ResourceGroupName
                }
                $results.ForEach({ $allHosts.Add($_) | Out-Null })
            } 
            else {
                $results.value.ForEach({ $allHosts.Add($_) | Out-Null })   
                # Check if there is a next page with session hosts
                $pagingURL = $results."nextLink"
                while ($null -ne $pagingURL) {
                    Write-Verbose "Got a next page url"
                    $results = Invoke-RestMethod -Uri $pagingURL -Headers $token -Method Get
                    $pagingURL = $results."nextLink"
                    $results.value.ForEach({ $allHosts.Add($_) | Out-Null }) 
                }
            }
            $allHosts        
        }
        catch {
            Write-Error "Sessionhost not found in $HostpoolName, $($_.Exception.Message)"
        }
    }
}