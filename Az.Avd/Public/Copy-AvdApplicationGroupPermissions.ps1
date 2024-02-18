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
    .PARAMETER FromAppGroupId
    Enter the AVD source application group resourceId
    .PARAMETER ToAppGroupId
    Enter the AVD new application group resourceId
    .EXAMPLE
    Copy-AvdApplicationGroupPermissions -FromApplicationGroupName avd-appgroup-1 -FromResourceGroupName rg-avd-01 -ToApplicationGroupName avd-appgroup-2 -ToResourceGroupName rg-avd-01 
    .EXAMPLE
    Copy-AvdApplicationGroupPermissions -FromAppGroupId "/subscriptions/.../FromAppgroup" -ToAppGroupId "/subscriptions/.../ToAppgroup"
    #>
    [CmdletBinding(DefaultParameterSetName="Name")]
    param (
        [Parameter(Mandatory, ParameterSetName = "Name")]
        [ValidateNotNullOrEmpty()]
        [string]$FromApplicationGroupName,

        [Parameter(Mandatory, ParameterSetName = "Name")]
        [ValidateNotNullOrEmpty()]
        [string]$FromResourceGroupName,

        [Parameter(Mandatory, ParameterSetName = "Name")]
        [ValidateNotNullOrEmpty()]
        [string]$ToApplicationGroupName,

        [Parameter(Mandatory, ParameterSetName = "Name")]
        [ValidateNotNullOrEmpty()]
        [string]$ToResourceGroupName,

        [Parameter(Mandatory, ParameterSetName = "ResourceId")]
        [ValidateNotNullOrEmpty()]
        [string]$FromAppGroupId,

        [Parameter(Mandatory, ParameterSetName = "ResourceId")]
        [ValidateNotNullOrEmpty()]
        [string]$ToAppGroupId

    )
    Begin {
        Write-Verbose "Start copying permissions"
        AuthenticationCheck
        $graphToken = GetAuthToken -resource $global:GraphApiUrl
    }
    Process {
        switch ($PsCmdlet.ParameterSetName) {
            Name {
                Write-Verbose "Name and ResourceGroup provided"
                $FromApplicationResults = Get-AvdApplicationGroup -ApplicationGroupName $FromApplicationGroupName -ResourceGroupName $FromResourceGroupName
                $Scope = "/subscriptions/" + $global:subscriptionId + "/resourcegroups/" + $FromResourceGroupName + "/providers/Microsoft.DesktopVirtualization/applicationgroups/" + $FromApplicationGroupName
                $AppGroupPermissionsParameters = @{
                    ApplicationGroupName = $ToApplicationGroupName
                    ResourceGroupName = $ToResourceGroupName
                }
            }
            ResourceId {
                Write-Verbose "ResourceId provided"
                $FromApplicationResults = Get-AvdApplicationGroup -ResourceId $FromAppGroupId
                $Scope = $FromAppGroupId
                $AppGroupPermissionsParameters = @{
                    resourceId = $ToAppGroupId
                }
            }
        }
        $FromApplicationResults.assignments.properties | Where-Object { $_.Scope -eq $Scope }  | ForEach-Object {
            If ($_.principalType -eq 'User') {
                $graphUrl = $global:GraphApiUrl + "/" + $global:GraphApiVersion + "/users/" + $_.principalId
                $identityInfo = Invoke-RestMethod -Method GET -Uri $graphUrl -Headers $graphToken
                Write-Verbose "Adding user $($identityInfo.userPrincipalName) to $ToApplicationGroupName"
            }
            Else {
                $graphUrl = $global:GraphApiUrl + "/" + $global:GraphApiVersion + "/groups?`$filter=id eq '$($_.principalId)'"
                $identityInfo = (Invoke-RestMethod -Method GET -Uri $graphUrl -Headers $graphToken).value
                Write-Verbose "Adding group $($identityInfo.displayName) to $ToApplicationGroupName"   
            }
            Add-AvdApplicationGroupPermissions @AppGroupPermissionsParameters -PrincipalId $_.principalId
        }
    }
    End {}
}
