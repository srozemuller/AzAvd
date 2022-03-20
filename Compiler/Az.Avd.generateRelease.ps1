[CmdletBinding()]
param (
    [Parameter(Mandatory)]
    [string]$GitHubKey,
    [Parameter(Mandatory)]
    [string]$ChangeLog,
    [Parameter(Mandatory)]
    [string]$TagName,
    [Parameter(Mandatory)]
    [boolean]$PreRelease
)
$env:ProjectName = "AzAvd"
$env:zipLocation = "./{0}_{1}.zip" -f $env:ProjectName, $TagName

try {
    #Publish-Module -Name $env:ProjectName -NuGetApiKey $env:PS_GALLERY_KEY
    $releaseData = @{
        tag_name   = $TagName
        #target_commitish = $env:GITHUB_SHA
        name       = $TagName
        body       = $ChangeLog
        draft      = $false
        prerelease = $PreRelease
    }

    $postReleaseParams = @{
        Uri             = "$env:GITHUB_API_URL/repos/$env:GITHUB_REPOSITORY/releases?access_token=$GitHubKey"
        Method          = 'POST'
        Body            = (ConvertTo-Json $releaseData -Compress)
        UseBasicParsing = $true
        Header          = @{
            Accept        = 'application/vnd.github.v3+json'
            Authorization = "token $GitHubKey"
        }
    }
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    $newRelease = Invoke-RestMethod @postReleaseParams
}
catch {
    Throw "Not able to create a release, $_"
}
try {
    Get-ChildItem .\
    Compress-Archive -DestinationPath $env:zipLocation -Path "./$env:ProjectName/Az.Avd"
}
catch {
    Throw "No able to compress package, $_"
}
    try {
    $uploadParams = @{
        Uri         = ($newRelease.upload_url -replace '\{\?name.*\}', '?name=AzAvd_') + $TagName + '.zip'
        Method      = 'POST'
        ContentType = 'application/zip'
        InFile      =  $env:zipLocation
        Header      = @{
            Authorization = "token $GitHubKey"
        }
    }
    $null = Invoke-RestMethod @uploadParams
}
catch {
    Throw "Not able to upload files to release. $_"
}