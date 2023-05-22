function Request-Api {
    [CmdletBinding()]
    param (
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$Method = "GET",

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$Uri,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [object]$Headers,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [object]$Body
    )
    Begin {
        Write-Verbose "Requesting url $Uri with method $Method"
        $resultObject = [System.Collections.ArrayList]::new()
    }
    Process {
        try {
            $parameters = @{
                Uri     = $Uri
                Method  = $Method
                Headers = $Headers
            }
            if ($Body) {
                $parameters.Add("Body", $Body) > $null
            }
            $results = Invoke-WebRequest @parameters | ConvertFrom-Json
            $resultObject = $results.value
            if ($null -eq $results.value) {
                $resultObject = $results
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
        catch [System.Exception] {
            Write-Error -Message "An error occurred while requesting url $uri. Error message: $($_)"
        }
    }
    End {
        return $resultObject
    }
}