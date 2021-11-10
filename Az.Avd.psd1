#
# Module manifest for module 'Az.Avd'
#
# Generated by: sanderrozemuller
#
# Generated on: 27-02-2021
#

@{

    # Script module or binary module file associated with this manifest.
    RootModule             = 'Az.Avd.psm1'

    # Version number of this module.
    ModuleVersion          = '2.0.0'

    # Supported PSEditions
    CompatiblePSEditions   = 'Core', 'Desktop'

    # ID used to uniquely identify this module
    GUID                   = 'fdf37ff7-689a-46de-82d4-66228b92dae4'

    # Author of this module
    Author                 = 'Sander Rozemuller'

    # Company or vendor of this module
    CompanyName            = 'Rozemuller.com'

    # Copyright statement for this module
    Copyright              = '(c) All rights reserved.'

    # Description of the functionality provided by this module
    Description            = 'For managing and automate Azure Virtual Desktop environments. This module can also be used for housekeeping and manageing all the AVD related Azure resources.'

    # Minimum version of the PowerShell engine required by this module
    PowerShellVersion      = '5.1'

    # Name of the PowerShell host required by this module
    # PowerShellHostName = ''

    # Minimum version of the PowerShell host required by this module
    # PowerShellHostVersion = ''

    # Minimum version of Microsoft .NET Framework required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
    DotNetFrameworkVersion = '4.7.2'

    # Minimum version of the common language runtime (CLR) required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
    # ClrVersion = ''

    # Processor architecture (None, X86, Amd64) required by this module
    # ProcessorArchitecture = ''

    # Modules that must be imported into the global environment prior to importing this module
    #RequiredModules        = @(

    #)

    # Assemblies that must be loaded prior to importing this module
    # RequiredAssemblies = @()

    # Script files (.ps1) that are run in the caller's environment prior to importing this module.
    # ScriptsToProcess = @()

    # Type files (.ps1xml) to be loaded when importing this module
    # TypesToProcess = @()

    # Format files (.ps1xml) to be loaded when importing this module
    # FormatsToProcess = @()

    # Modules to import as nested modules of the module specified in RootModule/ModuleToProcess
    # NestedModules = @()

    # Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
    FunctionsToExport      = @(
        'Add-AvdApplicationGroupPermissions',
        'Copy-AvdApplicationGroupPermissions',
        'Enable-AvdDiagnostics',
        'Enable-AvdStartVmOnConnect',    
        'Export-AvdConfig',
        'Get-AvdApplicationGroup',  
        'Get-AvdHostPool',
        'Get-AvdImageVersionStatus',
        'Get-AvdLatestSessionHost',
        'Get-AvdNetworkInfo',
        'Get-AvdSessionHost'
        'Get-AvdSessionHostResources',
        'Get-AvdWorkspace',
        'Move-AvdSessionHost',
        'New-AvdAutoScaleRole',
        'New-AvdApplicationGroup',
        'New-AvdHostpool',
        'New-AvdScalingPlan',
        'New-AvdVmTemplate',
        'New-AvdWorkspace',
        'Remove-AvdSessionHost',
        'Update-AvdDesktopApplication',
        'Update-AvdDiagnostics',
        'Update-AvdHostpool',
        'Update-AvdRegistrationToken',
        'Update-AvdSessionhost',
        'Update-AvdSessionhostDrainMode',
        'Update-AvdWorkspace'
    )

    # Cmdlets to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no cmdlets to export.
    CmdletsToExport        = @()

    # Variables to export from this module
    VariablesToExport      = '*'

    # Aliases to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no aliases to export.
    AliasesToExport        = @()

    # DSC resources to export from this module
    # DscResourcesToExport = @()

    # List of all modules packaged with this module
    # ModuleList = @()

    # List of all files packaged with this module
    # FileList = @()

    # Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
    PrivateData            = @{
        PSData = @{

            # Tags applied to this module. These help with module discovery in online galleries.
            Tags       = 'Azure', 'ResourceManager', 'ARM', 'PSModule', 'AzureVirtualDesktop', 'WindowsVirtualDesktop', 'DesktopVirtualization'

            # A URL to the license for this module.
            LicenseUri = 'https://github.com/srozemuller/AzWvd/blob/main/LICENSE'

            # A URL to the main website for this project.
            ProjectUri = 'https://github.com/srozemuller/Windows-Virtual-Desktop/tree/master/PowerShell-Modules/WVD-Automation'

            # A URL to an icon representing this module.
            IconUri    = 'https://github.com/srozemuller/AzWvd/blob/main/Private/wvd-logo.png'

            # ReleaseNotes of this module
            # ReleaseNotes = ''

            # Prerelease string of this module
            # Prerelease = ''

            # Flag to indicate whether the module requires explicit user acceptance for install/update/save
            # RequireLicenseAcceptance = $false

            # External dependent modules of this module
            # ExternalModuleDependencies = @()

        } # End of PSData hashtable

    } # End of PrivateData hashtable

    # HelpInfo URI of this module
    # HelpInfoURI = ''

    # Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
    # DefaultCommandPrefix = ''

}
