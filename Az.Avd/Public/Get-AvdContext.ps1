function Get-AvdContext {
    <#
    .SYNOPSIS
        Get the current context
    .DESCRIPTION
        In the case you need to set a new subscription context, use this command Set-AvdContext -subscriptionId <xxxx-xxxx>.
    .EXAMPLE
        Get-AvdContext
    #>
    Begin {
        AuthenticationCheck
        $token = GetAuthToken -Resource $script:AzureApiUrl
        if ($SubscriptionId) {
            Write-Verbose "Subscription ID provided, setting contect to $SubcriptionId"
            $script:subscriptionId = $SubscriptionId
        }
    }
    Process {
        $parameters = @{
            uri     = "{0}/subscriptions/{1}?api-version=2022-01-01" -f $script:AzureApiUrl, $script:subscriptionId
            method  = "GET"
            headers = $token
        }
        $results = Request-Api @parameters
    }
    End {
        return $results
    }
}