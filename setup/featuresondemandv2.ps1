### Enable WinRM
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
# Add-WindowsCapability -Online -Name "ServerCore.AppCompatibility~~~~0.0.1.0"
Get-WindowsCapability -Name "ServerCore.AppCompatibility~~~~0.0.1.0" -Online
Start-Sleep 10
Get-WindowsCapability -Name "ServerCore.AppCompatibility~~~~0.0.1.0" -Online | Add-WindowsCapability  -Name "ServerCore.AppCompatibility~~~~0.0.1.0" -Online

