# In this file all global parameters are set. 

$script:AzureApiUrl = "https://management.azure.com/"
$script:GraphApiUrl = "https://graph.microsoft.com"
$script:GraphApiVersion = "beta"

$script:AvdModuleLocation = "https://wvdportalstorageblob.blob.core.windows.net/galleryartifacts/Configuration_01-19-2023.zip"

$global:AvdApiVersion = "2022-02-10-preview"

# Resource provider API versions
$script:sessionHostApiVersion = $global:AvdApiVersion
$script:vmApiVersion = "2022-11-01"
$script:hostpoolApiVersion = $global:AvdApiVersion
$script:applicationGroupApiVersion = $global:AvdApiVersion
$script:workspaceApiVersion = $global:AvdApiVersion
$script:diagnosticsApiVersion = "2020-08-01"
$script:avdDiagnosticsApiVersion = "2021-05-01-preview"
$script:workbookApiVersion = "2021-08-01"



$script:AvdInsightsCountersLocation = '$PSScriptRoot\..\Private\avdinsights-sources.json'

