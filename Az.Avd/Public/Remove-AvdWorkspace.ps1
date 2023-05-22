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
    New-AvdWorkspace -workspacename avd-workspace -resourceGroupName rg-avd-01 -location WestEurope -description "Work in space"
    .EXAMPLE
    New-AvdWorkspace -workspacename avd-workspace -resourceGroupName rg-avd-01 -location WestEurope -ApplicationGroupReference @("id_1","id_2")
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
        $token = GetAuthToken -resource $Script:AzureApiUrl
        switch ($PsCmdlet.ParameterSetName) {
            Name {
                $url = "{0}/subscriptions/{1}/resourceGroups/{2}/providers/Microsoft.DesktopVirtualization/workspaces/{3}?api-version={4}" -f $Script:AzureApiUrl, $script:subscriptionId, $ResourceGroupName, $Name, $script:workspaceApiVersion
            }
            ResourceId {
                $url = "{0}{1}?api-version={2}" -f $Script:AzureApiUrl, $ResourceId, $script:workspaceApiVersion
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