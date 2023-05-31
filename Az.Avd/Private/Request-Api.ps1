function Request-Api {
    [CmdletBinding()]
    param (
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$Method = "GET",

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$Uri,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [object]$Headers,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [object]$Body
    )
    Begin {
        Write-Verbose "Requesting url $Uri with method $Method"
        $resultObject = [System.Collections.ArrayList]::new()
        $token = GetAuthToken
    }
    Process {
        try {
            $parameters = @{
                Uri     = $Uri
                Method  = $Method
                Headers = $token
            }
            if ($Body) {
                $parameters.Add("Body", $($Body | ConvertTo-Json)) > $null
            }
            $results = Invoke-WebRequest @parameters | ConvertFrom-Json
            if ($results.value) {
                $results = $results.value
            }
            while (($null -ne $results."@odata.nextLink")) {
                $pagingUrl = $results."@odata.nextLink"
                Write-Verbose "Fetching odata.nextLink: $pagingUrl"

                $results = (Invoke-WebRequest -Uri $pagingUrl -Method $Method -Headers $Headers) | ConvertFrom-Json
                foreach ($value in $results.content.value) {
                    $resultObject.Add($value) > $null
                }
            }

        }
        catch {
            Write-Error -Message "An error occurred while requesting url $uri. Error message: $($_)"
        }
        $results
    }
}