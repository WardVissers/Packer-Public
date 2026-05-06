<#

.FUNCTIONALITY
Enable WinRM for Packer.IO integration

.SYNOPSIS
Change log

July 25, 2020
-Initial version
-Minor edit to first part which produced "access denied"


Nov 29, 2021
-Added netsh winsock reset catalog to end

Nov 30, 2021
-Line 83 disabled to reduce false errors: Set-NetConnectionProfile -InterfaceAlias Ethernet -NetworkCategory Private

.DESCRIPTION
Author wardvissers@gmail.com

.EXAMPLE
./Enable-WinRM.ps1

.NOTES

.Link
To be added
#>



### Enable WinRM

Get-NetConnectionProfile  | Select InterfaceAlias | Set-NetConnectionProfile -NetworkCategory Private

Enable-PSRemoting -Force
winrm quickconfig -q
winrm quickconfig -transport:http
winrm set winrm/config '@{MaxTimeoutms="1800000"}'
winrm set winrm/config/winrs '@{MaxMemoryPerShellMB="800"}'
winrm set winrm/config/service '@{AllowUnencrypted="true"}'
winrm set winrm/config/service/auth '@{Basic="true"}'
winrm set winrm/config/client/auth '@{Basic="true"}'
winrm set winrm/config/listener?Address=*+Transport=HTTP '@{Port="5985"}'
netsh advfirewall firewall set rule group="Windows Remote Administration" new enable=yes
netsh advfirewall firewall set rule name="Windows Remote Management (HTTP-In)" new enable=yes action=allow
netsh winsock reset catalog

Set-Service winrm -startuptype "auto"

Restart-Service winrm
