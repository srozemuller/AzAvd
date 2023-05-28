[CmdletBinding()]
param (

)
try {
    $env:ProjectName = "Az.Avd"
    Write-Host "Creating GitHub tag" -ForegroundColor Green
    $modulePath = "./$env:ProjectName/$env:ProjectName.psd1"
    $manifest = Import-PowerShellDataFile -Path $modulePath
    Import-Module $modulePath -Force

    $version = "{0}" -f $manifest.ModuleVersion
    if ($manifest.PrivateData.PSData.Prerelease) {
        $version = "{0}-{1}" -f $version, $manifest.PrivateData.PSData.Prerelease
    }
    Write-Information "Version is $version" -InformationAction Continue
    Write-Output "version=$($version)" >> $Env:GITHUB_OUTPUT

}
catch {
    Throw "Not able to create a release, $_"
}