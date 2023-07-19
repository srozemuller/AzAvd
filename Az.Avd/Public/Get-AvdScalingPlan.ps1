function Get-AvdScalingPlan {
    <#
    .SYNOPSIS
    Get a Azure Virtual Desktop Scaling plan.
    .DESCRIPTION
    The function will get a Azure Virtual Desktop scaling plan based on the current subscription context, resourcegroup, its name or the provided hostpool.
    .PARAMETER ScalingPlanName
    Enter the scaling plan name
    .PARAMETER ResourceGroupName
    Enter the resource group name
    .PARAMETER HostpoolName
    Enter the hostpool name
    .EXAMPLE
    Get-AvdScalingPlan -ScalingPlanName sp-avd-weekdays -resourceGroupName rg-avd-01
    .EXAMPLE
    Get-AvdScalingPlan -HostpoolName Hostpool-1 -resourceGroupName rg-avd-01
    .EXAMPLE
    Get-AvdScalingPlan -ResourceGroupName rg-avd-01
    .EXAMPLE
    Get-AvdScalingPlan
    #>
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    param
    (
        [parameter(Mandatory, ParameterSetName = 'ScalingPlanName')]
        [ValidateNotNullOrEmpty()]
        [string]$ScalingPlanName,

        [parameter(Mandatory, ParameterSetName = 'ScalingPlanName')]
        [parameter(Mandatory, ParameterSetName = 'ResourceGroup')]
        [parameter(Mandatory, ParameterSetName = 'HostpoolName')]
        [ValidateNotNullOrEmpty()]
        [string]$ResourceGroupName,

        [parameter(Mandatory, ParameterSetName = 'HostpoolName')]
        [ValidateNotNullOrEmpty()]
        [string]$HostpoolName
    )
    Begin {
        Write-Verbose "Start fetching scaling plan"
        switch ($PSCmdlet.ParameterSetName) {
            'ScalingPlanName' {
                $url = "{0}/subscriptions/{1}/resourceGroups/{2}/providers/Microsoft.DesktopVirtualization/scalingPlans/{3}?api-version={4}" -f $global:AzureApiUrl, $global:subscriptionId, $ResourceGroupName, $ScalingPlanName, $global:scalingPlanApiVersion
            }
            'HostpoolName' {
                $url = "{0}/subscriptions/{1}/resourceGroups/{2}/providers/Microsoft.DesktopVirtualization/hostpools/{3}/scalingPlans?api-version={4}" -f $global:AzureApiUrl, $global:subscriptionId, $ResourceGroupName, $HostpoolName, $global:scalingPlanApiVersion
            }
            'ResourceGroup' {
                $url = "{0}/subscriptions/{1}/resourceGroups/{2}/providers/Microsoft.DesktopVirtualization/scalingPlans?api-version={3}" -f $global:AzureApiUrl, $global:subscriptionId, $ResourceGroupName, $global:scalingPlanApiVersion
            }
            default {
                $url = "{0}/subscriptions/{1}/providers/Microsoft.DesktopVirtualization/scalingPlans?api-version={2}" -f $global:AzureApiUrl, $global:subscriptionId, $global:scalingPlanApiVersion
            }
        }

    }
    Process {
        $parameters = @{
            URI     = $url
            Method  = "GET"
            Headers = $global:authHeader
        }
        $results = Request-Api @parameters
        $results | ForEach-Object {
            $_ | Add-Member -MemberType NoteProperty -Name scalingplanType -Value $_.properties.hostpoolType -PassThru
            $_ | Add-Member -MemberType NoteProperty -Name statusEnabled -Value $_.properties.hostPoolReferences.scalingPlanEnabled -PassThru
            $assigned = if ($_.properties.hostpoolreferences) {
                $true
            }
            else {
                $false
            }
            $_ | Add-Member -MemberType NoteProperty -Name assigned -Value $assigned -PassThru
        }
        return $results
    }
}
