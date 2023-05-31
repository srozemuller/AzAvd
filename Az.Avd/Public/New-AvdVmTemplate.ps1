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
    .PARAMETER Domain
    Enter the sessionhosts domain
    .PARAMETER GalleryImageOffer
    Enter the gallery image offer
    .PARAMETER GalleryImagePublisher
    Enter the gallery image publisher
    .PARAMETER GalleryImageSKU
    Enter the gallery image sku
    .PARAMETER ImageType
    Enter the image type. (default: CustomImage)
    .PARAMETER ImageUri
    The url of an image (.vhd)
    .PARAMETER CustomImageId
    The resourceId of an image or image version
    .PARAMETER NamePrefix
    The sessionhosts name prefix (avd-)
    .PARAMETER UseManagedDisks
    The use of a managed disk or not (default: True)
    .PARAMETER OsDiskType
    The OS disk type ("Standard_LRS", "Premium_LRS", "StandardSSD_LRS")
    .PARAMETER VmSku
    This is the part of the VMsize information. (eg. Standard_B2ms)
    .PARAMETER VmCores
    This is the part of the VMsize information. How many cores.
    .PARAMETER VmRam
    This is the part of the VMsize information. The RAM size in GB.
    .PARAMETER CustomObject
    Can be used to add extra values into the template. Please provide a PSCustomObject.
    .EXAMPLE
    New-AvdVmTemplate-HostpoolName avd-hostpool -ResourceGroupName rg-avd-01 -domain domain.local -namePrefix avd -vmSku 'Standard_B2ms' -vmCores 2 -vmRam 8 -osDiskType "Premium_LRS" -CustomObject $customObjects
    .EXAMPLE
    New-AvdVmTemplate -HostpoolName avd-hostpool -ResourceGroupName rg-avd-01 -domain domain.local -namePrefix avd -vmSku 'Standard_B2ms' -vmCores 2 -vmRam 8 -osDiskType "Premium_LRS" 
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
    
        [ValidatePattern("(?:[a-zA-Z0-9_\-]{1,63})+\.+(?:[a-zA-Z]{2,})$", ErrorMessage = "Please fill in a complete domain name (eg. domain.local)")]
        [string]$Domain,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$GalleryImageOffer,
        
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$GalleryImagePublisher,
        
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$GalleryImageSku,
        
        [Parameter()]
        [ValidateSet("CustomImage")]
        [ValidateNotNullOrEmpty()]
        [string]$ImageType,
        
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$ImageUri,
        
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$CustomImageId,
        
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$NamePrefix,
        
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$UseManagedDisks = $true,
        
        [Parameter(Mandatory)]
        [ValidateSet("Standard_LRS", "Premium_LRS", "StandardSSD_LRS")]
        [ValidateNotNullOrEmpty()]
        [string]$OsDiskType,

        [Parameter(Mandatory, HelpMessage = 'Please fill in a complete domain name (eg. Standard_B2ms)')]
        [ValidateNotNullOrEmpty()]
        [String]$VmSku,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [String]$VmCores,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [String]$VmRam,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [object]$CustomObject
    )
    Begin {
        Write-Verbose "Start searching"
        AuthenticationCheck
        $token = GetAuthToken -resource $global:AzureApiUrl
        $apiVersion = "?api-version=2019-12-10-preview"
        $url = "{0}/subscriptions/{1}/resourceGroups/{2}/providers/Microsoft.DesktopVirtualization/hostpools/{3}{4}" -f $global:AzureApiUrl, $global:subscriptionId, $ResourceGroupName, $HostpoolName, $apiVersion
        $parameters = @{
            uri     = $url
            Headers = $token
        }
        $vmSize = @{
            id    = $VmSku
            cores = $VmCores
            ram   = $VmRam
        }
        $vmTemplate = [PSCustomObject]@{
            domain                = $Domain
            osDiskType            = $OsDiskType
            namePrefix            = $NamePrefix
            vmSize                = $vmSize
            galleryImageOffer     = $GalleryImageOffer
            galleryImagePublisher = $GalleryImagePublisher
            galleryImageSKU       = $GalleryImageSku
            imageType             = $ImageType
            imageUri              = $ImageUri
            customImageId         = $CustomImageId
            useManagedDisks       = $UseManagedDisks
            galleryItemId         = $GalleryItemId
        }

        if ($CustomObject) {
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
        try {
            $jsonBody = $body | ConvertTo-Json
            $parameters = @{
                uri     = $url
                Method  = "PATCH"
                Headers = $token
                Body    = $jsonBody
            }
            Write-Information "VM template added to hostpool $HostpoolName"
            Write-Verbose "Template added with following values (in JSON format):"
            Write-Verbose $vmTemplate
            Invoke-RestMethod @parameters
        }
        catch {
            "Template not added, $_"
        }
    }
}