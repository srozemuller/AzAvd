$module = 'Az.Avd'
Describe "$module Global module tests" {
    Context 'Module Setup' {
        BeforeAll {
            $modulePath = Join-Path -Path (Join-Path ".././" -ChildPath "AzAvd") -ChildPath "Az.Avd"
            $binaryFile = "Az.Avd.psm1"
            $manifestFile = "Az.Avd.psd1"
            $moduleContent = Get-Content -Path (Join-Path -Path $modulePath -ChildPath $manifestFile)
        }
        It "$module has the root module $module.psm1" {
            $modulePath | Should -Exist
        }
 
        It "$module has the a manifest file of $module.psm1" {
            (Join-Path -Path $modulePath -ChildPath $binaryFile) | Should -Exist
            (Join-Path -Path $modulePath -ChildPath $manifestFile) | Should -Exist
        }

        It "$module folder has functions folder" {
            (Join-Path -Path $modulePath -ChildPath "Public") | Should -Exist
        }
 
        It "$module folder has private functions folder" {
            (Join-Path -Path $modulePath -ChildPath "Private") | Should -Exist
        }
        
        It "$module root module should be $binaryFile in $manifestFile" {
            $pattern = "RootModule"
            $rootModule = ($moduleContent | Where-Object { $_ -match $pattern }).Split("'")[1]
            $rootModule | Should -Be $binaryFile
        } 
        
        It "$module project URL should reachable" {
            $pattern = "ProjectUri"
            $url = ($moduleContent | Where-Object { $_ -match $pattern }).Split("'")[1]
            try {
                Invoke-WebRequest -Uri $Url -UseBasicParsing -DisableKeepAlive -method Head | Out-Null
                $exists = $true
            }
            catch {
                $exists = $false
            }
            $exists | Should -Be $true
        }

        It "$module version should be greater than PSGallery" {
            $pattern = "ModuleVersion"
            $sourceVersion = ($moduleContent | Where-Object { $_ -match $pattern }).Split("'")[1]
            $galleryVersion = (Find-Module -Name Az.Avd -Repository PSGallery).Version
            [version]$sourceVersion | Should -BeGreaterThan ([version]$galleryVersion)
        }      

        It "$module is valid PowerShell code" {
            $psFile = Get-Content -Path (Join-Path -Path $modulePath -ChildPath $binaryFile) -ErrorAction Stop
            $errors = $null
            $null = [System.Management.Automation.PSParser]::Tokenize($psFile, [ref]$errors)
            $errors.Count | Should -Be 0
        }
    }
}