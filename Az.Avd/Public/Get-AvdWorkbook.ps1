function Get-AvdWorkbook {
<#
.SYNOPSIS
Get all worksbook related to AVD
.DESCRIPTION
Searches at subscription level for all workbooks that are assigned to the AVD resource
.PARAMETER WorkbookName
Enter the workbook name(s) to search for
.EXAMPLE
Get-AvdWorkbook
.EXAMPLE
Get-AvdWorkbook -WorkbookName "Workbook 1"
.EXAMPLE
Get-AvdWorkbook -WorkbookName @("Workbook 1", "Workbook")
#>
    [CmdletBinding(DefaultParameterSetName = "Name")]
    param (
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [array]$WorkbookName,

        [Parameter(ParameterSetName = "ResourceId")]
        [ValidateNotNullOrEmpty()]
        [string]$Id,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [switch]$ShowContent = $false
    )
    Begin {
        Write-Verbose "Start requesting workbooks in $global:subscriptionId"
        AuthenticationCheck
        $token = GetAuthToken -resource $global:AzureApiUrl
        if ($ShowContent.IsPresent) {
            Write-Verbose "Showing content"
            $ShowContent = $true
        }
        switch ($PsCmdlet.ParameterSetName) {
            Name {
                $url = "{0}/subscriptions/{1}/providers/Microsoft.Insights/workbooks?category=workbook&canFetchContent=$ShowContent&api-version={2}" -f $global:AzureApiUrl, $global:subscriptionId, $global:workbookApiVersion
            }
            ResourceId {
                $url = "{0}{1}?canFetchContent=$ShowContent&api-version={2}" -f $global:AzureApiUrl, $Id, $global:workbookApiVersion
            }
        }
    }
    Process {
        try {
            Write-Verbose "Requesting resource $url"
            $parameters = @{
                uri     = $url
                Method  = "GET"
                Headers = $token
            }
            $results = Request-Api @parameters | Where-Object { $_.properties.sourceId -eq "microsoft_azure_wvd" }
            if ($WorkbookName) {
                return $results | Where-Object { $_.properties.displayName -in $WorkbookName }
            }
            else {
                return $results
            }
        }
        catch [System.Exception] {
            Write-Error -Message "An error occurred while requesting workbooks. Error message: $($PSItem.Exception.Message)"
        }
    }
}

