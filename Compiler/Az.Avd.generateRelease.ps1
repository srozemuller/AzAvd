Write-Host "Executing Deploy.PS1"
$env:ProjectName = "Az.Avd"
if (
    $env:BuildSystem -eq 'GitHub Actions'
) {
    if ($env:BranchName -eq 'master' -and
        $env:NuGetApiKey -and
        $env:GitHubKey
    ) {
        Write-Information "Publishing to PowerShell Gallery "
        $modulePath = "./$env:ProjectName/$env:ProjectName.psd1"
        $manifest = Import-PowerShellDataFile -Path $modulePath
        Import-Module $modulePath
        Publish-Module -Name $env:ProjectName -NuGetApiKey $env:PS_GALLERY_KEY


        Write-Host "Creating GitHub release" -ForegroundColor Green
        $releaseData = @{
            tag_name = '{0}' -f $manifest.ModuleVersion
            target_commitish = $env:GITHUB_SHA
            name = '{0}' -f $manifest.ModuleVersion
            body = $manifest.PrivateData.PSData.ReleaseNotes
            draft = $false
            prerelease = $false
        }

        $releaseParams = @{
            Uri = "https://api.github.com/repos/$env:GITHUB_REPOSITORY/releases?access_token=$env:GitHubKey"
            Method = 'POST'
            ContentType = 'application/json'
            Body = (ConvertTo-Json $releaseData -Compress)
            UseBasicParsing = $true
        }
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        $newRelease = Invoke-RestMethod @releaseParams

        Compress-Archive -DestinationPath "./BuildOutput/$($env:ProjectName)_$($manifest.ModuleVersion).zip" -Path "./$env:ProjectName/*"

        $uploadParams = @{
            Uri = ($newRelease.upload_url -replace '\{\?name.*\}', '?name=AzAvd_') +
                $manifest.ModuleVersion +
                '.zip&access_token=' +
                $env:GitHubKey
            Method = 'POST'
            ContentType = 'application/zip'
            InFile = "./BuildOutput/$($env:ProjectName)_$($manifest.ModuleVersion).zip"
        }

        $null = Invoke-RestMethod @uploadParams
    } else {
        write-host "Did not comply with release conditions"
        Write-Host "BranchName: $env:BranchName"
        Write-Host "NuGetApiKey: $env:NuGetApiKey"
        Write-Host "GitHubKey: $env:GitHubKey"
        Write-Host "CommitMessage: $env:CommitMessage"
    }
} else {
    Write-Host "Not In Github Actions. Skipped"
}