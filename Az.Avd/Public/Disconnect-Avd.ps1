function Disconnect-Avd {
    <#
    .SYNOPSIS
        Disconnects from AVD
    .DESCRIPTION
        Disconnects from AVD enviroment by clearing all tokens.
    .EXAMPLE
        Disconnect-Avd
    #>
    [CmdletBinding()]
    param
    ()
    Begin {
        AuthenticationCheck
    }
    Process {
        Write-Verbose -Message "Logging out from AVD on resource $($global:tokenRequest.resource)"
        Write-Verbose -Message "Clearing tokens."
        try {
            $global:tokenRequest = $null
            Write-Information "Logged out from AVD succesfully!" -InformationAction Continue
        }
        catch [System.Exception] {
            Write-Warning -Message "An error occurred while constructing parameter input for access token retrieval. Error message: $($PSItem.Exception.Message)"
        }
    }
}