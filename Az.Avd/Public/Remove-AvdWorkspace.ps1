function Remove-AvdWorkspace {
    <#
    .SYNOPSIS
    Removes a new Azure Virtual Desktop workspace.
    .DESCRIPTION
    The function will remove Azure Virtual Desktop workspace.
    .PARAMETER WorkspaceName
    Enter the AVD Hostpool name
    .PARAMETER ResourceGroupName
    Enter the AVD Hostpool resourcegroup name
    .PARAMETER ResourceId
    Enter the Azure location
    .EXAMPLE
    Remove-AvdWorkspace -workspacename avd-workspace -resourceGroupName rg-avd-01
    .EXAMPLE
    Remove-AvdWorkspace -Id /../resourcegroups/resourceId
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
        switch ($PsCmdlet.ParameterSetName) {
            Name {
                $url = "{0}/subscriptions/{1}/resourceGroups/{2}/providers/Microsoft.DesktopVirtualization/workspaces/{3}?api-version={4}" -f $global:AzureApiUrl, $global:subscriptionId, $ResourceGroupName, $Name, $global:workspaceApiVersion
            }
            ResourceId {
                $url = "{0}{1}?api-version={2}" -f $global:AzureApiUrl, $ResourceId, $global:workspaceApiVersion
            }
        }
    }
    Process {
        try {
            $parameters = @{
                uri     = $url
                Method  = "DELETE"
                Headers = $token
            }
            $results = Invoke-RestMethod @parameters
            $results
        }
        catch {
            Write-Error -Message "An error occurred while removing workspace $WorkSpacename. Error message: $($_)"
        }

    }
}