    Set-ItemProperty -Path Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\RDInfraAgent -Name RegistrationToken -Value "asffsadf"
    Set-ItemProperty -Path Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\RDInfraAgent -Name IsRegistered -Value 0 
    Restart-Service -Name RDAgentBootLoader
