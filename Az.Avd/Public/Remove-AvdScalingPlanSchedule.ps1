function Remove-AvdScalingPlanSchedule {
    <#
    .SYNOPSIS
        Modifies the scaling plan for a specified resource group.
    .DESCRIPTION
        The Set-ScalingPlan cmdlet modifies the scaling plan for a specified resource group. It allows you to configure different scaling settings for either pooled or personal desktops, depending on the ParameterSetName.
    .PARAMETER Name
        Specifies the name of the schedule to remove.
    .PARAMETER ScalingPlanName
        Specifies the name of the scaling plan to modify.
    .PARAMETER ResourceGroupName
        Specifies the name of the resource group where the scaling plan is located.
    .EXAMPLE
        Remove-AvdScalingPlanSchedule -Name "MondaySchedule" -ResourceGroupName 'rg-avd-01' -ScalingPlanName 'sp-avd-weekdays'
    .EXAMPLE
        Remove-AvdScalingPlanSchedule -Id "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-avd-01/providers/Microsoft.DesktopVirtualization/scalingPlans/sp-avd-weekdays/schedules/MondaySchedule"
    #>
    [CmdletBinding(DefaultParameterSetName = "FriendlyName")]
    param
    (
        [parameter(ParameterSetName = "FriendlyName")]
        [ValidateNotNullOrEmpty()]
        [string]$Name,

        [parameter(Mandatory, ParameterSetName = "FriendlyName")]
        [ValidateNotNullOrEmpty()]
        [string]$ScalingPlanName,

        [parameter(Mandatory, ParameterSetName = "FriendlyName")]
        [ValidateNotNullOrEmpty()]
        [string]$ResourceGroupName,

        [parameter(Mandatory, ParameterSetName = "ResourceId", ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Id,

        [parameter(Mandatory, ParameterSetName = "PlanId")]
        [ValidateNotNullOrEmpty()]
        [string]$PlanResourceId
    )

    Begin {
        Write-Verbose "Start creating scaling plan schedule for $ScalingPlanName"
        switch ($PSCmdlet.ParameterSetName) {
            FriendlyName {
                $planInfo = Get-AvdScalingPlan -Name $ScalingPlanName -ResourceGroupName $ResourceGroupName
                $resourceId = "/subscriptions/{0}/resourceGroups/{1}/providers/Microsoft.DesktopVirtualization/scalingPlans/{2}/{3}/{4}" -f $global:subscriptionId, $ResourceGroupName, $ScalingPlanName, $planInfo.scalingPlanType, $Name
            }
            ResourceId {
                $resourceId = $Id
            }
        }
    }
    Process {
        $url = "{0}{1}?api-version={2}" -f $global:AzureApiUrl, $resourceId, $global:scalingPlanScheduleApiVersion
        $parameters = @{
            URI    = $url
            Method = "DELETE"
        }
        $results = Request-Api @parameters
        return $results
    }
}
