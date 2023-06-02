function Get-AvdLatestSessionHost {
    <#
    .SYNOPSIS
    Gets the latest session host from the AVD Hostpool
    .DESCRIPTION
    The function will help you getting the latests session host from a AVD Hostpool. 
    By running this function you will able to define the next number for deploying new session hosts.
    .PARAMETER HostpoolName
    Enter the AVD Hostpool name
    .PARAMETER ResourceGroupName
    Enter the AVD Hostpool resourcegroup name
    .PARAMETER InputObject
    You can put the hostpool object in here. 
    .PARAMETER NumOnly
    With this switch parameter you will set, you will get the next sessionhost number returned.
    .EXAMPLE
    Get-AvdLatestSessionHost -HostpoolName avd-hostpool -ResourceGroupName avd-resourcegroup
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
    switch ($PsCmdlet.ParameterSetName) {
        InputObject { 
            $HostpoolName = $InputObject.Name
            $ResourceGroupName = (Get-AzResource -ResourceId $InputObject.Id).ResourceGroupName
        }
        Default {
            $HostPoolName = $HostpoolName
            $ResourceGroupName = $ResourceGroupName
        }
    }
    $parameters = @{
        uri = "{0}/subscriptions/{1}/resourceGroups/{2}/providers/Microsoft.DesktopVirtualization/hostpools/{3}/sessionhosts?api-version={4}" -f $global:AzureApiUrl, $global:subscriptionId, $ResourceGroupName, $HostpoolName, $global:hostpoolApiVersion
        method  = "GET"
    }
    $SessionHosts = Request-Api @Parameters
    # Convert hosts to highest number to get initial value
    if ($null -eq $SessionHosts) {
        $InitialNumber = 0
    }
    else {
        $All = [ordered]@{}
        $Names = $SessionHosts | ForEach-Object { ($_.Name).Split("/")[-1].Split(".")[0] }
        $Names | ForEach-Object { $All.add([int]($_).Split("-")[-1], $_) }

        $InitialNumber = ($All.GetEnumerator() | Sort-Object Name | Select-Object -Last 1).Key + 1
        $VirtualMachineName = $All.GetEnumerator() | Sort-Object Name | Select-Object -Last 1 -ExpandProperty Value
        $LatestSessionHost = $SessionHosts | Where-Object { $_.Name -match $VirtualMachineName }
    }
    if ($NumOnly) {
        return $InitialNumber
    }
    else {
        return $LatestSessionHost
    }
}
