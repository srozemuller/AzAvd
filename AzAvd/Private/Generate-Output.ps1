function Generate-Output {
    <#
    .SYNOPSIS
    Exports the complete Windows Virtual Desktop environment, based on the hostpool name.
    .DESCRIPTION
    The function will help you exporting the complete AVD environment to common output types as HTML and CSV.
    .PARAMETER HostpoolName
    Enter the AVD hostpoolname name.
    .PARAMETER ResourceGroupName
    Enter the AVD hostpool resource group name.
    .PARAMETER 
    .EXAMPLE
    Export-AVDConfig -Hostpoolname $hostpoolName -resourceGroup $ResourceGroup -Scope Hostpool,SessionHosts -Verbose -FilePath .\AVDexport.html
    Add a comment to existing incidnet
    #>
    
    [CmdletBinding(DefaultParameterSetName = 'Hostpool')]
    param (
        [parameter(Mandatory)]
        [string]$FileName,

        [parameter(Mandatory)]
        [ValidateSet("JSON", "HTML", "XLSX")]
        [array]$Format,

        [parameter(Mandatory)]
        [hashtable]$Content,

        [parameter(Mandatory)]
        [string]$HostpoolName
    )

    Begin {
        
    }
    Process {
        $FilePath = ".\$FileName.$($Format.tolower())"
        switch ($Format) {
            HTML {
                $ExportBody = [System.Collections.Generic.List[object]]::new()
                $Content.Values | foreach { $ExportBody.Add(($_ | ConvertTo-Html -Fragment -PreContent "<p>$($_.Name) information for $HostpoolName</p>")) }
                $Css = Get-Content -Path "$PSScriptRoot\..\Private\exportconfig.css" -Raw
                $ExportBody = $ExportBody -replace '<td>0</td>', '<td class="WrongStatus">False</td>'
                $Logo = '<link rel="shortcut icon" href="./Private/AVD-logo.png" />'
                $style = ("<style>`n") + $Css + ("`n</style>")
                $HtmlParameters = @{
                    Title       = "AVD Information Report"
                    body        = $ExportBody
                    Head        = $Logo + $style
                    PostContent = "<H5><i>$(get-date)</i></H5>"
                }
                ConvertTo-Html @HtmlParameters | Out-File -FilePath $FilePath
            }
            XLSX {
                if ($null -eq (Get-Module -ListAvailable -Name ImportExcel)) { Install-Module -Name ImportExcel }
                Import-Module ImportExcel
                Remove-Item $FilePath -ErrorAction SilentlyContinue
                # Header Spacing
                $HeaderSpacing = 1
                $ContentSpacing = 2
                $Headers = @{}
                $HeaderLocation,$Rows, $ReportContent = $null
                $Content.GetEnumerator() | foreach {
                    $Resource = $_.Key
                    $HeaderLocation = ($ReportContent + $Rows + $ContentSpacing)
                    $Rows = $Rows + $Content.Get_Item($Resource).Count
                    $ReportContent = $HeaderSpacing + $HeaderLocation    
                    $Headers.Add($Resource, $("A" + $HeaderLocation))
                    $Content.Get_Item($Resource) | Export-Excel $FilePath -AutoSize -StartRow $ReportContent -TableName $Resource  
                }
                # Directory Listing
                $excel = Get-Date | Export-Excel $FilePath -AutoSize -StartRow 1 -PassThru
                # Get the sheet named Sheet1
                $ws = $excel.Workbook.Worksheets['Sheet1']
                # Create a hashtable with a few properties
                # that you'll splat on Set-Format
                $xlParams = @{WorkSheet = $ws; Bold = $true; FontSize = 18; AutoSize = $true }
                $Headers.GetEnumerator() | foreach { 
                    # Create the headings in the Excel worksheet
                    Set-Format -Range $_.Value -Value $_.Key @xlParams
                }
                # Close and Save the changes to the Excel file
                # Launch the Excel file using the -Show switch
                Close-ExcelPackage $excel
            }
            JSON {
                $ExportBody.Add(($Content | ConvertTo-Json -Depth 99))
                $ExportBody | Out-File -FilePath $FilePath
            }
            Console {
                return $Content
            }
        }
    }
    End {

    }
}

