function Get-AvdContext {
    <#
    .SYNOPSIS
        Get the current context
    .DESCRIPTION
        In the case you need to set a new subscription context, use this command Set-AvdContext -subscriptionId <xxxx-xxxx>.
    .EXAMPLE
        Get-AvdContext
    #>
    [CmdletBinding()]
    param
    ()
    Begin {
        AuthenticationCheck
        $token = GetAuthToken -Resource $global:AzureApiUrl
        if ($SubscriptionId) {
            Write-Verbose "Subscription ID provided, setting contect to $SubcriptionId"
            $global:subscriptionId = $SubscriptionId
        }
    }
    Process {
        $parameters = @{
            uri     = "{0}/subscriptions/{1}?api-version=2022-01-01" -f $global:AzureApiUrl, $global:subscriptionId
            method  = "GET"
            headers = $token
        }
        $results = Request-Api @parameters
    }
    End {
        return $results
    }
}