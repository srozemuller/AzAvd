function Get-AvdUserAssignments {
    <#
    .SYNOPSIS
    Searches for session host and its assignments using Azure Resource Graph via batch API.
    .DESCRIPTION
    This function will search all the sessionhost from a specific Azure Virtual Desktop hostpool regarding a user assignment using Azure Management API batch requests.
    .PARAMETER HostpoolName
    Enter the AVD Hostpool name
    .PARAMETER ResourceGroupName
    Enter the AVD Hostpool resourcegroup name
    .PARAMETER SubscriptionId
    Enter the Azure subscription ID
    .PARAMETER SessionHostName
    Enter the sessionhosts name (optional filter)
    .PARAMETER LoginName
    Enter the user principal name (optional filter)
    .PARAMETER StatusFilter
    Filter by session host status (Available, Disconnected, Shutdown, etc.)
    .EXAMPLE
    Get-AvdUserAssignments -HostpoolName "hp-avd-sr-test" -ResourceGroupName "rg-avd-sr-test" -SubscriptionId "ade317a3-a92e-4615-a8d0-30ae80dfa9a7"
    .EXAMPLE
    Get-AvdUserAssignments -HostpoolName "hp-avd-sr-test" -ResourceGroupName "rg-avd-sr-test" -SubscriptionId "ade317a3-a92e-4615-a8d0-30ae80dfa9a7" -LoginName "user@domain.com"
    #>
    [CmdletBinding()]
    param
    (
        [parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$HostpoolName,

        [parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$ResourceGroupName,

        [parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$SubscriptionId = $global:subscriptionId,

        [parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$SessionHostName,

        [parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$LoginName,

        [parameter()]
        [ValidateSet("Available", "Disconnected", "Shutdown", "Unavailable", "Upgrading", "UpgradeFailed", "NoHeartbeat", "NotJoinedToDomain", "DomainTrustRelationshipLost", "SxSStackListenerNotReady", "FSLogixNotHealthy", "NeedsAssistance")]
        [string[]]$StatusFilter,

        [parameter()]
        [int]$Top = 5000,

        [parameter()]
        [int]$Skip = 0
    )
    Begin {
        Write-Verbose "Start searching session hosts using Azure Management API batch request"
        AuthenticationCheck
        $token = GetAuthToken -resource $global:AzureApiUrl
        $batchUrl = "https://management.azure.com/batch?api-version=2020-06-01"
    }
    Process {
        try {
            # Build the Resource Graph query
            $resourceGraphQuery = @"
desktopvirtualizationresources
|where type == "microsoft.desktopvirtualization/hostpools/sessionhosts"
|where id startswith "/subscriptions/$($global:subscriptionId)/resourceGroups/$ResourceGroupName/providers/Microsoft.DesktopVirtualization/hostpools/$HostpoolName/"
|extend vmId = tostring(properties.resourceId)
|extend vmIdLowercase = tolower(tostring(properties.resourceId))
|extend agentVersion = tostring(properties.agentVersion)
|extend allowNewSession = tobool(properties.allowNewSession)
|extend assignedUser = tostring(properties.assignedUser)
|extend imageResourceId = tostring(properties.imageResourceId)
|extend sessionHostConfiguration = todatetime(properties.sessionHostConfiguration)
|extend osVersion = tostring(properties.osVersion)
|extend sessions = toint(properties.sessions)
|extend status = tostring(properties.status)
|extend sessionHostName = split(name,"/",1)
|join kind=leftouter (resources | where type == "microsoft.compute/virtualmachines"
|extend vmSize = tostring(properties.hardwareProfile.vmSize)
|extend resourceIdLowerCase = tolower(id)
|extend vmLocation = tostring(location)
|extend vmPowerState = tostring(properties.extended.instanceView.powerState.code)
|extend vmResourceGroup = tostring(resourceGroup)
|extend vmHibernateState = tostring(properties.extended.instanceView.hibernationState.code)) on `$left.vmIdLowercase == `$right.['resourceIdLowerCase']
|project id, name, type, agentVersion, vmLocation, vmResourceGroup, allowNewSession, assignedUser, imageResourceId, sessionHostConfiguration, osVersion, sessions, status, vmId, vmSize, vmPowerState,vmHibernateState, sessionHostName
|where status == "Available" or status == "Disconnected" or status == "Shutdown" or status == "Unavailable" or status == "Upgrading" or status == "UpgradeFailed" or status == "NoHeartbeat" or status == "NotJoinedToDomain" or status == "DomainTrustRelationshipLost" or status == "SxSStackListenerNotReady" or status == "FSLogixNotHealthy" or status == "NeedsAssistance"
|sort by name asc
"@

            # Apply additional filters if specified
            if ($StatusFilter) {
                $statusConditions = $StatusFilter | ForEach-Object { "status == `"$_`"" }
                $statusFilterQuery = $statusConditions -join " or "
                $resourceGraphQuery = $resourceGraphQuery -replace 'where status == "Available".*"NeedsAssistance"', "where $statusFilterQuery"
            }

            if ($SessionHostName) {
                $resourceGraphQuery += "`n|where sessionHostName[0] == `"$SessionHostName`""
            }

            if ($LoginName) {
                $resourceGraphQuery += "`n|where assignedUser == `"$LoginName`""
            }

            # Create batch request payload
            $batchRequest = @{
                requests = @(
                    @{
                        content              = @{
                            subscriptions = @($SubscriptionId)
                            query         = $resourceGraphQuery
                            options       = @{
                                '$top'       = $Top
                                '$skip'      = $Skip
                                resultFormat = "objectArray"
                            }
                        }
                        httpMethod           = "POST"
                        name                 = [System.Guid]::NewGuid().ToString()
                        requestHeaderDetails = @{
                            commandName = "Microsoft_Azure_WVD.HostpoolVirtualMachinesBladeV3.sessionHostGrid.getDataFromResourceGraph"
                        }
                        url                  = "/providers/Microsoft.ResourceGraph/resources?api-version=2021-03-01"
                    }
                )
            }

            Write-Verbose "Executing batch request to Azure Management API"
            Write-Verbose "Query: $resourceGraphQuery"

            $parameters = @{
                uri     = $batchUrl
                Method  = "POST"
                Headers = $token
                Body    = ($batchRequest | ConvertTo-Json -Depth 10)
            }

            $response = Request-Api @parameters
            
            # Process the batch response
            if ($response.responses -and $response.responses.Count -gt 0) {
                $resourceGraphResponse = $response.responses[0]
                
                if ($resourceGraphResponse.httpStatusCode -eq 200 -and $resourceGraphResponse.content -and $resourceGraphResponse.content.data) {
                    Write-Verbose "Successfully retrieved $($resourceGraphResponse.content.data.Count) session host(s)"
                    return $resourceGraphResponse.content.data
                }
                else {
                    Write-Warning "Batch request completed but Resource Graph query failed. Status: $($resourceGraphResponse.httpStatusCode)"
                    if ($resourceGraphResponse.content.error) {
                        Write-Error "Error: $($resourceGraphResponse.content.error.message)"
                    }
                    return $null
                }
            }
            else {
                Write-Warning "No response received from batch request"
                return $null
            }
        }
        catch {
            Write-Error "Failed to execute batch request: $_"
            return $null
        }
    }
}