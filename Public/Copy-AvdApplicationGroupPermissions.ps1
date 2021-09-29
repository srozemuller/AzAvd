function Copy-AvdApplicationGroupPermissions {
    <#
    .SYNOPSIS
    Copies application group permissions to another application group
    .DESCRIPTION
    The function will help you copy permissions to another application group. This based on an existing one. 
    .PARAMETER FromApplicationGroupName
    Enter the AVD source application group name
    .PARAMETER FromResourceGroupName
    Enter the AVD source application group resourcegroup name
    .PARAMETER ToApplicationGroupName
    Enter the AVD destination application group name
    .PARAMETER ToResourceGroupName
    Enter the AVD destination application group resourcegroup name
    .EXAMPLE
    Copy-AvdApplicationGroupPermissions -FromApplicationGroupName avd-appgroup-1 -FromResourceGroupName rg-avd-01 -ToApplicationGroupName avd-appgroup-2 -ToResourceGroupName rg-avd-01 
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$FromApplicationGroupName,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$FromResourceGroupName,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$ToApplicationGroupName,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$ToResourceGroupName
    )
    Begin {
        Write-Verbose "Start searching for hostpool $hostpoolName"
        AuthenticationCheck
    }
    Process {
        $FromApplicationResults = Get-AvdApplicationGroup -ApplicationGroupName $FromApplicationGroupName -ResourceGroupName $FromResourceGroupName
        $graphToken = GetAuthToken -resource $Script:GraphApiUrl
        $FromApplicationResults.assignments.properties | ? { $_.Scope -eq "/subscriptions/" + $Script:subscriptionId + "/resourcegroups/" + $FromResourceGroupName + "/providers/Microsoft.DesktopVirtualization/applicationgroups/" + $FromApplicationGroupName }  | ForEach {
            If ($_.principalType -eq 'User') {
                $graphUrl = $Script:GraphApiUrl + "/" + $script:GraphApiVersion + "/users/" + $_.principalId
                $identityInfo = Invoke-RestMethod -Method GET -Uri $graphUrl -Headers $graphToken
                Write-Verbose "Adding user $($identityInfo.userPrincipalName) to $ToApplicationGroupName"
                Add-AvdApplicationGroupPermissions -ApplicationGroupName $ToApplicationGroupName -ResourceGroupName $ToResourceGroupName -UserPrincipalName $_.principalId
            }
            Else {
                $graphUrl = $Script:GraphApiUrl + "/" + $script:GraphApiVersion + "/groups?`$filter=id eq '$($_.principalId)'"
                $identityInfo = (Invoke-RestMethod -Method GET -Uri $graphUrl -Headers $graphToken).value
                Write-Verbose "Adding group $($identityInfo.displayName) to $ToApplicationGroupName"
                Add-AvdApplicationGroupPermissions -ApplicationGroupName $ToApplicationGroupName -ResourceGroupName $ToResourceGroupName -UserPrincipalName $_.principalId
            }
        }
    }
    End {}
}
