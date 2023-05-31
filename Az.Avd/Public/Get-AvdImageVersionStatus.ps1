Function Get-AvdImageVersionStatus {
    <#
    .SYNOPSIS
    Gets the image version from where the session host is started from.
    .DESCRIPTION
    The function will help you getting insights if there are session hosts started from an old version in relation to the Shared Image Gallery
    .PARAMETER HostpoolName
    Enter the AVD Hostpool name
    .PARAMETER ResourceGroupName
    Enter the AVD Hostpool resourcegroup name
    .PARAMETER SessionHostName
    Enter the session host name.
    .PARAMETER NotLatest
    This is a switch parameter which let you control the output to show only the sessionhosts which are not started from the latest version.
    .EXAMPLE
    Get-AvdImageVersionStatus -HostpoolName avd-hostpool-001 -ResourceGroupName rg-avd-001
    .EXAMPLE
    Get-AvdImageVersionStatus -HostpoolName avd-hostpool-001 -ResourceGroupName rg-avd-001 -NotLatest
    .EXAMPLE
    Get-AvdImageVersionStatus -HostpoolName avd-hostpool-001 -ResourceGroupName rg-avd-001 -SessionHostName avd.host -NotLatest
    #>
    [CmdletBinding(DefaultParameterSetName = 'Hostpool')]
    param (
        [parameter(Mandatory, ParameterSetName = 'Hostpool')]
        [parameter(Mandatory, ParameterSetName = 'Sessionhost')]
        [ValidateNotNullOrEmpty()]
        [string]$HostpoolName,

        [parameter(Mandatory, ParameterSetName = 'Hostpool')]
        [parameter(Mandatory, ParameterSetName = 'Sessionhost')]
        [ValidateNotNullOrEmpty()]
        [string]$ResourceGroupName,

        [parameter(ParameterSetName = 'Sessionhost')]
        [ValidateNotNullOrEmpty()]
        [string]$SessionHostName,

        [parameter()]
        [switch]$NotLatest
    )
    Begin {
        Write-Verbose "Start searching"
        AuthenticationCheck
        $token = GetAuthToken -resource $global:AzureApiUrl
        $apiVersion = "?api-version=2022-01-03"
    }
    Process {
        switch ($PsCmdlet.ParameterSetName) {
            Sessionhost {
                $Parameters = @{
                    HostPoolName      = $HostpoolName
                    ResourceGroupName = $ResourceGroupName
                    Name              = $SessionHostName
                }
            }
            Default {
                $Parameters = @{
                    HostPoolName      = $HostpoolName
                    ResourceGroupName = $ResourceGroupName
                }
            }
        }
        try {
            $sessionHosts = Get-AvdSessionHostResources @Parameters
        }
        catch {
            Throw "No sessionhosts found, $_"
        }
        if ($sessionHosts) {
            $returnObject = [System.Collections.ArrayList]@()
            $sessionHosts | Foreach-Object {
                Write-Verbose "Searching for $($_.Name)"
                $isLatestVersion = $false
                $imageVersionId = $_.vmResources.properties.storageprofile.imagereference.id
                $filterIdRegex = [Regex]::new("(.*)(?=/versions)") 
                if ($imageVersionId) {
                    if ($filterIdRegex.Match($imageVersionId).Value) {
                        # Stripping last part from whole image version id. 
                        Write-Verbose "Image ID has a version in it, grabbing the image itself"
                        $imageId = $filterIdRegex.Match($imageVersionId).Value    
                        $imageNameRegex = [Regex]::new("(?<=images/)(.*)(?=/versions)")      
                        $imageName = $imageNameRegex.Match($imageVersionId).Value
                    }
                    else {
                        Write-Verbose "Image ID is without a version. Image ID is correct allready"
                        $imageId = $imageVersionId
                        $imageNameRegex = [Regex]::new("(?<=images/)(.*)")      
                        $imageName = $imageNameRegex.Match($imageVersionId).Value
                    }
                    $galleryNameRegex = [Regex]::new("(?<=galleries/)(.*)(?=/images)")
                    $galleryName = $galleryNameRegex.Match($imageVersionId).Value
                    Write-Verbose "Image ID found!, $imageId"
                    try {
                        $requestParameters = @{
                            uri    = "{0}{1}/versions{2}" -f $global:AzureApiUrl, $imageId, $apiVersion
                            header = $token
                            method = "GET"
                        }
                        $allVersionsRequest = (Invoke-RestMethod @requestParameters).value | Select-Object Name -Last 1
                        if ($_.vmResources.properties.storageprofile.imagereference.exactVersion -eq $($allVersionsRequest.name)) {
                            $isLatestVersion = $true
                        }
                        else {
                            $isLatestVersion = $false
                        }
                        $imageInfo = [PSCustomObject]@{
                            currentImageVersion = $_.vmResources.properties.storageprofile.imagereference.exactVersion
                            latestVersion       = $allVersionsRequest.name
                            isLatestVersion     = $isLatestVersion
                            imageId             = $imageId
                            imageName           = $imageName
                            imageVersionId      = $imageVersionId
                            galleryName         = $galleryName
                            hostpoolName        = $HostpoolName
                            resourceGroupName   = $ResourceGroupName
                            sessionHostName     = $_.Name
                            sessionHostId       = $_.Id
                            vmId                = $_.vmResources.id
                        }
                    }
                    catch {
                        Write-Warning "Someting went wrong when crawling for info at url $($requestParameters.uri), $_"
                    }
                }
                else {
                    $imageInfo = $false
                    Write-Warning "Sessionhost $($_.name) has no image version"
                }
                $returnObject.Add($imageInfo) | Out-Null
            }
        }
        else {
            Write-Error "No Sessionhosts with resources found in hostpool $HostpoolName"
        }
    }
    End {
        if ($NotLatest.IsPresent) {
            $returnObject | Where-Object { $_.isLatestVersion -eq $false }
        }
        else {
            $returnObject
        }
    }
}