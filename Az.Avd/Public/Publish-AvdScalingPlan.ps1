function Publish-AvdScalingPlan {
    <#
    .SYNOPSIS
    Assignes an Azure Virtual Desktop scaling plan to a host pool.
    .DESCRIPTION
    The function will assign an Azure Virtual Desktop scaling plan to (a) hostpool(s).
    .PARAMETER Name
    Enter the scaling plan name
    .PARAMETER ResourceGroupName
    Enter the resourcegroup name
    .PARAMETER AssignToHostPool
    Enter the AVD Hostpool names and resource groups (eg. @{"Hostpool-1" = "RG-AVD-01"; "Hostpool-2" = "RG-AVD-02" }
    .EXAMPLE
    Publish-AvdScalingPlan -Name 'ScalingPlan' -ResourceGroupName 'rg-avd-01' -AssignToHostpool @{"Hostpool-1" = "RG-AVD-01"}
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
        Write-Verbose "Start adding host pool scaling plan $Name"
        $url = "{0}/subscriptions/{1}/resourceGroups/{2}/providers/Microsoft.DesktopVirtualization/scalingPlans/{3}?api-version={4}" -f $global:AzureApiUrl, $global:subscriptionId, $ResourceGroupName, $Name, $global:scalingPlanApiVersion
        $planInfo = Get-AvdScalingPlan -Name $Name -ResourceGroupName $ResourceGroupName
        $body = @{
            location   = $planInfo.location
            properties = @{
            }
        }
    }
    Process {
        $hostPoolReferences = New-Object System.Collections.ArrayList
        $planInfo.properties.hostPoolReferences | ForEach-Object {
            $hostPoolReferences.add(@{
                    hostPoolArmPath    = $_.hostPoolArmPath
                    scalingPlanEnabled = $_.scalingPlanEnabled
                }) >> $null
        }
        $HostPool.GetEnumerator() | ForEach-Object {
            $hostpool = Get-AvdHostPool -HostPoolName $_.Key -ResourceGroupName $_.Value
            $hostPoolReferences.add(@{
                    hostPoolArmPath    = $hostpool.id
                    scalingPlanEnabled = $true
                }) >> $null
        }
        $body.properties.Add("hostPoolReferences", $hostPoolReferences)

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
