function Grant-AvdUserToSessionHost {
    <#
    .SYNOPSIS
    Assigns users to the first available session hosts in an AVD hostpool.
    .DESCRIPTION
    This function intelligently assigns users to available session hosts (hosts with no assigned user) in an Azure Virtual Desktop hostpool. 
    It can handle single users or lists of users and will assign them to the first available session hosts.
    .PARAMETER HostpoolName
    Enter the AVD Hostpool name
    .PARAMETER ResourceGroupName
    Enter the AVD Hostpool resourcegroup name
    .PARAMETER SubscriptionId
    Enter the Azure subscription ID
    .PARAMETER UserPrincipalName
    Enter a single user principal name to assign (e.g., user@domain.com)
    .PARAMETER UserList
    Enter an array of user principal names to assign (e.g., @('user1@domain.com', 'user2@domain.com'))
    .PARAMETER Force
    Force assignment even if session host has active sessions
    .PARAMETER MaxAssignments
    Maximum number of assignments to make (default: unlimited)
    .EXAMPLE
    Grant-AvdUserToSessionHost -HostpoolName "hp-avd-personal" -ResourceGroupName "rg-avd-01" -SubscriptionId "ade317a3-a92e-4615-a8d0-30ae80dfa9a7" -UserPrincipalName "user@domain.com"
    .EXAMPLE
    Grant-AvdUserToSessionHost -HostpoolName "hp-avd-personal" -ResourceGroupName "rg-avd-01" -SubscriptionId "ade317a3-a92e-4615-a8d0-30ae80dfa9a7" -UserList @('user1@domain.com', 'user2@domain.com', 'user3@domain.com')
    .EXAMPLE
    Grant-AvdUserToSessionHost -HostpoolName "hp-avd-personal" -ResourceGroupName "rg-avd-01" -SubscriptionId "ade317a3-a92e-4615-a8d0-30ae80dfa9a7" -UserList  @('user1@domain.com', 'user2@domain.com', 'user3@domain.com') -MaxAssignments 2
    #>
    [CmdletBinding(DefaultParameterSetName = 'SingleUser')]
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

        [parameter()]
        [switch]$Force,

        [parameter()]
        [switch]$WhatIf
    )

    Begin {
        Write-Verbose "Starting user assignment process for hostpool: $HostpoolName"
        AuthenticationCheck
        $token = GetAuthToken -resource $global:AzureApiUrl
        $batchApiUrl = "https://management.azure.com/batch?api-version=2020-06-01"
        
        # Validate that the hostpool is of type "Personal"
        Write-Verbose "Validating hostpool type for $HostpoolName"
        try {
            $hostpool = Get-AvdHostPool -HostpoolName $HostpoolName -ResourceGroupName $ResourceGroupName
            
            if ($hostpool.properties.hostPoolType -ne "Personal") {
                throw "User assignments can only be made to Personal hostpools. The hostpool '$HostpoolName' is of type '$($hostpool.properties.hostPoolType)'. Please use a Personal hostpool for user assignments."
            }
            
            Write-Verbose "Hostpool '$HostpoolName' is confirmed to be of type 'Personal' - proceeding with user assignments"
        }
        catch {
            if ($_.Exception.Message -like "*User assignments can only be made to Personal hostpools*") {
                throw $_
            }
            else {
                throw "Failed to retrieve hostpool information for '$HostpoolName' in resource group '$ResourceGroupName'. Please verify the hostpool exists and you have appropriate permissions. Error: $_"
            }
        }
        
        # Initialize results tracking
        $assignmentResults = @()
        $assignmentCount = 0
        $unassignedUsers = @()
        
    }

    Process {
        try {
            # Determine the list of users to assign
            $usersToAssign = switch ($PsCmdlet.ParameterSetName) {
                'SingleUser' { @($UserPrincipalName) }
                'MultipleUsers' { $UserList }
            }

            Write-Information "Processing $($usersToAssign.Count) user(s) for assignment" -InformationAction Continue

            # Get available session hosts using the existing Get-AvdUserAssignments function
            Write-Verbose "Retrieving session host information from hostpool..."
            $sessionHosts = Get-AvdUserAssignments -HostpoolName $HostpoolName -ResourceGroupName $ResourceGroupName -SubscriptionId $SubscriptionId -StatusFilter @("Available", "Disconnected")

            if (-not $sessionHosts -or $sessionHosts.Count -eq 0) {
                Write-Warning "No available session hosts found in hostpool $HostpoolName"
                return
            }

            # Filter for truly available hosts (no assigned user)
            $availableHosts = $sessionHosts | Where-Object { 
                ($null -eq $_.assignedUser) -or [string]::IsNullOrEmpty($_.assignedUser) -or $_.assignedUser -eq ""
            } | Sort-Object name

            Write-Information "Found $($availableHosts.Count) available session host(s) without assigned users" -InformationAction Continue

            if ($availableHosts.Count -eq 0) {
                Write-Warning "No session hosts available for assignment (all hosts already have assigned users)"
                return
            }

            # Calculate how many users need assignments (excluding already assigned users)
            $usersAlreadyAssigned = @($usersToAssign | Where-Object { 
                $user = $_
                $sessionHosts | Where-Object { $_.assignedUser -eq $user }
            }).Count
            
            $usersNeedingAssignment = $usersToAssign.Count - $usersAlreadyAssigned
            
            # Check if we have enough available session hosts
            if ($usersNeedingAssignment -gt $availableHosts.Count) {
                $additionalHostsNeeded = $usersNeedingAssignment - $availableHosts.Count
                Write-Warning "Insufficient session hosts available! You have $($availableHosts.Count) available session hosts but need to assign $usersNeedingAssignment users (excluding $usersAlreadyAssigned already assigned). You need $additionalHostsNeeded additional session host(s) to assign all users."
                Write-Information "Proceeding to assign users to the $($availableHosts.Count) available session hosts..." -InformationAction Continue
            }
            elseif ($usersNeedingAssignment -eq 0) {
                Write-Information "All $($usersToAssign.Count) users are already assigned to session hosts in this hostpool." -InformationAction Continue
            }
            else {
                Write-Information "You have sufficient session hosts ($($availableHosts.Count) available) to assign all $usersNeedingAssignment users needing assignment." -InformationAction Continue
            }

            # Process each user assignment
            foreach ($user in $usersToAssign) {
                # Check if user already has a session host assigned in this hostpool
                $existingAssignment = $sessionHosts | Where-Object { $_.assignedUser -eq $user }
                if ($existingAssignment) {
                    $existingSessionHostName = $existingAssignment.sessionHostName[0]
                    Write-Warning "User '$user' is already assigned to session host '$existingSessionHostName' in hostpool '$HostpoolName'. Skipping assignment."
                    
                    $assignmentResults += [PSCustomObject]@{
                        User = $user
                        SessionHost = $existingSessionHostName
                        Status = "Already Assigned - Skipped"
                        ResourceId = $existingAssignment.vmId
                        Message = "User already assigned to this session host"
                    }
                    continue
                }

                # Check if we have available hosts left
                if ($assignmentCount -ge $availableHosts.Count) {
                    Write-Warning "No more available session hosts for user: $user"
                    $unassignedUsers += $user
                    
                    $assignmentResults += [PSCustomObject]@{
                        User = $user
                        SessionHost = "N/A"
                        Status = "Not Assigned - No Available Hosts"
                        ResourceId = "N/A"
                        Message = "No available session hosts remaining"
                    }
                    continue
                }

                $targetHost = $availableHosts[$assignmentCount]
                $sessionHostName = $targetHost.sessionHostName[0]

                Write-Information "Assigning user '$user' to session host '$sessionHostName'" -InformationAction Continue

                if ($WhatIf) {
                    Write-Information "[WHATIF] Would assign user '$user' to session host '$sessionHostName'" -InformationAction Continue
                    $assignmentResults += [PSCustomObject]@{
                        User = $user
                        SessionHost = $sessionHostName
                        Status = "WhatIf - Would Assign"
                        ResourceId = $targetHost.vmId
                    }
                }
                else {
                    try {
                        # Construct the batch assignment request using the correct format
                        $forceString = if ($Force) { "true" } else { "false" }
                        $apiVersionLatest = "2025-03-01-preview"
                        
                        # Build the session host resource ID correctly
                        $sessionHostResourceId = $targetHost.id
                        $sessionHostUrl = $sessionHostResourceId -replace "^https://management\.azure\.com", ""
                        
                        $batchRequest = @{
                            requests = @(
                                @{
                                    content = @{
                                        id = $sessionHostResourceId
                                        name = $targetHost.name
                                        type = $targetHost.type
                                        properties = @{
                                            allowNewSession = $true
                                            assignedUser = $user
                                        }
                                    }
                                    httpMethod = "PATCH"
                                    name = [System.Guid]::NewGuid().ToString()
                                    requestHeaderDetails = @{
                                        commandName = "Microsoft_Azure_WVD.HostpoolVirtualMachineBladeV3.UpdateSessionHostsUsers"
                                    }
                                    url = "$sessionHostUrl" + "?api-version=$apiVersionLatest&force=$forceString"
                                }
                            )
                        }
                        
                        $batchUrl = "https://management.azure.com/batch?api-version=2020-06-01"
                        
                        $assignParameters = @{
                            uri = $batchUrl
                            Method = "POST"
                            Headers = $token
                            Body = ($batchRequest | ConvertTo-Json -Depth 10)
                        }

                        Write-Verbose "Making batch assignment API call for user: $user to session host: $sessionHostResourceId"
                        $batchResponse = Request-Api @assignParameters
                        
                        # Process the batch response
                        if ($batchResponse.responses -and $batchResponse.responses.Count -gt 0) {
                            $assignmentResponse = $batchResponse.responses[0]
                            
                            if ($assignmentResponse.httpStatusCode -eq 200) {
                                $response = $assignmentResponse.content
                            }
                            else {
                                throw "Assignment failed with status code: $($assignmentResponse.httpStatusCode). Error: $($assignmentResponse.content.error.message)"
                            }
                        }
                        else {
                            throw "No response received from batch assignment request"
                        }

                        Write-Information "Successfully assigned user '$user' to session host '$sessionHostName'" -InformationAction Continue
                        
                        $assignmentResults += [PSCustomObject]@{
                            User = $user
                            SessionHost = $sessionHostName
                            Status = "Successfully Assigned"
                            ResourceId = $targetHost.vmId
                            Response = $response
                        }
                    }
                    catch {
                        Write-Error "Failed to assign user '$user' to session host '$sessionHostName': $_"
                        
                        $assignmentResults += [PSCustomObject]@{
                            User = $user
                            SessionHost = $sessionHostName
                            Status = "Assignment Failed"
                            ResourceId = $targetHost.vmId
                            Error = $_.Exception.Message
                        }
                    }
                }

                $assignmentCount++
            }
            # Return results
            return $assignmentResults
        }
        catch {
            Write-Error "Error in Grant-AvdUserToSessionHost: $_"
            throw
        }
    }

    End {
         # Display summary
            Write-Information "`nAssignment Summary:" -InformationAction Continue
            Write-Information "Total users processed: $($usersToAssign.Count)" -InformationAction Continue
            Write-Information "Successful assignments: $(($assignmentResults | Where-Object { $_.Status -eq 'Successfully Assigned' -or $_.Status -eq 'WhatIf - Would Assign' }).Count)" -InformationAction Continue
            Write-Information "Failed assignments: $(($assignmentResults | Where-Object { $_.Status -eq 'Assignment Failed' }).Count)" -InformationAction Continue
            Write-Information "Already assigned (skipped): $(($assignmentResults | Where-Object { $_.Status -eq 'Already Assigned - Skipped' }).Count)" -InformationAction Continue
            Write-Information "Not assigned (no hosts available): $(($assignmentResults | Where-Object { $_.Status -eq 'Not Assigned - No Available Hosts' }).Count)" -InformationAction Continue
            
            # Display unassigned users if any
            if ($unassignedUsers.Count -gt 0) {
                Write-Warning "`nUsers not assigned due to insufficient session hosts ($($unassignedUsers.Count)):"
                $unassignedUsers | ForEach-Object { Write-Warning "  - $_" }
            }
        Write-Verbose "User assignment process completed"
    }
}