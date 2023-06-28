function Get-AvdWorkspace {
    <#
    .SYNOPSIS
    Gets a new Azure Virtual Desktop workspace.
    .DESCRIPTION
    The function will search for a given Azure Virtual Desktop workspace.
    .PARAMETER Name
    Enter the AVD workspace name
    .PARAMETER ResourceGroupName
    Enter the AVD workspace resourcegroup name
    .PARAMETER ResourceId
    Enter the AVD workspace resourceId
    .EXAMPLE
    Get-AvdWorkspace -name avd-workspace -resourceGroupName rg-avd-01
    .EXAMPLE
    Get-AvdWorkspace -resourceId "/subscriptions/../workspacename"
    #>
    [CmdletBinding(DefaultParameterSetName="Name")]
    param
    (
        [parameter(Mandatory,ParameterSetName = "Name")]
        [ValidateNotNullOrEmpty()]
        [string]$Name,
    
        [parameter(Mandatory, ParameterSetName = "Name")]
        [ValidateNotNullOrEmpty()]
        [string]$ResourceGroupName,
    
        [parameter(Mandatory, ParameterSetName = "ResourceId", ValueFromPipeline)]
        [ValidateNotNullOrEmpty()]
        [string]$ResourceId
    )
    Begin {
        Write-Verbose "Searching for workspace $WorkspaceName"
        AuthenticationCheck
        $token = GetAuthToken -resource $global:AzureApiUrl
        $apiVersion = "?api-version=2021-01-14-preview"
        switch ($PsCmdlet.ParameterSetName) {
            Name {
                $url = $global:AzureApiUrl + "/subscriptions/" + $global:subscriptionId + "/resourceGroups/" + $ResourceGroupName + "/providers/Microsoft.DesktopVirtualization/workspaces/" + $Name + $apiVersion        
            }
            ResourceId {
                $url = $global:AzureApiUrl + $resourceId + $apiVersion  
            }
        }
    }
    Process {
        $parameters = @{
            uri     = $url
            Method  = "GET"
            Headers = $token
        }
        $results = Invoke-RestMethod @parameters
        $results
    }
}