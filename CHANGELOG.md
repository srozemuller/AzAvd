# Changelog
All notable changes to this Az.Avd PowerShell will be documented in this file. 

## [1.2.5] - 2021-10-02

### :exclamation: BREAKING CHANGES!

- Get-AvdHostpoolInfo is changed into Get-AvdHostpool [6ab2683] (https://github.com/srozemuller/AzAvd/commit/6ab2683cfaa1480369a705df4cb67e31ae11b2c3)
- Create-AvdVmTemplate is changed into New-AvdVmTemplate [eae7dfa] (https://github.com/srozemuller/AzAvd/commit/eae7dfa195537ee94c53ccd23a6fcaa10ac06bb8)

### Changes
- Synopis changed at several commands.
- Several help and examples updated.
- Removed last legacy Az.DesktopVirtualization PowerShell module dependencies
- New-AvdHostpool accepting VM template parameter
- The following commands now accepting a resourceId:
* Get-AvdApplicationGroup
* Get-AvdWorkspace
* Get-AvdHostpool
* Update-AvdWorkspace


[Bug-Fix] New-AvdHostpool now accepting Persistant loadBalancerType
[Bug-Fix] Get-AvdSessionHost output null when requesting a single session host

### Added Commands
- Add-AvdApplicationGroupPermissions (Adds permissions to an Azure Virtual Desktop Applicationgroup)
- Copy-AvdApplicationGroupPermissions (Copies application group assignments to another one)
- Get-AvdWorkspace (Gets a new Azure Virtual Desktop workspace)
- New-AvdWorkspace (Creates a new Azure Virtual Desktop workspace)
- Update-AvdDesktopApplication (Updates the Virtual Desktop ApplicationGroup desktop application)
- Get-AvdApplicationGroup (Get AVD applicationgroup information INCLUDING the assigned permissions)
- Update-AvdWorkspace (Updates a new Azure Virtual Desktop workspace)
- Update-AvdDesktopApplication (Updates the default SessionDesktop application, for example the displayname)


## [1.2.4] - 2021-09-17

### Changes
- [Update] Removed old WVD commands, examples and synopsis [66548f1](https://github.com/srozemuller/AzAvd/commit/66548f19e0edffb94e546b6d5759ae1fbeb1df64)

### Added Commands
- Create-AvdVmTemplate (Creates a session host VM template in a hostpool)
- Update-AvdSessionhost (For updating sessions host, for example drain mode)

## [1.2.3] - 2021-07-31

### Changes
- [Bug fix] Multiple DELETE method in remove-avdsessionhosts [973940f](https://github.com/srozemuller/AzAvd/commit/973940fddff1da76cc893beeca0420552b0a920a)

## [1.2.2] - 2021-07-30
 
### Added Commands

- Update-AvdHostpool (Used to update the AVD Hostpool settings, like RDP properties)
- Move-AvdSessionHost (Moving session hosts to an other host pool)

### Changes
- Fixed initial number to 0 if no sessionhosts. [318e445](https://github.com/srozemuller/AzAvd/commit/318e4454b0674976a17d899a5b3cb0f2f0842849)
- Verbose logging output changed in several commands.
- Changed the Update-AvdRegistrationGoken code to REST API [97dad92](https://github.com/srozemuller/AzAvd/commit/97dad92c015147f7c008d971c0a8810ad924884c)

## [1.2.1] - 2021-07-08

### Added Commands

- Get-AvdHostPoolInfo
- Get-AvdNetworkInfo
- Get-AvdSessionHost (Get the session hosts from a hostpool)

### Changes

- Update-AvdRegistrationToken
- Update-AvdSessionhostDrainMode


## [1.2.0] - 2021-06-30
### Added Commands
- Remove-AvdSessionHost (For removing sesssion hosts from the hostpool)
- Update-AvdDiagnostics (Configuring hostpool diagnostics to log analytics)


### Changes
- Changed the name from Az.Wvd -> Az.Avd [952d2c4](https://github.com/srozemuller/AzAvd/commit/952d2c4fd82ed931ec1770b440807fede8ac342b)
- Added numonly switch parameter in Get-AvdLatestSessionHost command [50eca1d](https://github.com/srozemuller/AzAvd/commit/b8d047d28a605a8f45ea710ebdcf02500cd0cc2d)
- 

## [1.0.1] - 2021-05-17

### Added Commands
No commands added

### Changes
- [Bug fix] In export AVD environment, PSscriptRoot location added. [ff2d60b](https://github.com/srozemuller/AzAvd/commit/59bdc8964ec0de79d76b2042ee22962876a8e4f9)
- [Bug fix] Required module typo in WVDImageVersionStatus [5fe2751](https://github.com/srozemuller/AzAvd/commit/5b6b7c6d48bf72a26a4832382487cb91288246fa)

## [1.0.0] - 2021-04-28
- Initial Version
