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
        [string]$PlanResourceId
    )

    Begin {
        Write-Verbose "Start creating scaling plan schedule for $ScalingPlanName"
        $resultsObject = [System.Collections.ArrayList]::new()
        switch ($PSCmdlet.ParameterSetName){
            "FriendlyName" {
                $resourceId = "/subscriptions/{0}/resourceGroups/{1}/providers/Microsoft.DesktopVirtualization/scalingPlans/{2}" -f $global:subscriptionId, $ResourceGroupName, $ScalingPlanName
            }
            default {
                $resourceId = $PlanResourceId
            }
        }
    }
    Process {
        $types = @("personal","pooled")
        $types | ForEach-Object {
            $url = "{0}{1}/{2}Schedules?api-version={3}" -f $global:AzureApiUrl, $resourceId, $_, $global:scalingPlanScheduleApiVersion
            $parameters = @{
                URI     = $url
                Method  = "GET"
            }
            $results = Request-Api @parameters
            $resultsObject.Add($results) >> $null
        }
        return $resultsObject
    }
}
