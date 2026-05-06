# Enable TLS 1.2
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$language = "en-US"



# Doelpad
$InstallerPath = "C:\install\Firefox_latest.exe"

Write-Host "Downloaden van de laatste versie van Firefox..." -ForegroundColor Cyan
# Officiële Mozilla download-URL (altijd latest)
$url = "https://download.mozilla.org/?product=firefox-latest&os=win64&lang=$language"

# Download File
$webclient = New-object -TypeName System.Net.WebClient
$webclient.DownloadFile($url, $InstallerPath)

Write-Host "Download completed. Installing Firefox..."

Start-Process $InstallerPath -ArgumentList "/S" -Wait

Write-Host "Modzilla Firefox installed successfully."