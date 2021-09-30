function New-AvdVmTemplate {
    <#
    .SYNOPSIS
    Creates a VM template in the AVD hostpool. 
    .DESCRIPTION
    The function will create an AVD VM template for session hosts. This template is configured in the hostpool
    .PARAMETER HostpoolName
    Enter the AVD Hostpool name
    .PARAMETER ResourceGroupName
    Enter the AVD Hostpool resourcegroup name
    .PARAMETER domain
    Enter the sessionhosts domain
    .PARAMETER galleryImageOffer
    Enter the gallery image offer
    .PARAMETER galleryImagePublisher
    Enter the gallery image publisher
    .PARAMETER galleryImageSKU
    Enter the gallery image sku
    .PARAMETER imageType
    Enter the image type. (default: CustomImage)
    .PARAMETER imageUri
    The url of an image (.vhd)
    .PARAMETER customImageId
    The resourceId of an image or image version
    .PARAMETER namePrefix
    The sessionhosts name prefix (avd-)
    .PARAMETER useManagedDisks
    The use of a managed disk or not (default: True)
    .PARAMETER osDiskType
    The OS disk type ("Standard_LRS", "Premium_LRS", "StandardSSD_LRS")
    .PARAMETER vmSku
    This is the part of the VMsize information. (eg. Standard_B2ms)
    .PARAMETER vmCores
    This is the part of the VMsize information. How many cores.
    .PARAMETER vmRam
    This is the part of the VMsize information. The RAM size in GB.
    .PARAMETER CustomObject
    Can be used to add extra values into the template. Please provide a PSCustomObject.
    .EXAMPLE
    $customObjects = @{
        TestObject = 'TestValue'
    }
    create-AvdVmTemplate -HostpoolName avd-hostpool -ResourceGroupName rg-avd-01 -domain domain.local -namePrefix avd -vmSku 'Standard_B2ms' -vmCores 2 -vmRam 8 -osDiskType "Premium_LRS" -CustomObjects $customObjects
    .EXAMPLE
    create-AvdVmTemplate -HostpoolName avd-hostpool -ResourceGroupName rg-avd-01 -domain domain.local -namePrefix avd -vmSku 'Standard_B2ms' -vmCores 2 -vmRam 8 -osDiskType "Premium_LRS" 
    #>
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$HostpoolName,
    
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$ResourceGroupName,
    
        [ValidatePattern("(?:[a-zA-Z0-9_\-]{1,63})+\.+(?:[a-zA-Z]{2,})$")]
        [Parameter(HelpMessage = 'Please fill in a complete domain name (eg. domain.local)')]
        [string]$domain,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$galleryImageOffer,
        
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$galleryImagePublisher,
        
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$galleryImageSKU,
        
        [Parameter()]
        [ValidateSet("CustomImage")]
        [ValidateNotNullOrEmpty()]
        [string]$imageType,
        
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$imageUri,
        
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$customImageId,
        
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$namePrefix,
        
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$useManagedDisks = $true,
        
        [Parameter(Mandatory)]
        [ValidateSet("Standard_LRS", "Premium_LRS", "StandardSSD_LRS")]
        [ValidateNotNullOrEmpty()]
        [string]$osDiskType = '',

        [Parameter(Mandatory, HelpMessage = 'Please fill in a complete domain name (eg. Standard_B2ms)')]
        [ValidateNotNullOrEmpty()]
        [String]$vmSku,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [String]$vmCores,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [String]$vmRam,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [object]$CustomObject
    )
    Begin {
        Write-Verbose "Start searching"
        AuthenticationCheck
        $token = GetAuthToken -resource "https://management.azure.com"
        $apiVersion = "?api-version=2019-12-10-preview"
        $url = "https://management.azure.com/subscriptions/" + $script:subscriptionId + "/resourceGroups/" + $ResourceGroupName + "/providers/Microsoft.DesktopVirtualization/hostpools/" + $HostpoolName + $apiVersion
        $parameters = @{
            uri     = $url
            Headers = $token
        }
        $vmSize = @{
            id=$vmSku
            cores=$vmCores
            ram=$vmRam
        }
        $vmTemplate =  [PSCustomObject]@{
            domain=$domain
            osDiskType=$osDiskType
            namePrefix = $namePrefix
            vmSize = $vmSize
            galleryImageOffer=$galleryImageOffer
            galleryImagePublisher=$galleryImagePublisher
            galleryImageSKU=$galleryImageSKU
            imageType=$imageType
            imageUri=$imageUri
            customImageId=$customImageId
            useManagedDisks=$useManagedDisks
            galleryItemId=$galleryItemId
        }

        if ($CustomObject){
            $CustomObject.GetEnumerator() | ForEach-Object {
                $vmTemplate | Add-Member -NotePropertyName $_.Key -NotePropertyValue $_.Value
            }
        }
        $body = @{
            properties = @{
                vmTemplate = $vmTemplate | ConvertTo-Json -Compress
                }
        }       
    }
    Process {
        $jsonBody = $body | ConvertTo-Json
        $parameters = @{
            uri     = $url
            Method  = "PATCH"
            Headers = $token
            Body    = $jsonBody
        }
        $results = Invoke-RestMethod @parameters
        return $results
    }
}