function New-AvdWorkbook {
    <#
.SYNOPSIS
Creates a new workbook for AVD
.DESCRIPTION
Creates a new AVD workbook based on a provided template.
.PARAMETER ResourceGroupName
Enter the name of the hostpool you want information from.
.PARAMETER WorkbookName
Enter the name of the resourcegroup where the hostpool resides in.
.PARAMETER WorkbookDescription
Enter the hostpool ResourceId
.PARAMETER Template
The workbook template in JSON format
.EXAMPLE
New-AvdWorkbook -ResourceGroupName rg01 -Location westeurope -WorkbookName generalAvd -WorkbookDescription "All AVD Info" -Template ./AVDWorkbooks/generalEnvironment.json
#>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$ResourceGroupName,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$WorkbookName,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$WorkbookDescription,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$Location,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$Template
    )
    Begin {
        Write-Verbose "Start creating workbook $WorkbookName"
        AuthenticationCheck
        $token = GetAuthToken -resource $global:AzureApiUrl
        $url = "{0}/subscriptions/{1}/resourceGroups/{2}/providers/Microsoft.Insights/workbooks/{3}?sourceId=Microsoft_Azure_WVD&api-version={4}" -f $global:AzureApiUrl, $global:subscriptionId, $ResourceGroupName, $(New-Guid).Guid, $global:workbookApiVersion

    }
    Process {
        try {
            $convertedTemplate = (Get-Content $Template | ConvertFrom-Json)
            $workbookBody = @{
                location   = $Location
                kind       = "shared"
                properties = @{
                    displayName    = $WorkbookName
                    serializedData = $convertedTemplate | ConvertTo-Json -Depth 99
                    category       = "workbook"
                    description    = $WorkbookDescription
                }
            } | ConvertTo-Json -Depth 99
            $parameters = @{
                uri     = $url
                Method  = "PUT"
                Headers = $token
                Body    = $workbookBody
            }
            $results = Request-Api @parameters
            return $results
        }
        catch {
            throw "Not able to convert $Template from JSON, did you provided correct JSON format?"
        }
    }
}

