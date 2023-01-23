function Repair-AvdSessionHost {
    <#
    .SYNOPSIS
    Repairing sessionhosts in an Azure Virtual Desktop hostpool.
    .DESCRIPTION
    The function will search for sessionhosts and will repair them in the Azure Virtual Desktop hostpool. Usefull when a sessionhost is in a bad state.
    .PARAMETER HostpoolName
    Enter the  AVD Hostpool name
    .PARAMETER ResourceGroupName
    Enter the  Hostpool resourcegroup name
    .PARAMETER SessionHostName
    Enter the sessionhosts name avd-hostpool/avd-host-1.avd.domain
    .PARAMETER SessionHostName
    Enter the sessionhosts name avd-hostpool/avd-host-1.avd.domain
    .EXAMPLE
    Move-AvdSessionHost -FromHostpoolName avd-hostpool -FromResourceGroupName rg-avd-01 -ToHostpoolName avd-hostpool-02 -ToResourceGroupName rg-avd-02 -SessionHostName avd-host-1.avd.domain
    #>
    [CmdletBinding(DefaultParameterSetName = 'All')]
    param
    (
        [parameter(Mandatory, ParameterSetName = 'SingleObject')]
        [parameter(Mandatory, ParameterSetName = 'All')]
        [string]$HostpoolName,
    
        [parameter(Mandatory, ParameterSetName = 'SingleObject')]
        [parameter(Mandatory, ParameterSetName = 'All')]
        [string]$ResourceGroupName,

        [parameter(Mandatory, ParameterSetName = 'SingleObject')]
        [string]$SessionHostName,

        [parameter(Mandatory, ParameterSetName = 'Id')]
        [object]$Id
    )
    Begin {
        Write-Verbose "Start moving session hosts"
        AuthenticationCheck
        $Token = GetAuthToken -resource $Script:AzureApiUrl
    }
    Process {
        switch ($PsCmdlet.ParameterSetName) {
            All {
                try {
                    Write-Verbose "Getting all sessionhosts from hostpool $HostpoolName"
                    $sessionHosts = Get-AvdSessionHost -HostpoolName $HostpoolName -ResourceGroupName $ResourceGroupName
                }
                catch {
                    Write-Error "Something went wrong, $_"
                }
            }
            SingleObject {
                if ($SessionHostName.Contains($HostpoolName)) { 
                    Write-Verbose "SessionHostName contains hostpool name, removing it"
                    $SessionHostName = $SessionHostName.Replace($HostpoolName + "/", "")
                }
                $sessionHosts = Get-AvdSessionHost -HostpoolName $HostpoolName -ResourceGroupName $ResourceGroupName -Name $SessionHostName
            }
            ResourceID {
                try {
                    $sessionHosts = Get-AvdSessionHost -Id $Id
                    $HostpoolName = Select-String -Pattern '(?<=hostpools\/)(.*)(?=\/sessionhosts)' -InputObject $Id -AllMatches | Select-Object -ExpandProperty Matches | Select-Object -ExpandProperty Value
                    $ResourceGroupName = Select-String -Pattern '(?<=resourcegroups\/)(.*)(?=\/providers)' -InputObject $Id -AllMatches | Select-Object -ExpandProperty Matches | Select-Object -ExpandProperty Value
                }
                catch {
                    Write-Error "Please provide the Get-AvdSessionHost output"
                }
            }
        }
        Write-Verbose "Found $($sessionHosts.Count) sessionhosts in $HostpoolName"
        if ($sessionHosts) {          
            $sessionHosts | ForEach-Object {
                Write-Verbose "Repairing sessionhost $($_.name) in $HostPoolName"
                try {
                    $sessionhostDeleteUrl = "{0}{1}?api-version={2}&force=true" -f $Script:AzureApiUrl , $_.id, $script:sessionHostApiVersion
                    $deleteParameters = @{
                        uri     = $sessionhostDeleteUrl
                        Headers = $token
                        Method  = "DELETE"
                    }
                    Invoke-RestMethod @deleteParameters
                    $vmResourceId = $_.properties.resourceId
                    Write-Verbose "Requesting new token in hostpool $HostpoolName"
                    $avdHostpoolToken = Update-AvdRegistrationToken -HostpoolName $HostpoolName -ResourceGroupName $ResourceGroupName
                    # Script part
                    $script = [System.Collections.ArrayList]@()
                    $script.Add('Set-ItemProperty -Path Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\RDInfraAgent -Name RegistrationToken -Value ' + $($avdHostpoolToken.properties.registrationInfo.token) + '') | Out-Null
                    $script.Add('Set-ItemProperty -Path Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\RDInfraAgent -Name IsRegistered -Value 0') | Out-Null
                    $script.Add('Restart-Service -Name RDAgentBootLoader') | Out-Null
                    $moveBody = @{
                        commandId = "RunPowerShellScript"
                        script    = $script
                    }   
                    $runCommandUrl = "{0}{1}/runCommand?api-version={2}" -f $Script:AzureApiUrl, $vmResourceId, $script:vmApiVersion
                    $parameters = @{
                        URI     = $runCommandUrl 
                        Method  = "POST"
                        Body    = $moveBody | ConvertTo-Json
                        Headers = $token
                    }
                    Invoke-RestMethod @parameters
                }
                catch {
                    Throw $_.Exception.Message
                }
            }
        }
        else {
            Write-Error "No sessionhosts found in $HostpoolName, $_"
        }      
    }
}