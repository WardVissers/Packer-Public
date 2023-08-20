### Enable WinRM
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Get-WindowsCapability -Name "ServerCore.AppCompatibility~~~~0.0.1.0" -Online
Start-Sleep 5
Add-WindowsCapability -Name "ServerCore.AppCompatibility~~~~0.0.1.0" -Online -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
if($?)
{
   "features on Demand installed succeeded"
    
   }
else
{
   "features on Demand installed failed run again"
    Add-WindowsCapability -Name "ServerCore.AppCompatibility~~~~0.0.1.0" -Online
}

