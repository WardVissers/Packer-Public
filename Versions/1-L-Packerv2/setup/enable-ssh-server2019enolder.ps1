# Execute it with elevated permissions
# Description: 
# This script install automatically the open-ssh feature and enable it

# enable tls1.2 for downloads
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# creating openssh folder and download the zip
$open_ssl_location="c:\openssh-install"
new-item -path $open_ssl_location -ItemType Directory
Set-Location $open_ssl_location

# GitHub API endpoint for latest Win32-OpenSSH release
$releaseUrl = "https://api.github.com/repos/PowerShell/Win32-OpenSSH/releases/latest"

# Get release metadata
$release = Invoke-RestMethod -Uri $releaseUrl -UseBasicParsing

# Find the ZIP asset (64-bit)
$zipAsset = $release.assets | Where-Object { $_.name -match "OpenSSH-Win64.zip" }

if (-not $zipAsset) {
    Write-Host "No ZIP file found in the latest release." -ForegroundColor Red
    exit
}

# Download path
$downloadPath = ".\$($zipAsset.name)"

Write-Host "Downloading latest OpenSSH ZIP: $($zipAsset.name)"
Invoke-WebRequest -Uri $zipAsset.browser_download_url -OutFile $downloadPath

Expand-Archive .\$($zipAsset.name) -DestinationPath .\
Set-Location "$open_ssl_location\OpenSSH-Win64\"

# required for enable the service
setx PATH "$env:path;c:\openssh-install\OpenSSH-Win64\" -m

# required for install the service
powershell.exe -ExecutionPolicy Bypass -File install-sshd.ps1

# required for execute remote connections
New-NetFirewallRule -Name sshd -DisplayName 'OpenSSH Server (sshd)' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22

# Controleren of de service draait
if ($service.Status -ne 'Running') {
    Write-Host "SSHD service does not run! Wil be started" -ForegroundColor Yellow
    Start-Service -Name sshd
} else {
    Write-Host "SSHD service run." -ForegroundColor Green
}

Set-Service -Name sshd -StartupType 'Automatic'
