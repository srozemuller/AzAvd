[CmdletBinding()]
param (
    [Parameter()]
    [string]$PS_GALLERY_KEY
)
$env:ProjectName = "Az.Avd"
if ($env:GITHUB_REF_NAME -eq 'main') {
    try {
        $modulePath = Join-Path -Path (Join-Path ".././AzAvd" -ChildPath $env:ProjectName) -ChildPath "Az.Avd.psd1"     
        Import-Module $modulePath -Force
        Publish-Module -Name $env:ProjectName -NuGetApiKey $PS_GALLERY_KEY -RequiredVersion (Import-PowerShellDataFile $modulePath).ModuleVersion
        write-host "Module $env:ProjectName published"
    }   
    catch {
        Throw "Module not published, $_"
    }    
}
else {
    "Github branch is not main"
}
