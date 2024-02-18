function New-AvdWorkspace {
    <#
    .SYNOPSIS
    Creates a new Azure Virtual Desktop workspace.
    .DESCRIPTION
    The function will create a new Azure Virtual Desktop workspace.
    .PARAMETER WorkspaceName
    Enter the AVD Hostpool name
    .PARAMETER ResourceGroupName
    Enter the AVD Hostpool resourcegroup name
    .PARAMETER Location
    Enter the Azure location
    .PARAMETER FriendlyName
    Change the workspace friendly name
    .PARAMETER Description
    Enter a description
    .PARAMETER ApplicationGroupReference
    Provide the application group resource IDs where the workspace assign to.
    .EXAMPLE
    New-AvdWorkspace -workspacename avd-workspace -resourceGroupName rg-avd-01 -location WestEurope -description "Work in space"
    .EXAMPLE
    New-AvdWorkspace -workspacename avd-workspace -resourceGroupName rg-avd-01 -location WestEurope -ApplicationGroupReference @("id_1","id_2")
    #>
    [CmdletBinding()]
    param
    (
        [parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$Name,

        [parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$ResourceGroupName,

        [parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$Location,

        [parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$FriendlyName,

        [parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$Description,

        [parameter()]
        [ValidateNotNullOrEmpty()]
        [array]$ApplicationGroupReference

    )
    Begin {
        Write-Verbose "Creating workspace $WorkspaceName"
        AuthenticationCheck
        $token = GetAuthToken -resource $global:AzureApiUrl
        $url = "{0}/subscriptions/{1}/resourceGroups/{2}/providers/Microsoft.DesktopVirtualization/workspaces/{3}?api-version={4}" -f $global:AzureApiUrl, $global:subscriptionId, $ResourceGroupName, $Name, $global:workspaceApiVersion
        $parameters = @{
            uri     = $url
            Headers = $token
        }
        $body = @{
            location   = $Location
            properties = @{
            }
        }
        if ($FriendlyName) { $body.properties.Add("friendlyName", $FriendlyName) }
        if ($Description) { $body.properties.Add("description", $Description) }
        if ($ApplicationGroupReference) { $body.properties.Add("applicationGroupReferences", $ApplicationGroupReference) }
    }
    Process {
        $jsonBody = $body | ConvertTo-Json
        $parameters = @{
            uri     = $url
            Method  = "PUT"
            Headers = $token
            Body    = $jsonBody
        }
        $results = Invoke-RestMethod @parameters
        $results
    }
}