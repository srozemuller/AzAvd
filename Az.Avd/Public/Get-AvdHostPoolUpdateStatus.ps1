function Get-AvdHostPoolUpdateStatus {
<#
.SYNOPSIS
Get information about an AVD hostpool image update state.
.DESCRIPTION
With this function you can get information about an AVD hostpool update.
.PARAMETER HostPoolName
Enter the name of the hostpool you want information from.
.PARAMETER ResourceGroupName
Enter the name of the resourcegroup where the hostpool resides in.
.PARAMETER ResourceId
Enter the hostpool ResourceId
.PARAMETER Raw
Return the raw output of the command
.PARAMETER Records
The number of records to return, default is the last record
.EXAMPLE
Get-AvdHostPoolUpdateStatus -Resourceid /subscriptions/xxx/resourceGroups/rg-avd/providers/Microsoft.DesktopVirtualization/hostpools/AVD-Hostpool/
.EXAMPLE
Get-AvdHostPoolUpdateStatus -Hostpoolname AVD-Hostpool -ResourceGroupName rg-avd -Raw -Records 5
#>
    [CmdletBinding(DefaultParameterSetName = "Name")]
    param (
        [Parameter(Mandatory, ParameterSetName = "Name")]
        [ValidateNotNullOrEmpty()]
        [string]$HostPoolName,

        [Parameter(Mandatory, ParameterSetName = "Name")]
        [ValidateNotNullOrEmpty()]
        [string]$ResourceGroupName,

        [Parameter(Mandatory, ParameterSetName = "ResourceId")]
        [ValidateNotNullOrEmpty()]
        [string]$ResourceId,

        [Parameter()]
        [switch]$Raw,

        [Parameter()]
        [int]$Records = 1

    )
    Begin {
        Write-Verbose "Start searching for hostpool $hostpoolName"
        AuthenticationCheck
        switch ($PsCmdlet.ParameterSetName) {
            Name {
                Write-Verbose "Name and ResourceGroup provided"
                $url = "{0}/subscriptions/{1}/resourceGroups/{2}/providers/Microsoft.DesktopVirtualization/hostpools/{3}/sessionHostManagements/default/operationStatuses?api-version={4}" -f $script:AzureApiUrl, $script:subscriptionId, $ResourceGroupName, $HostpoolName, $script:hostpoolUpdateApiVersion
            }
            ResourceId {
                Write-Verbose "ResourceId provided"
                $url = "{0}{1}/sessionHostManagements/default/operationStatuses?api-version={2}" -f $script:AzureApiUrl, $resourceId, $script:HostpoolApiVersion
            }
        }
    }
    Process {
        try {
            $parameters = @{
                uri     = $url
                Method  = "GET"
                Headers = $global:authHeader
            }
            $results = Request-Api @parameters
            if ($Raw.IsPresent){
                return $results | Select-Object -First $Records
            }
            else {
                return $results | Select-Object Id, Status, StartTime, EndTime, PercentComplete, @{Name='ErrorCode'; Expression={$($_.error.message | ConvertFrom-Json).faultCode}}, @{Name='ErrorText'; Expression={$($_.error.message | ConvertFrom-Json).faultText}} -First $Records
            }
        }
        catch {
            Write-Error $_.Exception
        }
    }
}
