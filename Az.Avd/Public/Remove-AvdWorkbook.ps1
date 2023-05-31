function Remove-AvdWorkbook {
    <#
.SYNOPSIS
Removes the provided workbook
.DESCRIPTION
Removes the workbook that is provided
.PARAMETER WorkbookName
Enter the workbook name(s) to remove
.EXAMPLE
Get-AvdWorkbook | Remove-AvdWorkbook
.EXAMPLE
Remove-AvdWorkbook -WorkbookName "Workbook 1"
.EXAMPLE
Remove-AvdWorkbook -WorkbookName @("Workbook 1", "Workbook")
#>
    [CmdletBinding(DefaultParameterSetName = "Name")]
    param (
        [Parameter(ParameterSetName = "Name")]
        [ValidateNotNullOrEmpty()]
        [array]$WorkbookName,

        [Parameter(ParameterSetName = "ResourceId", ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [string]$Id

    )
    Begin {
        Write-Verbose "Start requesting workbooks in $global:subscriptionId"
        AuthenticationCheck
        $token = GetAuthToken -resource $global:AzureApiUrl
    }
    Process {
        switch ($PsCmdlet.ParameterSetName) {
            Name {
                $url = [System.Collections.ArrayList]::new
                $workbooks = Get-AvdWorkbook -WorkbookName $WorkbookName
                $workbooks | ForEach-Object {
                    Write-Verbose "Adding $_"
                    $url.Add("{0}{1}?api-version={2}" -f $global:AzureApiUrl, $_.id, $global:workbookApiVersion)
                }
            }
            ResourceId {
                $url = "{0}{1}?api-version={2}" -f $global:AzureApiUrl, $Id, $global:workbookApiVersion
                Write-verbose $url
            }
        }
        $url | ForEach-Object {
            try {
                $parameters = @{
                    uri     = $url
                    Method  = "DELETE"
                    Headers = $token
                }
                $results = (Invoke-WebRequest @parameters | ConvertFrom-Json).value
                return $results
            }
            catch [System.Exception] {
                Write-Error -Message "An error occurred while constructing parameter input for access token retrieval. Error message: $($PSItem.Exception.Message)"
            }
        }
    }
}

