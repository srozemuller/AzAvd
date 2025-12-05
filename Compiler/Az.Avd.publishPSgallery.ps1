[CmdletBinding()]
param (
    [Parameter()]
    [string]$PS_GALLERY_KEY
)
$env:ProjectName = "Az.Avd"

# Extract tag version from GITHUB_REF (e.g., refs/tags/v4.1.1 -> 4.1.1)
$version = if ($env:GITHUB_REF -match 'refs/tags/v?(.*)') { 
    $matches[1] 
} else { 
    $env:GITHUB_REF_NAME 
}

$regexPattern = '^\d+\.\d+\.\d+'
if ($version -match $regexPattern) {
    try {
        Publish-Module -Path (Join-Path ".././AzAvd" -ChildPath $env:ProjectName) -NuGetApiKey $PS_GALLERY_KEY
        write-host "Module $env:ProjectName published"
    }   
    catch {
        Throw "Module not published, $_"
    }    
}
else {
    Write-Host "Github ref '$version' (from $env:GITHUB_REF) does not match a valid version number."
}
