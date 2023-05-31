function Add-AvdApplicationGroupPermissions {
    <#
    .SYNOPSIS
    Adds permissions to an Azure Virtual Desktop Applicationgroup
    .DESCRIPTION
    The function will add permissions to an Azure Virtual Desktop Applicationgroup. This can be a user or a group.
    .PARAMETER ApplicationGroupName
    Enter the AVD application group name
    .PARAMETER ResourceGroupName
    Enter the AVD application group resourcegroup name
    .PARAMETER UserPrincipalName
    Provide the user principal name (eg. user@domain.com)
    .PARAMETER GroupName
    Provide the group name (eg. All Users)
    .EXAMPLE
    Add-AvdApplicationGroupPermissions -ApplicationGroupName avd-application-group -ResourceGroupName rg-avd-01 -UserPrincipalName user@domain.com
    .EXAMPLE
    Add-AvdApplicationGroupPermissions -ApplicationGroupName avd-application-group -ResourceGroupName rg-avd-01 -GroupName "All Users"
    #>
    [CmdletBinding(DefaultParameterSetName = 'Name')]
    param
    (
        [parameter(Mandatory, ParameterSetName = 'Group')]
        [parameter(Mandatory, ParameterSetName = 'PrincipalId')]
        [parameter(Mandatory, ParameterSetName = 'User')]
        [ValidateNotNullOrEmpty()]
        [string]$ApplicationGroupName,
    
        [parameter(Mandatory, ParameterSetName = 'Group')]
        [parameter(Mandatory, ParameterSetName = 'PrincipalId')]
        [parameter(Mandatory, ParameterSetName = 'User')]
        [ValidateNotNullOrEmpty()]
        [string]$ResourceGroupName,

        [parameter(Mandatory, ParameterSetName = 'ResourceId-User')]
        [parameter(Mandatory, ParameterSetName = 'ResourceId-Group')]
        [parameter(Mandatory, ParameterSetName = 'ResourceId-PrincipalId')]
        [ValidateNotNullOrEmpty()]
        [string]$ResourceId,
    
        [parameter(Mandatory, ParameterSetName = 'ResourceId-User')]
        [parameter(Mandatory, ParameterSetName = 'Name-User')]
        [ValidateNotNullOrEmpty()]
        [string]$UserPrincipalName,

        [parameter(Mandatory, ParameterSetName = 'ResourceId-Group')]
        [parameter(Mandatory, ParameterSetName = 'Name-Group')]
        [ValidateNotNullOrEmpty()]
        [string]$GroupName,

        [parameter(Mandatory, ParameterSetName = 'ResourceId-PrincipalId')]
        [parameter(Mandatory, ParameterSetName = 'Name-PrincipalId')]
        [ValidateNotNullOrEmpty()]
        [string]$PrincipalId
        
    )
    Begin {
        Write-Verbose "Start searching"
        AuthenticationCheck
        $apiVersion = "?api-version=2021-04-01-preview"
        $token = GetAuthToken -resource $global:AzureApiUrl
    }
    Process {
        $graphToken = GetAuthToken -resource $global:GraphApiUrl
        switch -Wildcard ($PsCmdlet.ParameterSetName) {
            *User {
                Write-Verbose "UPN $UserPrincipalName provided, looking for user in Azure AD"
                $graphUrl = $global:GraphApiUrl + "/" + $global:GraphApiVersion + "/users/" + $UserPrincipalName
                $identityInfo = (Invoke-RestMethod -Method GET -Uri $graphUrl -Headers $graphToken).id
            }
            *Group {
                Write-Verbose "Group name $GroupName provided, looking for group in Azure AD"
                $graphUrl = $global:GraphApiUrl + "/" + $global:GraphApiVersion + "/groups?`$filter=displayName eq '$GroupName'"
                $identityInfo = (Invoke-RestMethod -Method GET -Uri $graphUrl -Headers $graphToken).value.id
            }
            *PrincipalId {
                Write-Verbose "looking for principal $PrincipalId in Azure AD"
                $identityInfo = $PrincipalId
            }
            Default {
                Write-Error "No UPN, group name or principal ID is provided"
            }
        }
        if ($ApplicationGroupName) {
            $applicationGroup = Get-AvdApplicationGroup -ApplicationGroupName $ApplicationGroupName -ResourceGroupName $ResourceGroupName
        }
        else {
            $applicationGroup = Get-AvdApplicationGroup -resourceId $ResourceId
        }
        $guid = (New-Guid).Guid
        $url = $global:AzureApiUrl + "/" + $applicationGroup.id + "/providers/Microsoft.Authorization/roleAssignments/$($guid)" + $apiVersion
       
        # Used ID 1d18fff3-a72a-46b5-b4a9-0b38a3cd7e63 is default built-in role Desktop Virtualization User.
        # Source: https://docs.microsoft.com/en-us/azure/role-based-access-control/built-in-roles#desktop-virtualization-user
        $body = @{
            properties = @{
                roleDefinitionId = "/subscriptions/" + $global:subscriptionId + "/providers/Microsoft.Authorization/roleDefinitions/1d18fff3-a72a-46b5-b4a9-0b38a3cd7e63"
                principalId      = $identityInfo
            }
        }
        $jsonBody = $body | ConvertTo-Json
        $parameters = @{
            uri     = $url
            Method  = "PUT"
            Headers = $token
            Body    = $jsonBody
        }
        Invoke-RestMethod @parameters
    }
}