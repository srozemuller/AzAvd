$modulePath = Join-Path -Path (Join-Path ".././" -ChildPath "AzAvd") -ChildPath "Az.Avd"
$moduleFunctions = (Import-PowerShellDataFile (Join-Path -Path $modulePath -ChildPath "Az.Avd.psd1")).FunctionsToExport
BeforeAll {
    $modulePath = Join-Path -Path (Join-Path ".././" -ChildPath "AzAvd") -ChildPath "Az.Avd"
    Write-Host $modulePath
    Write-Host "In before $modulePath"
    (Join-Path -Path $modulePath -ChildPath "Public")
    $psFiles = (Get-ChildItem -Path (Join-Path -Path $modulePath -ChildPath "Public")).BaseName
}

Describe "Analyze code" -ForEach @(
    foreach ($function in $moduleFunctions) {
        @{
            function    = $function
            helpInfo    = Get-Help $function
            IgnoreRules = @('PSUseApprovedVerbs')
            fileobj     = $file
        }
    }
){
    It "<function> should exist in file base" {
        $function -in $psFiles | Should -Be $true
    }

    It  "<function> has a synopsis that is valid" {
        if ( $helpInfo.synopsis -eq $null) {
            $helpInfo.synopsis | Should -not -Be $null -Because 'every ps1 file should have a synopsis block'
        }
        elseif ( $helpInfo.synopsis -eq 'Short description') {
            $helpInfo.synopsis | Should -not -Be 'Short description' -Because 'thats just lazy'
        }
    }

    It  "<function> has a description that is valid" {
        if ( $helpInfo.description -eq $null) {
            $helpInfo.description | Should -not -Be $null -Because 'every ps1 file should have a synopsis block'
        }
        elseif ( $helpInfo.description -eq 'Long description') {
            $helpInfo.description | Should -not -Be 'Long description' -Because 'thats just lazy'
        }
    }

    It "Uses PascalCase for function <function>" {
        $function | Should -MatchExactly '^[A-Z].*' -Because "PascalCasing"
    }
}