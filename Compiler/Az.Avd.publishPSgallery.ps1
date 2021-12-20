[CmdletBinding()]
param (
    [Parameter()]
    [string]$PS_GALLERY_KEY
)
$env:ProjectName = "Az.Avd"
if ($env:GITHUB_REF_NAME -eq 'main') {
    try {
        $modulePath = Join-Path -Path (Join-Path ".././" -ChildPath "AzAvd") -ChildPath $env:ProjectName
        (Import-PowerShellDataFile (Join-Path -Path $modulePath -ChildPath "Az.Avd.psd1")).ModuleVersion
        Import-Module $modulePath -Force
        Publish-Module -Name $env:ProjectName -NuGetApiKey $PS_GALLERY_KEY -RequiredVersion 
        write-host "Module $env:ProjectName published"
    }   
    catch {
        Throw "Module not published, $_"
    }    
}
else {
    "Github branch is not main"
}
