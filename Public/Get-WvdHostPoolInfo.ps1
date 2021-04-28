function Get-WvdHostPoolInfo {
    <#
.SYNOPSIS
Get WVD Hostpool information, including the underlaying session hosts
.DESCRIPTION
With this function you can get information about a WVD hostpool that includes the information about the underlaying session hosts.
.PARAMETER HostPoolName
Enter the name of the hostpool you want information from.
.PARAMETER ResourceGroupName
Enter the name of the resourcegroup where the hostpool resides in.
.EXAMPLE
Get-WvdHostPoolInfo -HostPoolName wvd-hostpool-001 -ResourceGroupName rg-wvd-001
#>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$HostPoolName,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$ResourceGroupName
    )
    Begin {
        Write-Verbose "Start searching"
        AuthenticationCheck
    }
    Process {
        $Query = 'resources | where type =~ "microsoft.desktopvirtualization/hostpools" and name =~ "' + $hostpoolName + '" and resourceGroup =~ "' + $ResourceGroupName + '"
    | extend vmTemplate=parse_json(tostring(parse_json(properties.vmTemplate)))
    | extend registrationInfo=properties.registrationInfo
	| project hostpoolId=id,hostpoolName=name,hostpoolDescription=properties.description,hostpoolLocation=location, domain=vmTemplate.domain, imageType=vmTemplate.imageType, resourceGroupName=tolower(resourceGroup), startVMOnConnect=properties.startVMOnConnect, 
    expirationTime=registrationInfo.expirationTime,maxSessionLimit=properties.maxSessionLimit, hostPoolType=properties.hostPoolType,validationEnvironment=properties.validationEnvironment, vmTemplate, properties
    | join kind=leftouter(
    resourcecontainers
    | where type =~ "microsoft.resources/subscriptions/resourcegroups"
	| project resourceGroupLocation=location, resourceGroupName=tolower(name)
    ) on resourceGroupName
    | project hostpoolId,hostpoolName,hostpoolDescription,hostpoolLocation,resourceGroupName,resourceGroupLocation,domain,startVMOnConnect,imageType,expirationTime,maxSessionLimit,hostPoolType,validationEnvironment,vmTemplate,properties
    '
        return Search-AzGraph -Query $Query
    }
    End {}
}
