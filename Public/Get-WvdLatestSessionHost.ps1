function Get-WvdLatestSessionHost {
    <#
    .SYNOPSIS
    Gets the latest session host from the WVD Hostpool
    .DESCRIPTION
    The function will help you getting the latests session host from a WVD Hostpool. 
    By running this function you will able to define the next number for deploying new session hosts.
    .PARAMETER HostpoolName
    Enter the WVD Hostpool name
    .PARAMETER ResourceGroupName
    Enter the WVD Hostpool resourcegroup name
    .PARAMETER InputObject
    You can put the hostpool object in here. 
    .PARAMETER NumOnly
    With this switch parameter you will set, you will get the next sessionhost number returned.
    .EXAMPLE
    Get-WvdLatestSessionHost -WvdHostpoolName wvd-hostpool -ResourceGroupName wvd-resourcegroup
    #>
    [CmdletBinding(DefaultParameterSetName = 'Parameters')]
    param (
        [parameter(Mandatory, ParameterSetName = 'Parameters')]
        [ValidateNotNullOrEmpty()]
        [string]$HostpoolName,

        [parameter(Mandatory, ParameterSetName = 'Parameters')]
        [ValidateNotNullOrEmpty()]
        [string]$ResourceGroupName,

        [parameter(ParameterSetName = 'Parameters')]
        [switch]$NumOnly,

        [parameter(Mandatory, ValueFromPipeline, ParameterSetName = 'InputObject')]
        [ValidateNotNullOrEmpty()]
        [PSCustomObject]$InputObject
    )

    Write-Verbose "Start searching"
    AuthenticationCheck
    switch ($PsCmdlet.ParameterSetName) {
        InputObject { 
            $Parameters = @{
                HostpoolName      = $InputObject.Name
                ResourceGroupName = (Get-AzResource -ResourceId $InputObject.Id).ResourceGroupName
            }
        }
        Default {
            $Parameters = @{
                HostPoolName      = $HostpoolName
                ResourceGroupName = $ResourceGroupName
            }
        }
    }
    try {
        $SessionHosts = Get-AzWvdSessionHost @Parameters |  Sort-Object ResourceId -Descending
    }
    catch {
        Throw "No session hosts found in WVD Hostpool $WvdHostpoolName, $_"
    }
    # Convert hosts to highest number to get initial value
    $All = [ordered]@{}
    $Names = $SessionHosts | % { ($_.Name).Split("/")[-1].Split(".")[0] }
    $Names | % { $All.add([int]($_).Split("-")[-1], $_) }
    $InitialNumber = ($All.GetEnumerator() | Sort-Object Name | Select-Object -Last 1).Key + 1
    $VirtualMachineName = $All.GetEnumerator() | Sort-Object Name | Select-Object -Last 1 -ExpandProperty Value
    $LatestSessionHost = $SessionHosts | Where-Object { $_.Name -match $VirtualMachineName }
    if ($NumOnly) {
        return $InitialNumber
    }
    else {
        return $LatestSessionHost
    }
}
