function Disable-AvdScalingPlan {
    <#
    .SYNOPSIS
    Disables an Azure Virtual Desktop scaling plan.
    .DESCRIPTION
    The function will disable an Azure Virtual Desktop scaling plan for the given hostpool(s).
    .PARAMETER Name
    Enter the scaling plan name
    .PARAMETER ResourceGroupName
    Enter the resourcegroup name
    .PARAMETER AssignToHostPool
    Enter the AVD Hostpool names and resource groups (eg. @{"Hostpool-1" = "RG-AVD-01"; "Hostpool-2" = "RG-AVD-02" }
    .EXAMPLE
    Disable-AvdScalingPlan -Name 'ScalingPlan' -ResourceGroupName 'rg-avd-01' -Hostpool @{"Hostpool-1" = "RG-AVD-01"}
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
        Write-Verbose "Start disabling host pool in scaling plan $Name"
        $url = "{0}/subscriptions/{1}/resourceGroups/{2}/providers/Microsoft.DesktopVirtualization/scalingPlans/{3}?api-version={4}" -f $global:AzureApiUrl, $global:subscriptionId, $ResourceGroupName, $Name, $global:scalingPlanApiVersion
        $planInfo = Get-AvdScalingPlan -Name $Name -ResourceGroupName $ResourceGroupName
        $body = @{
            location   = $planInfo.location
            properties = @{}
        }
    }
    Process {
        $HostPool.GetEnumerator() | ForEach-Object {
            $hostpoolInfo = Get-AvdHostPool -HostPoolName $_.Key -ResourceGroupName $_.Value
            $planInfo.properties.hostPoolReferences | Where-Object {$_.hostpoolArmPath -eq $hostpoolInfo.id} | ForEach-Object {
                        $_.scalingPlanEnabled = $false
                    }
            }
        $body.properties.Add("hostPoolReferences", $planInfo.properties.hostPoolReferences)
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
