[CmdletBinding()]
param (
    [Parameter()]
    [string]$GitHubKey
)
Write-Host "Executing Deploy.PS1"
$env:ProjectName = "Az.Avd"
if (
    $env:BuildSystem -eq 'GitHub Actions'
) {
    if ($env:BranchName -eq 'master' -and $GitHubKey) {
        Write-Host "Creating GitHub release" -ForegroundColor Green
        $modulePath = "./$env:ProjectName/$env:ProjectName.psd1"
        $manifest = Import-PowerShellDataFile -Path $modulePath
        Import-Module $modulePath
        #Publish-Module -Name $env:ProjectName -NuGetApiKey $env:PS_GALLERY_KEY
        $releaseData = @{
            tag_name = '{0}' -f $manifest.ModuleVersion
            target_commitish = $env:GITHUB_SHA
            name = '{0}' -f $manifest.ModuleVersion
            body = $manifest.PrivateData.PSData.ReleaseNotes
            draft = $false
            prerelease = $false
        }

        $releaseParams = @{
            Uri = "$env:GITHUB_API_URL/repos/$env:GITHUB_REPOSITORY/releases"
            Method = 'POST'
            Body = (ConvertTo-Json $releaseData -Compress)
            UseBasicParsing = $true
            Header = @{
                ContentType = 'application/json'
                Authorization = "$GitHubKey"
            }
        }
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        $newRelease = Invoke-RestMethod @releaseParams

        Compress-Archive -DestinationPath "./BuildOutput/$($env:ProjectName)_$($manifest.ModuleVersion).zip" -Path "./$env:ProjectName/*"

        $uploadParams = @{
            Uri = ($newRelease.upload_url -replace '\{\?name.*\}', '?name=AzAvd_') +
                $manifest.ModuleVersion +
                '.zip&access_token=' +
                $GitHubKey
            Method = 'POST'
            ContentType = 'application/zip'
            InFile = "./BuildOutput/$($env:ProjectName)_$($manifest.ModuleVersion).zip"
        }

        $null = Invoke-RestMethod @uploadParams
    } else {
        write-host "Did not comply with release conditions"
        Write-Host "BranchName: $env:BranchName"
        Write-Host "GitHubKey: $GitHubKey"
        Write-Host "CommitMessage: $env:CommitMessage"
    }
} else {
    Write-Host "Not In Github Actions. Skipped"
}