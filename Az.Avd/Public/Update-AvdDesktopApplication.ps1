function Update-AvdDesktopApplication {
    <#
    .SYNOPSIS
    Updates the Virtual Desktop ApplicationGroup desktop application
    .DESCRIPTION
    The function will update the desktop application SessionDesktop with a FriendlyName and/or displayname.
    .PARAMETER ApplicationGroupName
    Enter the AVD application group name
    .PARAMETER ResourceGroupName
    Enter the AVD application group resourcegroup name
    .PARAMETER ResourceId
    Enter the AVD application group resourceId
    .PARAMETER FriendlyName
    Provide a displayname, this is the name you see in the webclient and Remote Desktop Client.
    .PARAMETER Description
    Enter a description   
    .EXAMPLE
    Update-AvdDesktopApplication -ApplicationGroupName avd-applicationgroup -ResourceGroupName rg-avd-01 -DisplayName "Update Desktop"
    .EXAMPLE
    Update-AvdDesktopApplication -ResourceId "/subscriptions/../applicationName" -DisplayName "Update Desktop"
    #>
    [CmdletBinding(DefaultParameterSetName = "Name")]
    param
    (
        [parameter(Mandatory, ParameterSetName="Name")]
        [ValidateNotNullOrEmpty()]
        [string]$ApplicationGroupName,
    
        [parameter(Mandatory, ParameterSetName="Name")]
        [ValidateNotNullOrEmpty()]
        [string]$ResourceGroupName,
    
        [parameter(Mandatory, ParameterSetName="ResourceId")]
        [ValidateNotNullOrEmpty()]
        [string]$ResourceId,

        [parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$Description,

        [parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$FriendlyName
        
    )
    Begin {
        Write-Verbose "Updating Session Desktop application in $ApplicationGroupName"
        AuthenticationCheck
        $token = GetAuthToken -resource $global:AzureApiUrl
        $apiVersion = "?api-version=2021-01-14-preview"
        switch ($PsCmdlet.ParameterSetName) {
            Name {
                $url = $global:AzureApiUrl + "/subscriptions/" + $global:subscriptionId + "/resourceGroups/" + $ResourceGroupName + "/providers/Microsoft.DesktopVirtualization/applicationGroups/" + $ApplicationGroupName + "/desktops/SessionDesktop/" + $apiVersion        
            }
            ResourceId {
                $url = $global:AzureApiUrl + $ResourceId + "/desktops/SessionDesktop/" + $apiVersion        
            }
        }
        $parameters = @{
            uri     = $url
            Headers = $token
        }
        $body = @{
            properties = @{
            }
        }
        if ($FriendlyName) { $body.properties.Add("FriendlyName", $FriendlyName) }
        if ($Description) { $body.properties.Add("description", $Description) }
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