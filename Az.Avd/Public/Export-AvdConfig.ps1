function Export-AvdConfig {
    <#
    .SYNOPSIS
    Exports the AVD environment, based on the hostpool name.
    .DESCRIPTION
    The function will help you exporting the complete AVD environment to common output types as HTML and CSV.
    .PARAMETER HostpoolName
    Enter the AVD hostpoolname name.
    .PARAMETER ResourceGroupName
    Enter the AVD hostpool resource group name.
    .PARAMETER FileName
    Enter the filename. Based on the format parameter the function will create a correct file. Default filepath is in the execution directory.
    .PARAMETER Format
    Enter the format you like. For creating more formats use a comma. 
    .EXAMPLE
    Export-AvdConfig -Hostpoolname avd-hostpool-001 -ResourceGroupName rg-avd-001 -Format HTML -Verbose -Filename AVDExport
    .EXAMPLE
    Export-AvdConfig -HostPoolName avd-hostpool-001 -ResourceGroupName rg-avd-001 -Format HTML,JSON -Verbose -Filename AVDExport
    
    #>
    [CmdletBinding(DefaultParameterSetName = 'FileExport')]
    param (
        [parameter(Mandatory, ParameterSetName = 'FileExport')]
        [parameter(Mandatory, ParameterSetName = 'Console')]
        [ValidateNotNullOrEmpty()]
        [string]$HostpoolName,

        [parameter(Mandatory, ParameterSetName = 'FileExport')]
        [parameter(Mandatory, ParameterSetName = 'Console')]
        [ValidateNotNullOrEmpty()]
        [string]$ResourceGroupName,

        [parameter(Mandatory, ParameterSetName = 'FileExport')]
        [ValidateNotNullOrEmpty()]
        [string]$FileName,

        [parameter(Mandatory, ParameterSetName = 'FileExport')]
        [ValidateSet("JSON", "HTML", "XLSX")]
        [array]$Format,

        [parameter(Mandatory, ParameterSetName = 'Console')]
        [switch]$Console
    )

    Begin {
        Write-Verbose "Start searching"
        AuthenticationCheck
    }
    Process {
        $Parameters = @{
            HostpoolName      = $HostpoolName 
            ResourceGroupName = $ResourceGroupName 
        }
        $Content = [ordered]@{
            Hostpool     = Get-AvdHostPool @Parameters | Select-Object name, @{N="Description";E={$_.properties.description}}, @{N="startVMOnConnect";E={$_.properties.startVMOnConnect}}, @{N="maxSessionLimit";E={$_.properties.maxSessionLimit}}, @{N="hostpoolType";E={$_.properties.hostpoolType}}
            SessionHosts = Get-AvdImageVersionStatus @Parameters | Select-Object imageInfo.isLatestVersion, Name,  imageInfo.latestVersion , imageInfo. currentImageVersion,  imageInfo.imageName,  imageInfo.galleryName
            Network      = Get-AvdNetworkInfo @Parameters | Select-Object @{N="vmName";E={$_.Name}}, @{N="vmResourceGroup";E={$_.ResourceGroup}}, @{N="privateIPAddress";E={$_.networkcardinfo.privateIPAddress}}, @{N="nicId";E={$_.networkcardinfo.nicId}}, @{N="subnetNsgId";E={$_.SubnetInfo.networksecurityGroup}}, @{N="subnetId";E={$_.networkcardinfo.subnet.id}}
        }
        switch ($PsCmdlet.ParameterSetName) {
            Console { 
                return $Content
            }
            Default {
                $Format | ForEach-Object { Generate-Output -Format $_ -Content $Content -FileName $FileName -Hostpoolname $HostpoolName }
            }
        }
        
    }
}