#Get public and private function definition files.
$Public = @( Get-ChildItem -Path $PSScriptRoot\public\*.ps1 -ErrorAction SilentlyContinue )
$Private = @( Get-ChildItem -Path $PSScriptRoot\private\*.ps1 -ErrorAction SilentlyContinue )

#Dot source the files
foreach ($Import in @($Public + $Private))
{
    Try
    {
        . $Import.Fullname
        Write-Verbose -Message "Import function $($Import.Fullname): $_"
    }
    Catch
    {
        Write-Error -Message "Failed to import function $($Import.Fullname): $_"
    }
}

#Export public functions.
foreach ($PubFunction in $Public) {
    Export-ModuleMember -Function $PubFunction.Basename
}
