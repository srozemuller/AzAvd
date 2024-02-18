function Set-AvdContext {
    <#
    .SYNOPSIS
        Set the current setting to a new context. Context is starting at subscription level.
    .DESCRIPTION
        In the case you need to set a new subscription context, use this command.
    .PARAMETER SubscriptionId
       Enter the subscription ID as <GUID>.
    .EXAMPLE
        Set-AvdContext -SubscriptionId $SubscriptionId
    #>
    [CmdletBinding()]
    param(
        [parameter(Mandatory, HelpMessage = "Specify the subscription ID")]
        [ValidateNotNullOrEmpty()]
        [Guid]$SubscriptionId
    )
    Begin {
        AuthenticationCheck
        if ($SubscriptionId){
            Write-Verbose "Subscription ID provided, setting contect to $SubcriptionId"
            $global:subscriptionId = $SubscriptionId
        }
    }
    Process {
    }
}