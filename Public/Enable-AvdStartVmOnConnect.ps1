function Enable-AvdStartVmOnConnect {
    <#
    .SYNOPSIS
    Enable AVD Start VM on Connect
    .DESCRIPTION
    This function will enable the start VM on connect option in the hostpool and will configure the Azure AD permissions.
    It will create a new role (AVD Start VM on connect) in the Azure AD
    .PARAMETER HostPoolName
    Enter the name of the hostpool you want to enable start vm on connnect.
    .PARAMETER ResourceGroupName
    Enter the name of the resourcegroup where the hostpool resides in.
    .PARAMETER Force
    Set these parameter to force changing the ValidationEnvironment to true. 
    .EXAMPLE
    Enable-AvdStartVmOnConnect -HostPoolName avd-hostpool-001 -ResourceGroupName rg-avd-001
    #>
    [CmdletBinding(DefaultParameterSetName = 'Initial')]
    param (
        [parameter(Mandatory)]
        [parameter(ParameterSetName = 'Initial')]
        [parameter(ParameterSetName = 'Update')]
        [ValidateNotNullOrEmpty()]
        [string]$HostpoolName,

        [parameter(Mandatory)]
        [parameter(ParameterSetName = 'Initial')]
        [parameter(ParameterSetName = 'Update')]
        [ValidateNotNullOrEmpty()]
        [string]$ResourceGroupName,

        [parameter(Mandatory)]
        [parameter(ParameterSetName = 'Initial')]
        [ValidateNotNullOrEmpty()]
        [string]$HostsResourceGroup,

        [parameter(Mandatory)]
        [parameter(ParameterSetName = 'Initial')]
        [parameter(ParameterSetName = 'Update')]
        [ValidateNotNullOrEmpty()]
        [string]$RoleName,

        [switch]$Force
    )
    Begin {
        AuthenticationCheck
        $GraphHeader = GetAuthToken -resource $Script:GraphApiUrl
        $ServicePrincipalURL = "$($GraphResource)/beta/servicePrincipals?`$filter=displayName eq 'Windows Virtual Desktop'"
        $ServicePrincipals = Invoke-RestMethod -Method GET -Uri $ServicePrincipalURL -Headers $GraphHeader
        $AzureHeader = GetAuthToken -resource $Script:AzureApiUrl
    }
    Process {
        switch ($PsCmdlet.ParameterSetName) {
            Initial {
                $parameters = @{
                    HostPoolName      = $HostpoolName 
                    ResourceGroupName = $ResourceGroupName
                }
            }
            Update {
                $parameters = @{
                    HostPoolName      = $HostpoolName 
                    ResourceGroupName = $ResourceGroupName
                }
                $HostsResourceGroup = (Get-AzResource -ResourceID (Get-AvdLatestSessionHost @parameters).ResourceId).ResourceGroupName
                $Scope = "subscriptions/"+ $script:subscriptionId +"/Resourcegroups/$HostsResourceGroup"
            }
        }
        $Hostpool = Get-AzWvdHostPool @parameters
        if ($Force) {
            Update-AzWvdHostPool @parameters -ValidationEnvironment:$true
        }
        if ($Hostpool.ValidationEnvironment -eq $true) {
            Update-AzWvdHostPool @parameters -StartVMOnConnect:$true
            Write-Verbose "Hostpool $($Hostpool.Hostpoolname) updated, StartVMOnConnect is set to $true"
        }    
        #Region get Windows Virtual Desktop Service Principal


        #Region create custom role
        # Building a new role GUID
        $RoleGuid = (New-Guid).Guid
        # Generating the role body
        $RoleBody = @{
            name       = $RoleGuid
            properties = @{
                roleName         = $roleName
                description      = "This role is used to start VM when connecting"
                assignableScopes = @(
                    $Scope
                )
                permissions      = @(
                    @{
                        actions        = @(
                            "Microsoft.Compute/virtualMachines/start/action",
                            "Microsoft.Compute/virtualMachines/read"
                        )
                        notActions     = @()
                        dataActions    = @()
                        notDataActions = @()
                    }
                )
            }
        }
        $RoleJsonBody = $RoleBody | ConvertTo-Json -Depth 5
        $DefinitionUrl = "$($AzureResource)/$Scope/providers/Microsoft.Authorization/roleDefinitions/$($RoleGuid)?api-version=2018-07-01"
        $CustomRole = Invoke-RestMethod -Method PUT -Body $RoleJsonBody -Headers $AzureHeader -URi $DefinitionUrl
        #Endregion

        #region create assignment
        # New assignment GUID
        $ServicePrincipals.value.id | foreach {
            $AssignGuid = (New-Guid).Guid
            $AssignURL = "$AzureResource/$Scope/providers/Microsoft.Authorization/roleAssignments/$($AssignGuid)?api-version=2021-04-01-preview"
            $assignBody = @{
                properties = @{
                    roleDefinitionId = $CustomRole.id
                    principalId      = $_
                }
            }
            $JsonBody = $assignBody | ConvertTo-Json 
            Invoke-RestMethod -Method PUT -Uri $AssignURL -Headers $AzureHeader -Body $JsonBody
        }
    }
}