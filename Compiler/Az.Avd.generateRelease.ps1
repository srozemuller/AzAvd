[CmdletBinding()]
param (
    [Parameter()]
    [string]$GitHubKey
)
if ($GitHubKey) {
    $env:ProjectName = "Az.Avd"
    Write-Host "Creating GitHub release" -ForegroundColor Green
    $modulePath = "./$env:ProjectName/$env:ProjectName.psd1"
    $manifest = Import-PowerShellDataFile -Path $modulePath
    Import-Module $modulePath -Force
    switch ($env:GITHUB_REF_NAME) {
        beta {
            $releaseName = '{0}-{1}-beta' -f $manifest.ModuleVersion, $env:GITHUB_RUN_NUMBER
        }
        default {
            $releaseName = '{0}' -f $manifest.ModuleVersion 
        }
    }
    #Publish-Module -Name $env:ProjectName -NuGetApiKey $env:PS_GALLERY_KEY
    $releaseData = @{
        tag_name   = '{0}' -f $manifest.ModuleVersion
        #target_commitish = $env:GITHUB_SHA
        name       = $releaseName
        body       = $manifest.PrivateData.PSData.ReleaseNotes
        draft      = $false
        prerelease = $false
    }

    $releaseParams = @{
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
    $newRelease = Invoke-RestMethod @releaseParams

    Compress-Archive -DestinationPath "./$($env:ProjectName)_$($manifest.ModuleVersion).zip" -Path "./$env:ProjectName/*"

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
else {
    write-host "Did not comply with release conditions"
    Write-Host "BranchName: $env:GITHUB_REF_NAME"
    Write-Host "GitHubKey: $GitHubKey"
    Write-Host "CommitMessage: $env:GITHUB_RUN_ID"
}
