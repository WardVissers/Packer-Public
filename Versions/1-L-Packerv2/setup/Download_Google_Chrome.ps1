# Enable TLS 1.2
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$ErrorActionPreference = "Stop"

$InstallerPath = "C:\install\GoogleChromeEnterprise64.msi"

Write-Host "Downloading Google Chrome Enterprise Offline Installer..."

$url = "https://dl.google.com/chrome/install/GoogleChromeStandaloneEnterprise64.msi"
$webclient = New-object -TypeName System.Net.WebClient
$webclient.DownloadFile($url, $InstallerPath)

Write-Host "Download completed. Installing Chrome..."

Start-Process "msiexec.exe" `
    -ArgumentList "/i `"$InstallerPath`" /qn /norestart" `
    -Wait

Write-Host "Google Chrome Enterprise installed successfully."

