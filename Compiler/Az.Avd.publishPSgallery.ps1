[CmdletBinding()]
param (
    [Parameter()]
    [string]$PS_GALLERY_KEY
)
$env:ProjectName = "Az.Avd"
$regexPattern = '^\d+\.\d+\.\d+$'
if ($env:GITHUB_REF_NAME -match $regexPattern) {
    try {
        Publish-Module -Path (Join-Path ".././AzAvd" -ChildPath $env:ProjectName) -NuGetApiKey $PS_GALLERY_KEY
        write-host "Module $env:ProjectName published"
    }   
    catch {
        Throw "Module not published, $_"
    }    
}
else {
    "Github $env:GITHUB_REF_NAME does not match a valid version number."
}
