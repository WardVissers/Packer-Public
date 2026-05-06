# $ErrorActionPreference = "SilentlyContinue"
# Enable TLS 1.2
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# OpenSSL paths
$opensslFolder = "C:\Program Files\OpenSSL-Win64\bin"
$opensslExe = "$opensslFolder\openssl.exe"
$downloadFolder = "OpenSSL_Download"


# Create Folder
$checkdir = Test-Path -Path $packer_folder\$downloadfolder 
if ($checkdir -eq $false){
    Write-Host "Creating '$packer_folder\$downloadfolder' folder" -ForegroundColor Yellow
    New-Item -Path $packer_folder\$downloadfolder -ItemType Directory | Out-Null
} else {
    Write-Host "Folder '$packer_folder\$downloadfolder' already exists." -ForegroundColor Green
}

# Check local version
if (Test-Path $opensslExe) {
    $localVersionOutput = & $opensslExe version
    $local_version = $localVersionOutput -split "14 Apr", 2
    $local_version = $local_version[0].Trim()
    $local_version = $local_version.split("OpenSSL ")[1]

    Write-Host "Local OpenSSL version: $local_Version" -ForegroundColor Cyan
}
else {
    Write-Host "OpenSSL not found at $opensslExe" -ForegroundColor Red
    exit
}

#get version by looking at github
$online_version = (Invoke-RestMethod -Uri "https://api.github.com/repos/openssl/openssl/releases/latest").tag_name
$online_version = $online_version.split("openssl-")[1]

if (($online_version -gt  $local_version) -or ($online_version -eq  $local_version)) 
{
Write-Host "OpenSSL is up to date $online_version" -ForegroundColor Green
}
Else {
$online_version = $online_version.replace(".", "_")

write-host "Download newest version? local version $($local_version) online version $($online_version)"

#download new version
Write-Host "Trying to download version $($online_version)" -ForegroundColor Green

# Download latest installer EXE
$downloadUrl = "https://slproweb.com/download/Win64OpenSSL_Light-$($online_Version).exe"
$downloadFile = "$downloadFolder\Win64OpenSSL_Light-$($online_Version).exe"

Write-Host "Downloading OpenSSL $onlineVersion..." -ForegroundColor Green

Invoke-WebRequest -Uri $downloadUrl -OutFile $downloadFile

Write-Host "Download complete: $downloadFile" -ForegroundColor Green

# Start installer silently
Write-Host "Installing OpenSSL..." -ForegroundColor Green

Start-Process -FilePath $downloadFile -ArgumentList "/silent" -Wait

Write-Host "OpenSSL update completed." -ForegroundColor Green
}
# Write-Host -NoNewLine 'Press any key to continue...';
# $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');