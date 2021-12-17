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
        $token = GetAuthToken -resource $Script:AzureApiUrl
        $apiVersion = "?api-version=2021-07-01"
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
            $sessionHosts | Foreach-Object {
                $isLatestVersion = $false
                $imageVersionId = $_.vmResources.properties.storageprofile.imagereference.id
                if ($imageVersionId) {
                    Write-Verbose "Searching for $($_.Name)"
                    # Stripping last part from whole image version id. 
                    $filterIdRegex = [Regex]::new("(.*)(?=/versions)")
                    $imageId = $filterIdRegex.Match($imageVersionId).Value
                    $imageNameRegex = [Regex]::new("(?<=images/)(.*)(?=/versions)")           
                    $imageName = $imageNameRegex.Match($imageVersionId).Value
                    $galleryNameRegex = [Regex]::new("(?<=galleries/)(.*)(?=/images)")
                    $galleryName = $galleryNameRegex.Match($imageVersionId).Value     
                    try {
                        $requestParameters = @{
                            uri    = $Script:AzureApiUrl + $imageId + "/versions" + $apiVersion
                            header = $token
                            method = "GET"
                        }
                        $allVersionsRequest = (Invoke-RestMethod @requestParameters).value | Sort-Object name
                        if ($_.vmResources.properties.storageprofile.imagereference.exactVersion -eq $($allVersionsRequest.name | Select-Object -Last 1)) {
                            $isLatestVersion = $true
                        }
                        else {
                            $isLatestVersion = $false
                        }
                        $imageInfo = @{
                            currentImageVersion = $_.vmResources.properties.storageprofile.imagereference.exactVersion
                            latestVersion = $allVersionsRequest.name | Select-Object -Last 1
                            isLatestVersion = $isLatestVersion
                            imageName = $imageName
                            imageId = $imageId
                            imageVersionId = $imageVersionId
                            galleryName = $galleryName
                        }
                    }
                    catch {
                        Write-Warning "Someting went wrong when crawling for info, $_"
                    }
                }
                else {
                    $imageInfo = $false
                    Write-Warning "Sessionhost $($_.name) has no image version"
                }
                $_ | Add-Member -NotePropertyName imageInfo -NotePropertyValue $imageInfo -Force
            }
        }
        else {
            Write-Error "No Sessionhosts with resources found in hostpool $HostpoolName"
        }
    }
    End {
        if ($NotLatest){
            $sessionHosts | Where-Object {$_.imageInfo.isLatestVersion -eq $false}
        }
        else {
            $sessionHosts
        }
    }
}
