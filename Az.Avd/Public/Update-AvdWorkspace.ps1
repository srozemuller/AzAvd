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
    .PARAMETER Location
    Enter the Azure location
    .PARAMETER FriendlyName
    Change the workspace friendly name
    .PARAMETER Description
    Enter a description   
    .PARAMETER ApplicationGroupReference
    Provide the application group resource IDs where the workspace assign to.   
    .EXAMPLE
    Update-AvdWorkspace -name avd-workspace -resourceGroupName rg-avd-01 -Location WestEurope -description "Work in space"
    .EXAMPLE
    Update-AvdWorkspace -name avd-workspace -resourceGroupName rg-avd-01 -Location WestEurope -ApplicationGroupReference @("id_1","id_2")
    .EXAMPLE
    Update-AvdWorkspace -resourceId "/subscriptions/../workspacename" -Location WestEurope -ApplicationGroupReference @("id_1","id_2")
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
        $apiVersion = "?api-version=2021-01-14-preview"
        switch ($PsCmdlet.ParameterSetName) {
            Name {
                $url = $global:AzureApiUrl + "/subscriptions/" + $global:subscriptionId + "/resourceGroups/" + $ResourceGroupName + "/providers/Microsoft.DesktopVirtualization/workspaces/" + $Name + $apiVersion        
                $getResults = Get-AvdWorkspace -WorkspaceName $WorkspaceName -ResourceGroupName $ResourceGroupName
            }
            ResourceId {
                $url = $global:AzureApiUrl + $resourceId + $apiVersion 
                $getResults = Get-AvdWorkspace -ResourceId $ResourceId 
            }
        }
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