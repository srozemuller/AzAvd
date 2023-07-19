function Get-AvdScalingPlanSchedule {
    <#
    .SYNOPSIS
        Modifies the scaling plan for a specified resource group.
    .DESCRIPTION
        The Set-ScalingPlan cmdlet modifies the scaling plan for a specified resource group. It allows you to configure different scaling settings for either pooled or personal desktops, depending on the ParameterSetName.
    .PARAMETER ScalingPlanName
        Specifies the name of the scaling plan to modify.
    .PARAMETER ResourceGroupName
        Specifies the name of the resource group where the scaling plan is located.
    .PARAMETER ScheduleName
        Specifies the name of the schedule to update.
    .EXAMPLE
        Get-AvdScalingPlanSchedule -ScalingPlanName "PersonalPlan" -ResourceGroupName 'rg-avd-01'
    #>
    [CmdletBinding(DefaultParameterSetName = "FriendlyName")]
    param
    (
        [parameter(Mandatory, ParameterSetName = "FriendlyName")]
        [ValidateNotNullOrEmpty()]
        [string]$ScalingPlanName,

        [parameter(Mandatory, ParameterSetName = "FriendlyName")]
        [ValidateNotNullOrEmpty()]
        [string]$ResourceGroupName,

        [parameter(ParameterSetName = "FriendlyName")]
        [ValidateNotNullOrEmpty()]
        [string]$ScheduleName,

        [parameter(Mandatory, ParameterSetName = "ResourceId")]
        [ValidateNotNullOrEmpty()]
        [string]$ScalingResourceId
    )

    Begin {
        Write-Verbose "Start creating scaling plan schedule for $ScalingPlanName"
        switch ($PSCmdlet.ParameterSetName){
            "FriendlyName" {
                $url = "{0}/subscriptions/{1}/resourceGroups/{2}/providers/Microsoft.DesktopVirtualization/scalingPlans/{3}?api-version={4}" -f $global:AzureApiUrl, $global:subscriptionId, $ResourceGroupName, $ScalingPlanName, $global:scalingPlanApiVersion
            }
            "ResourceId" {
                $url = "{0}?api-version={1}" -f $ResourceId, $global:scalingPlanApiVersion
            }
        }
        $scalingPlan = Get-AvdScalingPlan -ScalingPlanName $ScalingPlanName -ResourceGroupName $ResourceGroupName
    }
    Process {
        $url = "{0}/subscriptions/{1}/resourceGroups/{2}/providers/Microsoft.DesktopVirtualization/scalingPlans/{3}/{4}schedules?api-version={5}" -f $global:AzureApiUrl, $global:subscriptionId, $ResourceGroupName, $ScalingPlanName, $scalingPlan.scalingPlanType, $global:scalingPlanApiVersion
        $parameters = @{
            URI     = $url
            Method  = "GET"
        }
        $results = Request-Api @parameters
        $results
    }
}
