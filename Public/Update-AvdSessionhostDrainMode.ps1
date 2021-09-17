function Update-AvdSessionhostDrainMode {
    <#
    .SYNOPSIS
    Updates sessionhosts for accepting or denying connections.
    .DESCRIPTION
    The function will update sessionhosts drainmode to true or false. This can be one sessionhost or all of them.
    .PARAMETER InputObject
    An sessionhost object or array of sessionhosts.
    .PARAMETER HostpoolName
    Enter the AVD Hostpool name
    .PARAMETER ResourceGroupName
    Enter the AVD Hostpool resourcegroup name
    .PARAMETER SessionHostName
    Enter the sessionhosts name
    .PARAMETER AllowNewSession
    Enter $true or $false.
    .EXAMPLE
    Set-AvdSessionhostDrainMode -HostpoolName avd-hostpool-personal -ResourceGroupName rg-avd-01 -SessionHostName avd-host-1.avd.domain -AllowNewSession $true 
    .EXAMPLE
    $sessionhosts | Update-AvdSessionhostDrainMode -AllowNewSession $false
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipeline, ParameterSetName = 'InputObject')]
        [ValidateNotNullOrEmpty()]
        [pscustomobject]$InputObject,

        [parameter(Mandatory, ParameterSetName = 'Parameters')]
        [ValidateNotNullOrEmpty()]
        [string]$HostpoolName,

        [parameter(Mandatory, ParameterSetName = 'Parameters')]
        [ValidateNotNullOrEmpty()]
        [string]$ResourceGroupName,

        [parameter(Mandatory, ParameterSetName = 'Parameters')]
        [ValidateNotNullOrEmpty()]
        [string]$SessionHostName,

        [parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [Boolean]$AllowNewSession
    )
    Begin {
        Write-Verbose "Start searching"
        AuthenticationCheck
    }
    Process {
        switch ($PsCmdlet.ParameterSetName) {
            InputObject {
                $parameters = @{
                    HostpoolName      = $InputObject.HostpoolName
                    ResourceGroupName = $InputObject.ResourceGroupName
                    Name              = $InputObject.SessionHostName
                    AllowNewSession = $AllowNewSession
                }
            }
            Default {
                $parameters = @{
                    Hostpoolname      = $HostpoolName 
                    ResourceGroupName = $ResourceGroupName 
                    Name              = $SessionHostName 
                    AllowNewSession = $AllowNewSession
                }
            }
        }
        if ($InputObject) {
            $InputObject | foreach { Update-AvdSessionhost @Parameters }
        }
        else {    
            Update-AvdSessionhost @Parameters
        }
    }
}