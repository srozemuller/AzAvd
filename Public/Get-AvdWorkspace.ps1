function Get-AvdWorkspace {
    <#
    .SYNOPSIS
    Gets a new Azure Virtual Desktop workspace.
    .DESCRIPTION
    The function will search for a given Azure Virtual Desktop workspace.
    .PARAMETER WorkspaceName
    Enter the AVD workspace name
    .PARAMETER ResourceGroupName
    Enter the AVD workspace resourcegroup name
    .EXAMPLE
    Get-AvdWorkspace -workspacename avd-workspace -resourceGroupName rg-avd-01
    #>
    [CmdletBinding()]
    param
    (
        [parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$WorkspaceName,
    
        [parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$ResourceGroupName
        
    )
    Begin {
        Write-Verbose "Searching for workspace $WorkspaceName"
        AuthenticationCheck
        $token = GetAuthToken -resource $Script:AzureApiUrl
        $apiVersion = "?api-version=2021-01-14-preview"
        $url = $Script:AzureApiUrl+"/subscriptions/" + $script:subscriptionId + "/resourceGroups/" + $ResourceGroupName + "/providers/Microsoft.DesktopVirtualization/workspaces/" + $WorkspaceName + $apiVersion        
        $parameters = @{
            uri     = $url
            Headers = $token
        }
    }
    Process {
        $parameters = @{
            uri     = $url
            Method  = "GET"
            Headers = $token
        }
        $results = Invoke-RestMethod @parameters
        return $results
    }
}