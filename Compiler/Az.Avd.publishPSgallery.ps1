[CmdletBinding()]
param (
    [Parameter()]
    [string]$PS_GALLERY_KEY
)
$env:ProjectName = "Az.Avd"
if ($env:GITHUB_REF_NAME -eq 'main') {
    try {
        $modulePath = Join-Path -Path (Join-Path ".././AzAvd" -ChildPath $env:ProjectName) -ChildPath "Az.Avd.psd1"     
        Publish-Module -Path (Join-Path ".././AzAvd" -ChildPath $env:ProjectName) -NuGetApiKey $PS_GALLERY_KEY -RequiredVersion (Import-PowerShellDataFile $modulePath).ModuleVersion
        write-host "Module $env:ProjectName published"
    }   
    catch {
        Throw "Module not published, $_"
    }    
}
else {
    "Github branch is not main"
}
