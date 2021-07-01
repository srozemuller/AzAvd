#Get public and private function definition files.
$Public = @( Get-ChildItem -Path $PSScriptRoot\Public\*.ps1 -ErrorAction SilentlyContinue )
$Private = @( Get-ChildItem -Path $PSScriptRoot\Private\*.ps1 -ErrorAction SilentlyContinue )

#Dot source the files
foreach ($Import in @($Public + $Private)) {
    Try {
        . $Import.Fullname
        Write-Verbose -Message "Import function $($Import.Fullname): $_"
    }
    Catch {
        Write-Error -Message "Failed to import function $($Import.Fullname): $_"
    }
}

Export-ModuleMember -Function $Public.Basename