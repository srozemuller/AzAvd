function Update-WvdRegistrationToken {
    <#
    .SYNOPSIS
    Will create a new registration token which you need to onboard new session hosts
    .DESCRIPTION
    The function will create a new registration token, if needed, and will return the value which you need to onboard new session hosts
    .PARAMETER HostpoolName
    Enter the WVD Hostpool name
    .PARAMETER ResourceGroupName
    Enter the WVD Hostpool resourcegroup name
    .PARAMETER HoursActive
    Optional, give the token availability in hours. Default 4.
    .EXAMPLE
    New-WvdRegistrationToken -WvdHostpoolName wvd-hostpool -ResourceGroupName wvd-resourcegroup
    Add a comment to existing incidnet
    #>
    [CmdletBinding()]
    param (
        
        [parameter(mandatory = $true, ValueFromPipeline)]
        [ValidateNotNullOrEmpty()]
        [string]$HostpoolName,

        [parameter(mandatory = $true, ValueFromPipeline)]
        [ValidateNotNullOrEmpty()]
        [string]$ResourceGroupName,

        [parameter(mandatory = $false)]
        [int]$HoursActive = 4
    )
    Begin {
        Write-Verbose "Start searching"
        AuthenticationCheck
    }
    Process {
        try {
            $registered = Get-AzWvdRegistrationInfo -HostPoolName $HostpoolName -ResourceGroupName $ResourceGroupName 
        }
        catch {
            Throw "No WVD Hostpool found for $HostpoolName, $_"
        }

        $now = get-date
        # Create a registration key for adding machines to the WVD Hostpool
        if (($null -eq $registered.ExpirationTime) -or ($registered.ExpirationTime -le ($now))) {
            $registered = New-AzWvdRegistrationInfo -HostPoolName $hostpoolName -ResourceGroupName $ResourceGroupName -ExpirationTime $now.AddHours($HoursActive)
            Write-Verbose "Requesting new token for $HoursActive hour(s)"
        }
        return $registered
    }
    End {}
}
