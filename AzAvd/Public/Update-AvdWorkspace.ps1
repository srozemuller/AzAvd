function Update-AvdWorkspace {
    <#
    .SYNOPSIS
    Updates a new Azure Virtual Desktop workspace.
    .DESCRIPTION
    The function will update an existing Azure Virtual Desktop workspace.
    .PARAMETER Name
    Enter the AVD workspace name
    .PARAMETER ResourceGroupName
    Enter the AVD workspace resourcegroup name
    .PARAMETER ResourceGroupName
    Enter the AVD workspace resourceId 
    .PARAMETER location
    Enter the Azure location
    .PARAMETER friendlyName
    Change the workspace friendly name
    .PARAMETER description
    Enter a description   
    .PARAMETER ApplicationGroupReference
    Provide the application group resource IDs where the workspace assign to.   
    .EXAMPLE
    Update-AvdWorkspace -name avd-workspace -resourceGroupName rg-avd-01 -location WestEurope -description "Work in space"
    .EXAMPLE
    Update-AvdWorkspace -name avd-workspace -resourceGroupName rg-avd-01 -location WestEurope -ApplicationGroupReference @("id_1","id_2")
    .EXAMPLE
    Update-AvdWorkspace -resourceId "/subscriptions/../workspacename" -location WestEurope -ApplicationGroupReference @("id_1","id_2")
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
    
        [parameter(Mandatory, ParameterSetName = "ResourceId")]
        [ValidateNotNullOrEmpty()]
        [string]$ResourceId,

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
        switch ($PsCmdlet.ParameterSetName) {
            Name {
                $url = $Script:AzureApiUrl + "/subscriptions/" + $script:subscriptionId + "/resourceGroups/" + $ResourceGroupName + "/providers/Microsoft.DesktopVirtualization/workspaces/" + $Name + $apiVersion        
                $getResults = Get-AvdWorkspace -WorkspaceName $WorkspaceName -ResourceGroupName $ResourceGroupName
            }
            ResourceId {
                $url = $Script:AzureApiUrl + $resourceId + $apiVersion 
                $getResults = Get-AvdWorkspace -ResourceId $ResourceId 
            }
        }
        $parameters = @{
            uri     = $url
            Headers = $token
        }
        $body = @{
            location   = $location
            properties = @{
            }
        }
        if ($friendlyName) { $body.properties.Add("friendlyName", $friendlyName) }
        if ($description) { $body.properties.Add("description", $description) }
        if ($ApplicationGroupReference) {
            $currentAppGroups = $getResults.properties.applicationGroupReferences
            $ApplicationGroupReference | ForEach-Object {
                $newAppGroups = $currentAppGroups + $_
            }
            $body.properties.Add("applicationGroupReferences", $newAppGroups)
        }
    }
    Process {
        $jsonBody = $body | ConvertTo-Json
        $parameters = @{
            uri     = $url
            Method  = "PATCH"
            Headers = $token
            Body    = $jsonBody
        }
        $results = Invoke-RestMethod @parameters
        $results
    }
}