# In this file all global parameters are set. 

$global:AzureApiUrl = "https://management.azure.com"
$global:GraphApiUrl = "https://graph.microsoft.com"
$global:GraphApiVersion = "beta"

$global:AvdModuleLocation = "https://wvdportalstorageblob.blob.core.windows.net/galleryartifacts/Configuration_1.0.02404.172.zip"

$global:AvdApiVersion = "2022-02-10-preview"

# Resource provider API versions
$global:sessionHostApiVersion = $global:AvdApiVersion
$global:vmApiVersion = "2022-11-01"
$global:hostpoolApiVersion = $global:AvdApiVersion
$global:applicationGroupApiVersion = $global:AvdApiVersion
$global:workspaceApiVersion = $global:AvdApiVersion
$global:diagnosticsApiVersion = "2020-08-01"
$global:avdDiagnosticsApiVersion = "2021-05-01-preview"
$global:workbookApiVersion = "2021-08-01"
$global:virtualMachineVersion = "2023-03-01"

$global:scalingPlanApiVersion = "2023-03-21-privatepreview"
$global:scalingPlanScheduleApiVersion = "2022-10-14-preview"

$global:AvdInsightsCountersLocation = '$PSScriptRoot\..\Private\avdinsights-sources.json'

