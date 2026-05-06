# https://github.com/MicrosoftDocs/windowsserverdocs/issues/2074
# Set network connections profile to Private mode.
Write-Output 'Setting the network connection profiles to Private...'
do {
    $connectionProfile = Get-NetConnectionProfile
    Start-Sleep -Seconds 10
} while ($connectionProfile.Name -eq 'Identifying...')
Set-NetConnectionProfile -Name $connectionProfile.Name -NetworkCategory Private
 

# Check of de SSHD service bestaat
$service = Get-Service -Name sshd -ErrorAction SilentlyContinue

if (-not $service) {
    Write-Host "OpenSSH Server (sshd) is not installed."
    Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
 }

# Controleren of de service draait
if ($service.Status -ne 'Running') {
    Write-Host "SSHD service does not run! Wil be started" -ForegroundColor Yellow
    Start-Service -Name sshd
} else {
    Write-Host "SSHD service run." -ForegroundColor Green
}

Set-Service -Name sshd -StartupType 'Automatic'

 
 
# Confirm the Firewall rule is configured. It should be created automatically by setup. Run the following to verify
if (!(Get-NetFirewallRule -Name "OpenSSH SSH Server (sshd)" -ErrorAction SilentlyContinue | Select-Object Name, Enabled)) {
  Write-Output "Firewall Rule 'OpenSSH SSH Server (sshd)' does not exist, creating it..."
  New-NetFirewallRule -Name 'OpenSSH SSH Server (sshd)' -DisplayName 'OpenSSH Server (sshd)' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22 -Profile Any
} else {
  Write-Output "Firewall rule 'OpenSSH SSH Server (sshd)' has been created and exists."
  Set-NetFirewallRule -DisplayName "OpenSSH SSH Server (sshd)" -Profile Any -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22
}
