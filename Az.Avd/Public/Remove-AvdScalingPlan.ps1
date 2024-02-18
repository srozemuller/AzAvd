function Remove-AvdScalingPlan {
    <#
    .SYNOPSIS
    Removes a Azure Virtual Desktop Scaling plan.
    .DESCRIPTION
    The function will get a Azure Virtual Desktop scaling plan based on the current subscription context, resourcegroup, its name or the provided hostpool.
    .PARAMETER ScalingPlanName
    Enter the scaling plan name
    .PARAMETER ResourceGroupName
    Enter the resource group name
    .PARAMETER HostpoolName
    Enter the hostpool name
    .EXAMPLE
    Remove-AvdScalingPlan -ScalingPlanName sp-avd-weekdays -resourceGroupName rg-avd-01
    .EXAMPLE
    Remove-AvdScalingPlan -Id ResourceId
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
        [string]$HostpoolName,

        [parameter(Mandatory, ParameterSetName = 'ResourceId')]
        [ValidateNotNullOrEmpty()]
        [Alias('ResourceId')]
        [string]$Id
    )
    Begin {
        Write-Verbose "Start removing scaling plan $Name"
        switch ($PSCmdlet.ParameterSetName) {
            'ScalingPlanName' {
                $url = "{0}/subscriptions/{1}/resourceGroups/{2}/providers/Microsoft.DesktopVirtualization/scalingPlans/{3}" -f $global:AzureApiUrl, $global:subscriptionId, $ResourceGroupName, $ScalingPlanName
            }
            'HostpoolName' {
                $url = "{0}/subscriptions/{1}/resourceGroups/{2}/providers/Microsoft.DesktopVirtualization/hostpools/{3}/scalingPlans" -f $global:AzureApiUrl, $global:subscriptionId, $ResourceGroupName, $HostpoolName
            }
            'ResourceGroup' {
                $url = "{0}/subscriptions/{1}/resourceGroups/{2}/providers/Microsoft.DesktopVirtualization/scalingPlans" -f $global:AzureApiUrl, $global:subscriptionId, $ResourceGroupName
            }
            'ResourceId' {
                $url = "{0}/{1}" -f $global:AzureApiUrl, $Id
            }
            default {
                $url = "{0}/subscriptions/{1}/providers/Microsoft.DesktopVirtualization/scalingPlans" -f $global:AzureApiUrl, $global:subscriptionId
            }
        }

    }
    Process {
        $parameters = @{
            URI     = "{0}?api-version={1}" -f $url, $global:scalingPlanApiVersion
            Method  = "DELETE"
            Headers = $global:authHeader
        }
        $results = Request-Api @parameters
        return $results
    }
}
