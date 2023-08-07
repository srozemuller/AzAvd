function Unpublish-AvdScalingPlan {
    <#
    .SYNOPSIS
    Removes an Azure Virtual Desktop scaling plan from a host pool.
    .DESCRIPTION
    The function will remove an Azure Virtual Desktop scaling plan to (a) hostpool(s).
    .PARAMETER Name
    Enter the scaling plan name
    .PARAMETER ResourceGroupName
    Enter the resourcegroup name
    .PARAMETER HostPool
    Enter the AVD Hostpool names and resource groups (eg. @{"Hostpool-1" = "RG-AVD-01"; "Hostpool-2" = "RG-AVD-02" }
    .EXAMPLE
    Unpublish-AvdScalingPlan -Name 'ScalingPlan' -ResourceGroupName 'rg-avd-01' -AssignToHostpool @{"Hostpool-1" = "RG-AVD-01"}
    #>
    [CmdletBinding()]
    param
    (
        [parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$Name,

        [parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$ResourceGroupName,

        [parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [object]$HostPool
    )

    Begin {
        Write-Verbose "Unassiging scaling plan $Name"
        $url = "{0}/subscriptions/{1}/resourceGroups/{2}/providers/Microsoft.DesktopVirtualization/scalingPlans/{3}?api-version={4}" -f $global:AzureApiUrl, $global:subscriptionId, $ResourceGroupName, $Name, $global:scalingPlanApiVersion
        $planInfo = Get-AvdScalingPlan -Name $Name -ResourceGroupName $ResourceGroupName
        $body = @{
            location   = $planInfo.location
            properties = @{}
        }
    }
    Process {
        $hostPoolToRemove = New-Object System.Collections.ArrayList
        $HostPool.GetEnumerator() | ForEach-Object {
            $hostpoolInfo = Get-AvdHostPool -HostPoolName $_.Key -ResourceGroupName $_.Value
            $hostPoolToRemove.add($hostpoolInfo.id) >> $null
        }
        $hostPoolReferences = $($planInfo.Properties.hostPoolReferences | Where-Object { $_.hostPoolArmPath -notin $hostPoolToRemove })
        if ($null -ne $hostPoolReferences) {
            $body.properties.Add("hostPoolReferences", $hostPoolReferences)
        }
        else {
            $body.properties.Add("hostPoolReferences", @())
        }
        $jsonBody = $body | ConvertTo-Json -Depth 6
        $parameters = @{
            URI    = $url
            Method = "PATCH"
            Body   = $jsonBody
        }
        $results = Request-Api @parameters
        $results
    }
}
