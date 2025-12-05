function Revoke-AvdUserFromSessionHost {
    <#
    .SYNOPSIS
    Revokes user assignments from session hosts in an AVD hostpool.
    .DESCRIPTION
    This function removes user assignments from session hosts in an Azure Virtual Desktop hostpool. 
    It can handle single users, lists of users, or remove all user assignments from the hostpool.
    .PARAMETER HostpoolName
    Enter the AVD Hostpool name
    .PARAMETER ResourceGroupName
    Enter the AVD Hostpool resourcegroup name
    .PARAMETER SubscriptionId
    Enter the Azure subscription ID
    .PARAMETER UserPrincipalName
    Enter a single user principal name to revoke (e.g., user@domain.com)
    .PARAMETER UserList
    Enter an array of user principal names to revoke (e.g., @('user1@domain.com', 'user2@domain.com'))
    .PARAMETER AllUsers
    Revoke all user assignments from all session hosts in the hostpool
    .PARAMETER Force
    Force revocation even if session host has active sessions
    .PARAMETER WhatIf
    Show what would be revoked without actually making changes
    .EXAMPLE
    Revoke-AvdUserFromSessionHost -HostpoolName "hp-avd-personal" -ResourceGroupName "rg-avd-01" -SubscriptionId "ade317a3-a92e-4615-a8d0-30ae80dfa9a7" -UserPrincipalName "user@domain.com"
    .EXAMPLE
    Revoke-AvdUserFromSessionHost -HostpoolName "hp-avd-personal" -ResourceGroupName "rg-avd-01" -SubscriptionId "ade317a3-a92e-4615-a8d0-30ae80dfa9a7" -UserList @('user1@domain.com', 'user2@domain.com')
    .EXAMPLE
    Revoke-AvdUserFromSessionHost -HostpoolName "hp-avd-personal" -ResourceGroupName "rg-avd-01" -SubscriptionId "ade317a3-a92e-4615-a8d0-30ae80dfa9a7" -AllUsers
    .EXAMPLE
    Revoke-AvdUserFromSessionHost -HostpoolName "hp-avd-personal" -ResourceGroupName "rg-avd-01" -SubscriptionId "ade317a3-a92e-4615-a8d0-30ae80dfa9a7" -AllUsers -WhatIf
    #>
    [CmdletBinding(DefaultParameterSetName = 'SingleUser', SupportsShouldProcess)]
    param
    (
        [parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$HostpoolName,

        [parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$ResourceGroupName,

        [parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$SubscriptionId,

        [parameter(Mandatory, ParameterSetName = 'SingleUser')]
        [ValidateNotNullOrEmpty()]
        [string]$UserPrincipalName,

        [parameter(Mandatory, ParameterSetName = 'MultipleUsers')]
        [ValidateNotNullOrEmpty()]
        [string[]]$UserList,

        [parameter(Mandatory, ParameterSetName = 'AllUsers')]
        [switch]$AllUsers,

        [parameter()]
        [switch]$Force
    )

    Begin {
        Write-Verbose "Starting user revocation process for hostpool: $HostpoolName"
        AuthenticationCheck
        $token = GetAuthToken -resource $global:AzureApiUrl
        
        # Validate that the hostpool is of type "Personal"
        Write-Verbose "Validating hostpool type for $HostpoolName"
        try {
            $hostpool = Get-AvdHostPool -HostpoolName $HostpoolName -ResourceGroupName $ResourceGroupName
            
            if ($hostpool.properties.hostPoolType -ne "Personal") {
                throw "User assignments can only be revoked from Personal hostpools. The hostpool '$HostpoolName' is of type '$($hostpool.properties.hostPoolType)'. Please use a Personal hostpool for user assignment operations."
            }
            
            Write-Verbose "Hostpool '$HostpoolName' is confirmed to be of type 'Personal' - proceeding with user revocations"
        }
        catch {
            if ($_.Exception.Message -like "*User assignments can only be revoked from Personal hostpools*") {
                throw $_
            }
            else {
                throw "Failed to retrieve hostpool information for '$HostpoolName' in resource group '$ResourceGroupName'. Please verify the hostpool exists and you have appropriate permissions. Error: $_"
            }
        }
        
        # Initialize results tracking
        $revocationResults = @()
        $revocationCount = 0
        
    }

    Process {
        try {
            # Get current session host assignments
            Write-Verbose "Retrieving current session host assignments from hostpool..."
            $sessionHosts = Get-AvdUserAssignments -HostpoolName $HostpoolName -ResourceGroupName $ResourceGroupName -SubscriptionId $SubscriptionId

            if (-not $sessionHosts -or $sessionHosts.Count -eq 0) {
                Write-Warning "No session hosts found in hostpool $HostpoolName"
                return
            }

            # Filter for session hosts with assigned users
            $assignedHosts = $sessionHosts | Where-Object { 
                ($null -ne $_.assignedUser) -and (-not [string]::IsNullOrEmpty($_.assignedUser)) -and $_.assignedUser -ne ""
            }

            if (-not $assignedHosts -or $assignedHosts.Count -eq 0) {
                Write-Information "No session hosts have assigned users in hostpool $HostpoolName" -InformationAction Continue
                return
            }

            Write-Information "Found $($assignedHosts.Count) session host(s) with assigned users" -InformationAction Continue

            # Determine which users to revoke based on parameter set
            $usersToRevoke = switch ($PsCmdlet.ParameterSetName) {
                'SingleUser' { 
                    @($UserPrincipalName)
                }
                'MultipleUsers' { 
                    $UserList 
                }
                'AllUsers' { 
                    $assignedHosts.assignedUser | Sort-Object -Unique
                }
            }

            Write-Information "Processing revocation for $($usersToRevoke.Count) user(s)" -InformationAction Continue

            # Find session hosts that need user revocation
            $hostsToProcess = @()
            $usersNotFound = @()

            foreach ($user in $usersToRevoke) {
                $userAssignment = $assignedHosts | Where-Object { $_.assignedUser -eq $user }
                
                if ($userAssignment) {
                    $hostsToProcess += $userAssignment
                    Write-Verbose "Found user '$user' assigned to session host '$($userAssignment.sessionHostName[0])'"
                }
                else {
                    $usersNotFound += $user
                    Write-Warning "User '$user' is not assigned to any session host in hostpool '$HostpoolName'"
                    
                    $revocationResults += [PSCustomObject]@{
                        User = $user
                        SessionHost = "N/A"
                        Status = "Not Found - No Assignment"
                        ResourceId = "N/A"
                        Message = "User not assigned to any session host in this hostpool"
                    }
                }
            }

            if ($hostsToProcess.Count -eq 0) {
                Write-Information "No user assignments found to revoke" -InformationAction Continue
                return $revocationResults
            }

            Write-Information "Found $($hostsToProcess.Count) user assignment(s) to revoke" -InformationAction Continue

            # Process each revocation
            foreach ($hostAssignment in $hostsToProcess) {
                $user = $hostAssignment.assignedUser
                $sessionHostName = $hostAssignment.sessionHostName[0]
                
                # Check for active sessions and handle disconnection
                $hasActiveSessions = $hostAssignment.sessions -gt 0
                
                if ($hasActiveSessions) {
                    if (-not $Force) {
                        Write-Warning "Cannot revoke user '$user' from session host '$sessionHostName': Session host has $($hostAssignment.sessions) active session(s). Use -Force to override."
                        
                        $revocationResults += [PSCustomObject]@{
                            User = $user
                            SessionHost = $sessionHostName
                            Status = "Blocked - Active Sessions"
                            ResourceId = $hostAssignment.vmId
                            Message = "Session host has $($hostAssignment.sessions) active session(s). Use -Force to override."
                        }
                        continue
                    }
                    else {
                        # Force specified - disconnect active sessions first
                        Write-Warning "User '$user' has $($hostAssignment.sessions) active session(s) on '$sessionHostName'. Disconnecting sessions before revocation (Force specified)."
                        
                        try {
                            # Disconnect user sessions using the existing function
                            $disconnectResult = Disconnect-AvdUserSessions -HostpoolName $HostpoolName -ResourceGroupName $ResourceGroupName -SessionHostName $sessionHostName -LogonName $user
                            
                            if ($disconnectResult.SuccessfulDisconnects -gt 0) {
                                Write-Information "Successfully disconnected $($disconnectResult.SuccessfulDisconnects) session(s) for user '$user'" -InformationAction Continue
                            }
                            if ($disconnectResult.FailedDisconnects -gt 0) {
                                Write-Warning "Failed to disconnect $($disconnectResult.FailedDisconnects) session(s) for user '$user' - proceeding with revocation anyway"
                            }
                        }
                        catch {
                            Write-Warning "Failed to disconnect sessions for user '$user' on session host '$sessionHostName': $_ - proceeding with revocation anyway"
                        }
                        
                        # Add a brief delay to allow session cleanup
                        Start-Sleep -Seconds 2
                    }
                }

                Write-Information "Revoking user '$user' from session host '$sessionHostName'" -InformationAction Continue

                if ($PSCmdlet.ShouldProcess("$sessionHostName", "Revoke user assignment for '$user'")) {
                    if ($WhatIfPreference) {
                        Write-Information "[WHATIF] Would revoke user '$user' from session host '$sessionHostName'" -InformationAction Continue
                        $revocationResults += [PSCustomObject]@{
                            User = $user
                            SessionHost = $sessionHostName
                            Status = "WhatIf - Would Revoke"
                            ResourceId = $hostAssignment.vmId
                        }
                    }
                    else {
                    try {
                        # Construct the batch revocation request
                        $forceString = if ($Force) { "true" } else { "false" }
                        $apiVersionLatest = "2025-03-01-preview"
                        
                        # Build the session host resource ID correctly
                        $sessionHostResourceId = $hostAssignment.id
                        $sessionHostUrl = $sessionHostResourceId -replace "^https://management\.azure\.com", ""
                        
                        $batchRequest = @{
                            requests = @(
                                @{
                                    content = @{
                                        id = $sessionHostResourceId
                                        name = $hostAssignment.name
                                        type = $hostAssignment.type
                                        properties = @{
                                            allowNewSession = $true
                                            assignedUser = ""
                                        }
                                    }
                                    httpMethod = "PATCH"
                                    name = [System.Guid]::NewGuid().ToString()
                                    requestHeaderDetails = @{
                                        commandName = "Microsoft_Azure_WVD.HostpoolVirtualMachineBladeV3.UnassignSessionHostsUsers"
                                    }
                                    url = "$sessionHostUrl" + "?api-version=$apiVersionLatest&force=$forceString"
                                }
                            )
                        }
                        
                        $batchUrl = "https://management.azure.com/batch?api-version=2020-06-01"
                        
                        $revokeParameters = @{
                            uri = $batchUrl
                            Method = "POST"
                            Headers = $token
                            Body = ($batchRequest | ConvertTo-Json -Depth 10)
                        }

                        Write-Verbose "Making batch revocation API call for user: $user from session host: $sessionHostResourceId"
                        $batchResponse = Request-Api @revokeParameters
                        
                        # Process the batch response
                        if ($batchResponse.responses -and $batchResponse.responses.Count -gt 0) {
                            $revocationResponse = $batchResponse.responses[0]
                            
                            if ($revocationResponse.httpStatusCode -eq 200) {
                                $response = $revocationResponse.content
                            }
                            else {
                                throw "Revocation failed with status code: $($revocationResponse.httpStatusCode). Error: $($revocationResponse.content.error.message)"
                            }
                        }
                        else {
                            throw "No response received from batch revocation request"
                        }

                        Write-Information "Successfully revoked user '$user' from session host '$sessionHostName'" -InformationAction Continue
                        
                        $revocationResults += [PSCustomObject]@{
                            User = $user
                            SessionHost = $sessionHostName
                            Status = "Successfully Revoked"
                            ResourceId = $hostAssignment.vmId
                            Response = $response
                        }
                        
                        $revocationCount++
                        }
                        catch {
                            Write-Error "Failed to revoke user '$user' from session host '$sessionHostName': $_"
                            
                            $revocationResults += [PSCustomObject]@{
                                User = $user
                                SessionHost = $sessionHostName
                                Status = "Revocation Failed"
                                ResourceId = $hostAssignment.vmId
                                Error = $_.Exception.Message
                            }
                        }
                    }
                }
            }

            # Display summary
            Write-Information "`nRevocation Summary:" -InformationAction Continue
            Write-Information "Total users processed: $($usersToRevoke.Count)" -InformationAction Continue
            Write-Information "Successful revocations: $(($revocationResults | Where-Object { $_.Status -eq 'Successfully Revoked' -or $_.Status -eq 'WhatIf - Would Revoke' }).Count)" -InformationAction Continue
            Write-Information "Failed revocations: $(($revocationResults | Where-Object { $_.Status -eq 'Revocation Failed' }).Count)" -InformationAction Continue
            Write-Information "Blocked by active sessions: $(($revocationResults | Where-Object { $_.Status -eq 'Blocked - Active Sessions' }).Count)" -InformationAction Continue
            Write-Information "Users not found: $(($revocationResults | Where-Object { $_.Status -eq 'Not Found - No Assignment' }).Count)" -InformationAction Continue
            
            # Display users not found if any
            if ($usersNotFound.Count -gt 0) {
                Write-Warning "`nUsers not found (not assigned to any session host) ($($usersNotFound.Count)):"
                $usersNotFound | ForEach-Object { Write-Warning "  - $_" }
            }
            
            # Display users blocked by active sessions if any
            $blockedUsers = $revocationResults | Where-Object { $_.Status -eq 'Blocked - Active Sessions' }
            if ($blockedUsers.Count -gt 0) {
                Write-Warning "`nUsers blocked due to active sessions ($($blockedUsers.Count)):"
                $blockedUsers | ForEach-Object { Write-Warning "  - $($_.User) on $($_.SessionHost)" }
                Write-Information "Use -Force parameter to revoke assignments even with active sessions." -InformationAction Continue
            }

            # Return results
            return $revocationResults
        }
        catch {
            Write-Error "Error in Revoke-AvdUserFromSessionHost: $_"
            throw
        }
    }

    End {
        Write-Verbose "User revocation process completed"
    }
}