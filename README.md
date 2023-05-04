# Az.Avd PowerShell module
This module will help you managing an Azure Virtual Desktop environments and all related Azure resources.

##### General module information
<a href="https://github.com/srozemuller/azavd" target="_blank"><img src="https://img.shields.io/github/v/release/srozemuller/azavd?label=latest-release&style=flat-square" alt="CurrentVersion"></a> <a href="https://github.com/srozemuller/AzAvd/issues" target="_blank"><img src="https://img.shields.io/github/issues/srozemuller/azavd?style=flat-square" alt="Issues"></a> </a><a href="https://github.com/srozemuller/AzAvd/tree/beta" target="_blank"><img src="https://img.shields.io/maintenance/yes/2022?style=flat-square" alt="Beta"></a> </a><a href="https://github.com/srozemuller/AzAvd/tree/beta" target="_blank"><img src="https://img.shields.io/github/license/srozemuller/azavd?style=flat-square" alt="Beta"></a>
##### PowerShell Gallery information
<a href="https://www.powershellgallery.com/packages/Az.Avd" target="_blank"><img src="https://img.shields.io/powershellgallery/v/az.avd?style=flat-square" alt="Main"></a> <a href="https://www.powershellgallery.com/packages/Az.Avd" target="_blank"><img src="https://img.shields.io/powershellgallery/dt/az.avd?style=flat-square" alt="Downloads"></a>

##### Update information
<a href="https://github.com/srozemuller/azavd"  target="_blank"><img src="https://img.shields.io/github/last-commit/srozemuller/azavd?label=main%20update&style=flat-square" alt="LastCommit"></a> <a href="https://github.com/srozemuller/AzAvd/tree/beta" target="_blank"><img src="https://img.shields.io/github/last-commit/srozemuller/azavd/beta?label=beta%20update&style=flat-square" alt="Beta">


## Install module

To install the module in PowerShell use the command below
```
Install-Module Az.Avd
Import-Module Az.Avd
```

## Connect to AVD
To connect to AVD use one of the commands below:
For an interactive login the device_code flow is used.

```
$TenantId = "000000-00000"
$SubscriptionId = "000000-00000"
Connect-Avd -DeviceCode -TenantID $TenantId -SubscriptionId $SubscriptionId
```

Or using a service principal.
```
$TenantId = "000000-00000"
Connect-Avd -ClientID xxxx -ClientSecret "xxxxx" -TenantID $Tenantid -SubscriptionId $SubscriptionId
```

To change the subscription context use the command below:
```
$SubscriptionId = "000000-00000"
Set-AvdContext -SubscriptionId $SubscriptionId
```

The module consists of the following commands:

## Documentation
The documentation is stored at this location: https://github.com/srozemuller/AzAvd/tree/main/Docs

For practical examples check my blog: https://rozemuller.com/?s=az.avd
