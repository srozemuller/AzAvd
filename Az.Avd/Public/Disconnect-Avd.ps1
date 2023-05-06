function Disconnect-Avd {
    <#
    .SYNOPSIS
        Disconnects from AVD
    .DESCRIPTION
        Disconnects from AVD enviroment by clearing all tokens.
    .EXAMPLE
        Disconnect-Avd
    #>
    Begin {
        AuthenticationCheck
    }
    Process {
        Write-Verbose -Message "Logging out from AVD on resource $($script:tokenRequest.resource)"
        Write-Verbose -Message "Clearing tokens."
        try {
            Clear-Variable -Name tokenRequest -Scope Script
            Write-Information "Logged out from AVD succesfully!" -InformationAction Continue
        }
        catch [System.Exception] {
            Write-Warning -Message "An error occurred while constructing parameter input for access token retrieval. Error message: $($PSItem.Exception.Message)"
        }
    }
}