# $ErrorActionPreference = "SilentlyContinue"
# Enable TLS 1.2
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# Create Folder
$downloadfolder = "PackerDownload"
$checkdir = Test-Path -Path $packer_folder\$downloadfolder 
if ($checkdir -eq $false){
    Write-Host "Creating '$packer_folder\$downloadfolder' folder" -ForegroundColor Yellow
    New-Item -Path $packer_folder\$downloadfolder -ItemType Directory | Out-Null
} else {
    Write-Host "Folder '$packer_folder\$downloadfolder' already exists." -ForegroundColor Green
}

#get version by looking at github
$online_version = (Invoke-RestMethod -Uri "https://api.github.com/repos/hashicorp/packer/releases/latest").tag_name -replace ("v","")
$local_version = (.\packer.exe -v).replace("Packer v","")

if (($online_version -gt  $local_version) -or ($online_version -eq  $local_version)) 
{
Write-Host "Packer is up to date $online_version"
}
Else {
write-host "Download newest version? local version $($local_version) online version $($online_version)"

Rename-Item -Path "$($packer_folder)\packer.exe" -NewName "$($packer_folder)\old_packer_$($local_version).exe"
# Download new version
Write-Host "Trying to download version $($online_version)" -ForegroundColor Green
Invoke-WebRequest -Uri "https://releases.hashicorp.com/packer/$($online_version)/packer_$($online_version)_windows_amd64.zip" -OutFile "$($packer_folder)\$downloadfolder\packer_$($online_version)_windows_amd64.zip"

# Unzip Packer
   
Expand-Archive "$($packer_folder)\$downloadfolder\packer_$($online_version)_windows_amd64.zip" -DestinationPath $packer_folder\ -force
# Remove-Item "$packer_folder\$downloadfolder" -Recurse
Write-Host "done" -ForegroundColor Green

# Download Packer plugins
$plugins = .\packer.exe plugins installed
[string]$installed = $plugins.ForEach({$_ -match("qemu") -or $_ -match("vsphere") -or $_ -match("windows-update")})
if ($installed.contains("False")) {
    Write-Host "Installing plugins" -ForegroundColor Yellow
    .\packer.exe init "$($packer_folder)\Config_plugins\basis.pkr.hcl"
} else {
    Write-Host "plugins are installed" -ForegroundColor Green
}

}

# Write-Host -NoNewLine 'Press any key to continue...';
# $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');