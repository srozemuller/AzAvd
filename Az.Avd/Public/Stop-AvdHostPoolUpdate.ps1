function Stop-AvdHostPoolUpdate {
    <#
.SYNOPSIS
Get AVD Hostpool information.
.DESCRIPTION
With this function you can get information about an AVD hostpool.
.PARAMETER HostPoolName
Enter the name of the hostpool you want information from.
.PARAMETER ResourceGroupName
Enter the name of the resourcegroup where the hostpool resides in.
.PARAMETER ResourceId
Enter the hostpool ResourceId
.PARAMETER Message
Enter the message you want to display to the users when they are logged off.
.EXAMPLE
Stop-AvdHostPoolUpdate -HostPoolName avd-hostpool-001 -ResourceGroupName rg-avd-001
.EXAMPLE
Stop-AvdHostPoolUpdate -ResourceId "/subscription/../HostPoolName"
#>
    [CmdletBinding(DefaultParameterSetName = "ResourceId")]
    param (
        [Parameter(Mandatory, ParameterSetName = "Name")]
        [ValidateNotNullOrEmpty()]
        [string]$HostPoolName,

        [Parameter(Mandatory, ParameterSetName = "Name")]
        [ValidateNotNullOrEmpty()]
        [string]$ResourceGroupName,

        [Parameter(Mandatory, ParameterSetName = "ResourceId")]
        [ValidateNotNullOrEmpty()]
        [string]$ResourceId,

        [Parameter()]
        [string]$Message = "Host pool update has been cancelled. You are no longer required to sign out."
    )
    Begin {
        Write-Verbose "Canceling hostpool image update for $hostpoolName"
        AuthenticationCheck
        $token = GetAuthToken -resource $script:AzureApiUrl
        switch ($PsCmdlet.ParameterSetName) {
            Name {
                Write-Verbose "Name and ResourceGroup provided"
                $url = "{0}/subscriptions/{1}/resourceGroups/{2}/providers/Microsoft.DesktopVirtualization/hostpools/{3}/controlUpdate?api-version={4}" -f $script:AzureApiUrl, $script:subscriptionId, $ResourceGroupName, $HostpoolName, $script:hostpoolUpdateApiVersion
                $ResourceId = "/subscriptions/{0}/resourceGroups/{1}/providers/Microsoft.DesktopVirtualization/hostpools/{2}" -f $script:subscriptionId, $ResourceGroupName, $HostpoolName
            }
            ResourceId {
                Write-Verbose "ResourceId provided, thank you for using the ResourceId parameter"
                $url = "{0}{1}/controlUpdate?api-version={2}" -f $script:AzureApiUrl, $resourceId, $script:hostpoolUpdateApiVersion
            }
        }
    }
    Process {
        try {
            $currentState = Get-AvdHostPoolUpdateState -ResourceId $ResourceId
            if (($currentState.UpdateStatus -ne "Scheduled") -and ($currentState.UpdateStatus -ne "InProgress")) {
                Write-Information "Hostpool has no update planned state. Current state is $($currentState.updateStatus)." -InformationAction Continue
                return
            }
            else {
                $body = @{
                    action  = "Cancel"
                    message = $Message
                } | ConvertTo-Json
                $parameters = @{
                    uri     = $url
                    Method  = "POST"
                    Headers = $token
                    Body    = $body
                }
                $response = Invoke-WebRequest @parameters -SkipHttpErrorCheck
                if ($response.StatusCode -eq 204) {
                    Write-Information "Hostpool update has been cancelled" -InformationAction Continue
                }
                else {
                    Write-Error "Something went wrong, please check the error below"
                    Throw $response
                }
            }
        }
        catch {
            Write-Error $_.Exception.Response
        }
    }
}