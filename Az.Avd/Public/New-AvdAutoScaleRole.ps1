function New-AvdAutoScaleRole {
    <#
    .SYNOPSIS
    Creates a new RBAC role for AVD autoscaling
    .DESCRIPTION
    The function will create a new RBAC role and assign it at subscription or resourcegroup level.
    .PARAMETER RoleName
    Enter the role name
    .PARAMETER RoleDescription
    Enter the role description
    .PARAMETER ResourceGroupName
    If you like to scope at resourcegroup level, provide the resourcegroup name. (Default subscription scope)
    .PARAMETER Assign
    If you like to assign directly, use this switch parameter
    .EXAMPLE
    New-AvdAutoScaleRole RoleName avd-autoscale RoleDescription "Plan for autoscale session hosts"
    .EXAMPLE
    New-AvdAutoScaleRole RoleName avd-autoscale RoleDescription "Plan for autoscale session hosts" -resourcegroup rg-avd-001 -Assign
    #>
    [CmdletBinding()]
    param
    (
        [parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$RoleName,

        [parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$RoleDescription,
        
        [parameter(Mandatory, ParameterSetName = "ResourceGroupScope")]
        [ValidateNotNullOrEmpty()]
        [string]$ResourceGroupName,      

        [parameter()]
        [switch]$Assign
    )
    
    Begin {
        Write-Verbose "Start creating a new  RBAC for with name $RoleName"
        AuthenticationCheck
        $AzureHeader = GetAuthToken -resource $global:AzureApiUrl
        $apiVersion = "?api-version=2018-07-01"
        
        switch ($PsCmdlet.ParameterSetName) {
            ResourceGroupScope {
                Write-Verbose "ResourceGroup provided"
                $Scope = "/subscriptions/" + $global:subscriptionId + "/resourceGroups/" + $ResourceGroupName 
            }
            Default {
                $Scope = "/subscriptions/" + $global:subscriptionId
            }
        }   
    }
    Process {
        $RoleGuid = (New-Guid).Guid
        $RoleBody = @{
            name       = $RoleGuid
            properties = @{
                roleName         = $RoleName
                description      = $RoleDescription
                assignableScopes = @(
                    $Scope
                )
                permissions      = @(
                    @{
                        actions        = @(
                            "Microsoft.Compute/virtualMachines/deallocate/action",
                            "Microsoft.Compute/virtualMachines/restart/action",
                            "Microsoft.Compute/virtualMachines/powerOff/action",
                            "Microsoft.Compute/virtualMachines/start/action",
                            "Microsoft.Compute/virtualMachines/read",
                            "Microsoft.DesktopVirtualization/hostpools/read",
                            "Microsoft.DesktopVirtualization/hostpools/write",
                            "Microsoft.DesktopVirtualization/hostpools/sessionhosts/read",
                            "Microsoft.DesktopVirtualization/hostpools/sessionhosts/write",
                            "Microsoft.DesktopVirtualization/hostpools/sessionhosts/usersessions/delete",
                            "Microsoft.DesktopVirtualization/hostpools/sessionhosts/usersessions/sendMessage/action"
        
                        )
                        notActions     = @()
                        dataActions    = @()
                        notDataActions = @()
                    }
                )
            }
        }
        $RoleJsonBody = $RoleBody | ConvertTo-Json -Depth 5
        $url = $global:AzureApiUrl + $Scope + "/providers/Microsoft.Authorization/roleDefinitions/" + $RoleGuid + $apiVersion
        $rbacRole = Invoke-RestMethod -Method PUT -Body $RoleJsonBody -Headers $AzureHeader -URi $url
        if ($Assign.IsPresent) {
            $GraphHeader = GetAuthToken -resource $global:GraphApiUrl
            $servicePrincipalURL = $global:GraphApiUrl + "/" +$global:GraphApiVersion + "/servicePrincipals?`$filter=displayName eq 'Windows Virtual Desktop'"
            $servicePrincipals = Invoke-RestMethod -Method GET -Uri $servicePrincipalURL -Headers $GraphHeader
            $servicePrincipals.value.id | ForEach-Object {
                $assignGuid = (New-Guid).Guid
                $assignURL = $global:AzureApiUrl + $Scope + "/providers/Microsoft.Authorization/roleAssignments/" + $AssignGuid + "?api-version=2021-04-01-preview"
                $assignBody = @{
                    properties = @{
                        roleDefinitionId = $rbacRole.id
                        principalId      = $_
                    }
                }
                $JsonBody = $assignBody | ConvertTo-Json 
                Invoke-RestMethod -Method PUT -Uri $AssignURL -Headers $AzureHeader -Body $JsonBody
            }
        }
    }
}
