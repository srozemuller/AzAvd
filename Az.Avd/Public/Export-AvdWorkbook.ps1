function Export-AvdWorkbook {
    <#
    .SYNOPSIS
    Exports the provided workbook
    .DESCRIPTION
    Exports the workbook to a JSON formatted file on the provided file location
    .PARAMETER WorkbookName
    Enter the workbook name(s) to export
    .PARAMETER Id
    Enter the workbook resource ID
    .PARAMETER ExportPath
    The path to export the JSON files to
    .EXAMPLE
    Get-AvdWorkbook -WorkbookName "Workbook 1" | Export-AvdWorkbook
    .EXAMPLE
    Export-AvdWorkbook -WorkbookName @("Workbook 1", "Workbook") -ExportPath .\
    #>
    [CmdletBinding(DefaultParameterSetName = "Name")]
    param (
        [Parameter(ParameterSetName = "Name")]
        [ValidateNotNullOrEmpty()]
        [array]$WorkbookName,

        [Parameter(ParameterSetName = "ResourceId", ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [string]$Id,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$ExportPath = ".\"
    )
    Begin {
        Write-Verbose "Start requesting workbooks in $global:subscriptionId for export"
        AuthenticationCheck
    }
    Process {
        try {
            switch ($PsCmdlet.ParameterSetName) {
                Name {
                    $workbooks = Get-AvdWorkbook -WorkbookName $WorkbookName -ShowContent
                }
                ResourceId {
                    Write-Verbose "ID is $Id"
                    $workbooks = Get-AvdWorkbook -Id $Id -ShowContent
                }
            }
            $workbooks | ForEach-Object {
                try {
                    $filePath = "{0}\{1}.json" -f $ExportPath, ($_.Properties.displayName).Replace(" ", "_")
                    Write-Verbose "Exporting workbook to $filePath"
                    $_.Properties.serializedData | Out-File -FilePath $filePath
                }
                catch [System.Exception] {
                    Write-Error -Message "An error occurred while constructing parameter input for access token retrieval. Error message: $($PSItem.Exception.Message)"
                }
            }
        }
        catch [System.Exception] {
            Write-Error -Message "An error occurred while constructing parameter input for access token retrieval. Error message: $($PSItem.Exception.Message)"
        }
    }
}

