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
    .PARAMETER location
    Enter the Azure location
    .PARAMETER friendlyName
    Change the workspace friendly name
    .PARAMETER description
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
        [string]$location,

        [parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$friendlyName,

        [parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$description,

        [parameter()]
        [ValidateNotNullOrEmpty()]
        [array]$ApplicationGroupReference
        
    )
    Begin {
        Write-Verbose "Creating workspace $WorkspaceName"
        AuthenticationCheck
        $token = GetAuthToken -resource $Script:AzureApiUrl
        $apiVersion = "?api-version=2021-01-14-preview"
        $url = $Script:AzureApiUrl + "/subscriptions/" + $script:subscriptionId + "/resourceGroups/" + $ResourceGroupName + "/providers/Microsoft.DesktopVirtualization/workspaces/" + $Name + $apiVersion        
        $parameters = @{
            uri     = $url
            Headers = $token
        }
        $body = @{
            location = $location
            properties = @{
            }
        }
        if ($friendlyName){$body.properties.Add("friendlyName", $friendlyName)}
        if ($description){$body.properties.Add("description", $description)}
        if ($applicationGroupResourceIDs){$body.properties.Add("applicationGroupReferences", $ApplicationGroupReference)}
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