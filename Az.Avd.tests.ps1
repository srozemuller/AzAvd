$module = 'Az.Avd'
$modulePath = Join-Path -Path $(Get-Location) -ChildPath "AzAvd"
$functions = Get-ChildItem -Path (Join-Path -Path $modulePath -ChildPath "Public")
Describe "$module Global module tests" {

    Context 'Module Setup' {
        It "$module has the root module $module.psm1" {
            $modulePath | Should -Exist
        }
 
        It "$module has the a manifest file of $module.psm1" {
            (Join-Path -Path $modulePath -ChildPath "Az.Avd.psm1") | Should -Exist
            (Join-Path -Path $modulePath -ChildPath "Az.Avd.psd1") | Should -Exist
        }

        It "$module folder has functions folder" {
            (Join-Path -Path $modulePath -ChildPath "Public") | Should -Exist
        }
 
        It "$module folder has private functions folder" {
            (Join-Path -Path $modulePath -ChildPath "Private") | Should -Exist
        }
        

        It "$module is valid PowerShell code" {
            $psFile = Get-Content -Path (Join-Path -Path $modulePath -ChildPath "Az.Avd.psm1") -ErrorAction Stop
            $errors = $null
            $null = [System.Management.Automation.PSParser]::Tokenize($psFile, [ref]$errors)
            $errors.Count | Should -Be 0
        }
 
    } # Context 'Module Setup'
    Context "Test functions in $module" -Foreach $functions[8] {
        BeforeAll {
            $file = $_
            $content = Get-Content -Path $file
        }
        It "$($_.Name) should exist" {
                Test-Path $_ | Should -Be $true
            }

            It "$($_.Name) should have content" {
                $_.Length | Should -BeGreaterThan 0
            }

            It "$($_.Name) should have help block" {
                $_ | Should -FileContentMatch '<#'
                $_ | Should -FileContentMatch '#>'
            }
 
            It "$($_.Name) should have a SYNOPSIS section in the help block" {
                $_ | Should -FileContentMatch '.SYNOPSIS'
            }
    
            It "$($_.Name) should have a DESCRIPTION section in the help block" {
                $_ | Should -FileContentMatch '.DESCRIPTION'
            }
 
            It "$($_.Name) should have a EXAMPLE section in the help block" {
                $_ | Should -FileContentMatch '.EXAMPLE'
            }
     
            It "$($_.Name) should be an advanced function" {
                $_ | Should -FileContentMatch 'function'
                $_ | Should -FileContentMatch 'cmdletbinding'
                $_ | Should -FileContentMatch 'param'
            }
       
            It "$($_.Name) should contain Write-Verbose blocks" {
                $_ | Should -FileContentMatch 'Write-Verbose'
            }

            It "$($_.Name) should not contain Write-Host" {
                $_ | Should -Not -FileContentMatch 'Write-Host'
            }

            It "$($_.Name) should not contain return in functions" {
                $_ | Should -Not -FileContentMatch 'return `$'
            }

            It "$($_.Name) should have an AuthenticationCheck" {
               ($content | Select-String -Pattern 'AuthenticationCheck') | Should -Be $true
            }
            
            It "$($_.Name) function start with function name and should be $($_.BaseName) " {
                $content[0] -match "function $($_.BaseName) {" | Should -Be $true
            }

            It "$($_.Name) is valid PowerShell code" {
                $psFile = Get-Content -Path $_ -ErrorAction Stop
                $errors = $null
                $null = [System.Management.Automation.PSParser]::Tokenize($psFile, [ref]$errors)
                $errors.Count | Should -Be 0
            }
        } # foreach ($function in $functions)
    
}