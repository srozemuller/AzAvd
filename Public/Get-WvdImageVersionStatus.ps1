#requires -module @{ModuleName = 'Az.ResourceGraph'; ModuleVersion = '0.7.6'}
Function Get-WvdImageVersionStatus {
    <#
    .SYNOPSIS
    Gets the image version from where the session host is started from.
    .DESCRIPTION
    The function will help you getting insights if there are session hosts started from an old version in relation to the Shared Image Gallery
    .PARAMETER HostpoolName
    Enter the WVD Hostpool name
    .PARAMETER ResourceGroupName
    Enter the WVD Hostpool resourcegroup name
    .PARAMETER SessionHostName
    Enter the session host name.
    .PARAMETER NotLatest
    This is a switch parameter which let you control the output to show only the sessionhosts which are not started from the latest version.
    .EXAMPLE
    Get-WvdImageVersionStatus -HostpoolName wvd-hostpool-001 -ResourceGroupName rg-wvd-001
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
            $SessionHosts = Get-AzWvdSessionHost @Parameters
        }
        catch {
            Throw "No sessionhosts found, $_"
        }
        $sessionhostsIds = [system.String]::Join("`",`"", $SessionHosts.ResourceId)
        $Query = 
        'resources 
        | where type =~ "microsoft.compute/virtualmachines" 
        and isnotempty(properties.storageProfile.imageReference.exactVersion)
        and id in~ ("'+ $sessionhostsIds + '")
        | extend currentImageVersion = properties.storageProfile.imageReference.exactVersion
        | extend imageName=split(properties.storageProfile.imageReference.id,"/")[10]
        | project tostring(imageName), tostring(currentImageVersion), vmId=id, vmName=name, hostpoolName = tolower("'+ $HostpoolName + '"), ResourceGroupName = "' + $ResourceGroupName + '"
        | join kind=inner(
        resources
        | where type=~"microsoft.compute/galleries/images/versions"
        | extend  imageName=split(id,"/")[10]
        | project id, name, tostring(imageName)
        | join kind=inner ( 
        resources 
        | where type =~ "microsoft.compute/galleries/images/versions"
        | extend versionDetails=split(id,"/")
        | project id, name, imageName=versionDetails[10], imageGallery=versionDetails[8], resourceGroup, subscriptionId
        | summarize lastVersion=max(tostring(name)) by tostring(imageName) , tostring(imageGallery), resourceGroup, subscriptionId
        ) on imageName
        | extend latestVersion = case(name != lastVersion, false, true)
        | where latestVersion == true
        ) on imageName
        | extend vmLatestVersion = case(currentImageVersion != lastVersion, false, true)
        | extend vmDetails = split(vmId,"/")
        | join kind=inner (
        resources | where type =~ "microsoft.desktopvirtualization/hostpools" and name =~ "'+ $HostpoolName + '" and resourceGroup =~ "' + $ResourceGroupName + '"
        | extend vmTemplate=parse_json(tostring(parse_json(properties.vmTemplate)))
        | extend registrationInfo=properties.registrationInfo
        | project hostpoolName=tolower(name), resourceGroup, domain=vmTemplate.domain
        ) on hostpoolName
        | project vmLatestVersion,vmName,imageName, currentImageVersion, vmId, imageGallery, resourceGroupName=resourceGroup, subscriptionId, lastVersion, hostpoolName, sessionHostName=strcat(vmName, ".", domain)
        '
        if ($NotLatest.IsPresent) {
            $LatestQuery = '| where vmLatestVersion == false'
            $Query = $Query + $LatestQuery
        }
        return Search-AzGraph -Query $Query   
    }
}
