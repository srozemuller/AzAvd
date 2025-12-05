function Disconnect-AvdUserSessions {
    <#
    .SYNOPSIS
    Gets the current connect users on an AVD from a specific hostpool.
    .DESCRIPTION
    This function will grab all the logged in users sessions from a specific Azure Virtual Desktop hostpool.
    .PARAMETER HostpoolName
    Enter the AVD Hostpool name
    .PARAMETER ResourceGroupName
    Enter the AVD Hostpool resourcegroup name
    .PARAMETER SessionHostName
    Enter the sessionhosts name
    .PARAMETER SessionHostName
    Enter the user principal name
    .PARAMETER All
    Switch parameter to logoff all sessions on a session host
    .EXAMPLE
    Disconnect-AvdUserSessions -HostpoolName avd-hostpool-personal -ResourceGroupName rg-avd-01 -SessionHostName avd-host-1.avd.domain -LogonName user@domain.com
    .EXAMPLE
    Disconnect-AvdUserSessions -HostpoolName avd-hostpool-personal -ResourceGroupName rg-avd-01 -All
    .EXAMPLE
    Disconnect-AvdUserSessions -HostpoolName avd-hostpool-personal -ResourceGroupName rg-avd-01 -SessionHostName avd-host-1.avd.domain -All
    #>
    [CmdletBinding(DefaultParameterSetName = 'All')]
    param
    (
        [parameter(Mandatory, ParameterSetName = 'All')]
        [parameter(Mandatory, ParameterSetName = 'Hostname')]
        [ValidateNotNullOrEmpty()]
        [string]$HostpoolName,
    
        [parameter(Mandatory, ParameterSetName = 'All')]
        [parameter(Mandatory, ParameterSetName = 'Hostname')]
        [ValidateNotNullOrEmpty()]
        [string]$ResourceGroupName,
    
        [parameter(Mandatory, ParameterSetName = 'Hostname')]
        [ValidateNotNullOrEmpty()]
        [string]$SessionHostName,

        [parameter(ParameterSetName = 'All')]
        [parameter(ParameterSetName = 'Hostname')]
        [ValidateNotNullOrEmpty()]
        [string]$LogonName,

        [parameter(ParameterSetName = 'All')]
        [parameter(ParameterSetName = 'Hostname')]
        [ValidateNotNullOrEmpty()]
        [switch]$All
    )
    Begin {
        Write-Verbose "Start searching session hosts"
        AuthenticationCheck
        $token = GetAuthToken -resource $global:AzureApiUrl
        $apiVersion = "2024-04-03"
        $batchApiUrl = "https://management.azure.com/batch?api-version=2020-06-01"
        $avdParameters = @{
            HostpoolName      = $HostpoolName
            ResourceGroupName = $ResourceGroupName
        }
    }
    Process {
        switch ($PsCmdlet.ParameterSetName) {
            All {
                Write-Verbose 'Using base url for getting all session hosts in $hostpoolName'
            }
            Hostname {
                Write-Verbose "Looking for sessionhost $SessionHostName"
                $avdParameters.Add("sessionHostName", $SessionHostName)
            }
        }
        try {
            $userSessions = Get-AvdUserSessions @avdParameters
        }
        catch {
            Throw "No user sessions found under $Hostpoolname in $ResourceGroupName"
        }
        try {
            # Build batch requests for disconnection
            $batchRequests = @()
            
            if ($all) {
                # Disconnect all user sessions
                Write-Information "Preparing to disconnect $($userSessions.Count) user session(s)" -InformationAction Continue
                
                foreach ($session in $userSessions) {
                    $sessionUrl = $session.id -replace "^https://management\.azure\.com", ""
                    
                    $batchRequests += @{
                        httpMethod = "DELETE"
                        name = [System.Guid]::NewGuid().ToString()
                        requestHeaderDetails = @{
                            commandName = "Microsoft_Azure_WVD.WvdManagerUserDetailsBlade.SessionsTab.gridLogOffCommand.logOffUserSession"
                        }
                        requestHeaderDictionary = @{
                            "User-Agent" = @("AzurePortal/1.0.03193.971")
                        }
                        url = "$sessionUrl" + "?api-version=$apiVersion"
                    }
                }
            }
            else {
                # Disconnect specific user session
                $userSession = $userSessions | Where-Object { $_.properties.userPrincipalName -eq $LogonName }
                
                if (-not $userSession) {
                    throw "User session not found for user: $LogonName"
                }
                
                Write-Information "Preparing to disconnect user session for: $LogonName" -InformationAction Continue
                
                $sessionUrl = $userSession.id -replace "^https://management\.azure\.com", ""
                
                $batchRequests += @{
                    httpMethod = "DELETE"
                    name = [System.Guid]::NewGuid().ToString()
                    requestHeaderDetails = @{
                        commandName = "Microsoft_Azure_WVD.WvdManagerUserDetailsBlade.SessionsTab.gridLogOffCommand.logOffUserSession"
                    }
                    requestHeaderDictionary = @{
                        "User-Agent" = @("AzurePortal/1.0.03193.971")
                    }
                    url = "$sessionUrl" + "?api-version=$apiVersion"
                }
            }
            
            # Execute batch request
            if ($batchRequests.Count -gt 0) {
                $batchRequest = @{
                    requests = $batchRequests
                }
                
                $batchParameters = @{
                    uri = $batchApiUrl
                    Method = "POST"
                    Headers = $token
                    Body = ($batchRequest | ConvertTo-Json -Depth 10)
                }
                
                Write-Verbose "Executing batch disconnect request for $($batchRequests.Count) session(s)"
                $batchResponse = Request-Api @batchParameters
                
                # Process batch response
                $successCount = 0
                $failureCount = 0
                
                foreach ($response in $batchResponse.responses) {
                    if ($response.httpStatusCode -eq 200 -or $response.httpStatusCode -eq 204) {
                        $successCount++
                        Write-Verbose "Successfully disconnected session: $($response.name)"
                    }
                    else {
                        $failureCount++
                        Write-Warning "Failed to disconnect session: $($response.name). Status: $($response.httpStatusCode). Error: $($response.content.error.message)"
                    }
                }
                
                Write-Information "Disconnect Summary: $successCount successful, $failureCount failed" -InformationAction Continue
                
                return @{
                    TotalSessions = $batchRequests.Count
                    SuccessfulDisconnects = $successCount
                    FailedDisconnects = $failureCount
                    BatchResponse = $batchResponse
                }
            }
        }
        catch {
            Throw "Disconnecting users not successful: $_"
        }
    }
}