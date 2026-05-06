# Execute it with elevated permissions
# Description: 
# This script install automatically the open-ssh feature and enable it

# enable tls1.2 for downloads
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# creating openssh folder and download the zip
cd C:\openssh-install\OpenSSH-Win64

# required for install the service
powershell.exe -ExecutionPolicy Bypass -File uninstall-sshd.ps1

# required for execute remote connections
Disable-NetFirewallRule -DisplayName 'OpenSSH Server (sshd)' 

