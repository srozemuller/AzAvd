
$ProjectName = "Az.Avd"
[string]$helpFolder = Join-Path -Path (Join-Path ".././" -ChildPath "AzAvd") -ChildPath "Docs"
$modulePath = Join-Path -Path (Join-Path ".././" -ChildPath "AzAvd") -ChildPath $ProjectName
[string]$output = Join-Path (Get-Location) "/Docs"
[cultureinfo]$HelpCultureInfo = 'en-US'

Import-Module -Force $modulePath
Update-MarkdownHelpModule -Path $output
New-ExternalHelp -Path $HelpFolder -OutputPath "$modulePath\$HelpCultureInfo" -Force
