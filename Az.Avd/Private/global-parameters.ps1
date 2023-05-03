# In this file all global parameters are set. 

$script:AzureApiUrl = "https://management.azure.com/"
$script:GraphApiUrl = "https://graph.microsoft.com"
$script:GraphApiVersion = "beta"

$script:AvdModuleLocation = "https://wvdportalstorageblob.blob.core.windows.net/galleryartifacts/Configuration_01-19-2023.zip"

# Resource provider API versions
$script:sessionHostApiVersion = "2022-02-10-preview"
$script:vmApiVersion = "2022-11-01"
$script:HostpoolApiVersion = "2022-02-10-preview"
$script:DiagnosticsApiVersion = "2020-08-01"
$Script:AvdDiagnosticsApiVersion = "2021-05-01-preview"

$script:AvdInsightsCountersLocation = '$PSScriptRoot\..\Private\avdinsights-sources.json'

