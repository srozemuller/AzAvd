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
        [string]$Name,

        [parameter(Mandatory, ParameterSetName = 'ScalingPlanName')]
        [parameter(Mandatory, ParameterSetName = 'ResourceGroup')]
        [parameter(Mandatory, ParameterSetName = 'HostpoolName')]
        [ValidateNotNullOrEmpty()]
        [string]$ResourceGroupName,

        [parameter(Mandatory, ParameterSetName = 'HostpoolName')]
        [ValidateNotNullOrEmpty()]
        [string]$HostpoolName,

        [parameter(Mandatory, ParameterSetName = 'ResourceId')]
        [ValidateNotNullOrEmpty()]
        [string]$Id
    )
    Begin {
        $global:authHeader = GetAuthToken
        Write-Verbose "Start fetching scaling plan"
        switch ($PSCmdlet.ParameterSetName) {
            'ScalingPlanName' {
                $url = "{0}/subscriptions/{1}/resourceGroups/{2}/providers/Microsoft.DesktopVirtualization/scalingPlans/{3}" -f $global:AzureApiUrl, $global:subscriptionId, $ResourceGroupName, $Name
            }
            'HostpoolName' {
                $url = "{0}/subscriptions/{1}/resourceGroups/{2}/providers/Microsoft.DesktopVirtualization/hostpools/{3}/scalingPlans" -f $global:AzureApiUrl, $global:subscriptionId, $ResourceGroupName, $Name
            }
            'ResourceGroup' {
                $url = "{0}/subscriptions/{1}/resourceGroups/{2}/providers/Microsoft.DesktopVirtualization/scalingPlans" -f $global:AzureApiUrl, $global:subscriptionId, $ResourceGroupName
            }
            'ResourceId' {
                $url = "{0}/{1}" -f $global:AzureApiUrl, $global:subscriptionId, $ResourceGroupName, $Id
            }
            default {
                $url = "{0}/subscriptions/{1}/providers/Microsoft.DesktopVirtualization/scalingPlans" -f $global:AzureApiUrl, $global:subscriptionId
            }
        }

    }
    Process {
        $parameters = @{
            URI     = "{0}?api-version={1}" -f $url, $global:scalingPlanApiVersion
            Method  = "GET"
            Headers = $global:authHeader
        }
        $results = Request-Api @parameters
        $results | ForEach-Object {
            $schedules = Get-AvdScalingPlanSchedule -PlanResourceId $_.id
            $_ | Add-Member -MemberType NoteProperty -Name scalingplanType -Value $_.properties.hostpoolType
            $enabledOnHostpool = if ($_.properties.hostPoolReferences.scalingPlanEnabled) {
                $true
            }
            else {
                $false
            }
            $_ | Add-Member -MemberType NoteProperty -Name statusEnabled -Value $enabledOnHostpool
            $_.properties.schedules = $schedules
            $assigned = if ($_.properties.hostpoolreferences) {
                $true
            }
            else {
                $false
            }
            $_ | Add-Member -MemberType NoteProperty -Name assigned -Value $assigned
        }
    }
    End {
        return $results
    }
}
