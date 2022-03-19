[CmdletBinding()]
param (
    [Parameter(Mandatory)]
    [string]$GitHubKey,
    [Parameter(Mandatory)]
    [string]$BranchName,
    [Parameter(Mandatory)]
    [string]$ChangeLog
)
try {
    $githubUrl = "$env:GITHUB_API_URL/repos/$env:GITHUB_REPOSITORY/releases?access_token=$GitHubKey"
    $getReleaseParams = @{
        Uri    = $githubUrl
        Method = 'GET'
        Header = @{
            Accept        = 'application/vnd.github.v3+json'
            Authorization = "token $GitHubKey"
        }
    }
    $releases = Invoke-RestMethod @getReleaseParams
}
catch {
    Throw "Not able to find releases"
}
try {
    $env:ProjectName = "Az.Avd"
    Write-Host "Creating GitHub release" -ForegroundColor Green
    $modulePath = "./$env:ProjectName/$env:ProjectName.psd1"
    $manifest = Import-PowerShellDataFile -Path $modulePath
    Import-Module $modulePath -Force
}
catch {
    Throw "Not able to import $env:ProjectName and determine current version"
}
switch ($BranchName) {
    beta {
        Write-Information "Found $($releases[0])" -InformationAction Continue
        $betaNumberLocation = $releases[0].tag_name.lastindexOf(".")
        $newNumber = 0;
        if ($releases[0].tag_name -match $BranchName){
            $newNumber = [int]$releases[0].tag_name.substring($betaNumberLocation + 1) + 1
        }
        $releaseName = 'v{0}-beta.{1}' -f $manifest.ModuleVersion, $newNumber
    }
    #default is main branch
    main {
        $releaseName = 'v{0}-stable' -f $manifest.ModuleVersion 
    }
    default {
        $releaseName = 'v{0}-{1}' -f $manifest.ModuleVersion, $BranchName
    }  
}
try {
    #Publish-Module -Name $env:ProjectName -NuGetApiKey $env:PS_GALLERY_KEY
    $releaseData = @{
        tag_name   = $releaseName
        #target_commitish = $env:GITHUB_SHA
        name       = $releaseName
        body       = $ChangeLog
        draft      = $false
        prerelease = $false
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
    Compress-Archive -DestinationPath "./$($env:ProjectName)_$($manifest.ModuleVersion).zip" -Path "./$env:ProjectName/Az.Avd*"

    $uploadParams = @{
        Uri         = ($newRelease.upload_url -replace '\{\?name.*\}', '?name=AzAvd_') +
        $manifest.ModuleVersion + '.zip'
        Method      = 'POST'
        ContentType = 'application/zip'
        InFile      = "./$($env:ProjectName)_$($manifest.ModuleVersion).zip"
        Header      = @{
            Authorization = "token $GitHubKey"
        }
    }
    $null = Invoke-RestMethod @uploadParams
}
catch {
    Throw "Not able to upload files to release. $_"
}