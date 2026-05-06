# Links
# https://blog.graa.dev/NVIDIA-LatestGuestDriver
# https://blog.graa.dev/PowerShell-NVIDIASoftware

$ErrorActionPreference = "SilentlyContinue"
# Enable TLS 1.2
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# Module name Nvdia VGU
$ModuleName = "PSNVIDIA.NLS"
# Basisnaam zonder expliciete versies
$baseName = "NVIDIA-GRID-vSphere"

# Check if module is already installed
if (Get-Module -ListAvailable -Name $ModuleName) {
    Write-Host "$ModuleName is already installed."
}
else {
    Write-Host "$ModuleName is not installed. Installing..."

    # Ensure NuGet provider is installed
    if (-not (Get-PackageProvider -Name NuGet -ErrorAction SilentlyContinue)) {
        Install-PackageProvider -Name NuGet -Force -Scope CurrentUser
    }

    # Trust PSGallery if not already trusted
    if ((Get-PSRepository -Name PSGallery).InstallationPolicy -ne "Trusted") {
        Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
    }

    # Install the module
    Install-Module -Name $ModuleName -Repository PSGallery -Force -Scope CurrentUser

    Write-Host "$ModuleName installation completed."
}


# Create Folder
$downloadfolder = "vGPU"
$checkdir = Test-Path -Path $packer_folder\$downloadfolder 
if ($checkdir -eq $false){
    Write-Host "Creating '$packer_folder\$downloadfolder' folder" -ForegroundColor Yellow
    New-Item -Path $packer_folder\$downloadfolder -ItemType Directory | Out-Null
} else {
    Write-Host "Folder '$packer_folder\$downloadfolder' already exists." -ForegroundColor Green
}


# Nvidia VGPU API KEY

$apiKey = Read-Host -AsSecureString -Prompt 'NVIDIA License System API Key'
$latest = Get-NVLSCompatibleDownload -ApiKey $apikey -Product vGPU -DriverType Host -Latest
$software = Find-NVLSDownload -ApiKey $apikey -ProductName 'vGPU' -PlatformName 'VMware vSphere' -DownloadVersion $latest.compatibleDownloads.releaseVersion
$software.downloads

$urls = $software.downloads | Select-Object -ExpandProperty url
foreach ($url in $urls) {
    $fileName = Split-Path $url -Leaf
    $fileNameSoftware = $url.Split('/')[-1].Split('~')[0]
    $baseName = [System.IO.Path]::GetFileNameWithoutExtension($filename)
    Invoke-WebRequest -Uri $url -OutFile $downloadfolder\$fileNameSoftware
    Expand-Archive  $downloadfolder\$fileNameSoftware -DestinationPath $packer_folder\$downloadfolder\$baseName\ -force
    Remove-Item "$packer_folder\$downloadfolder\$fileNameSoftware" -Recurse
}

# Which Version
$esxiVersion = Read-Host "Welke ESXi versie draai je? (vSphere 8 of 9)"
switch ($esxiVersion) {
    "8" {
        $nvidiaPackage = "$baseName-8.0"
        $gpufolder = Get-ChildItem -Path "$packer_folder\$downloadfolder" |  Where-Object { $_.Name -match "^$baseName-8\.0" }
    }
    "9" {
        $nvidiaPackage = "$baseName-9.0"
        $gpufolder = Get-ChildItem -Path "$packer_folder\$downloadfolder" |  Where-Object { $_.Name -match "^$baseName-9\.0" }
    }
    default {
        Write-Host "Ongeldige invoer. Kies alleen 8 of 9." -ForegroundColor Red
        exit 1
    }
}
Write-Host "Geselecteerd NVIDIA GRID package:  $nvidiaPackage" -ForegroundColor Cyan

$gpudrivers = Get-ChildItem -Path ".\$gpufolder\Guest_Drivers"

 # If served via HTTP, renaming to something deterministic would make downloading easier
Copy-Item "$gpudrivers\NVIDIA*.deb" "$packer_folder\$downloadfolder\Guest_Drivers\Nvidia_GPU_Linux_Driver_Latest.deb"
Copy-Item "$gpudrivers\NVIDIA*.rpm" "$packer_folder\$downloadfolder\Guest_Drivers\Nvidia_GPU_Linux_Driver_Latest.rpm"
Copy-Item "$gpudrivers\NVIDIA*.run" "$packer_folder\$downloadfolder\Guest_Drivers\Nvidia_GPU_Linux_Driver_Latest.run"
Copy-Item "$gpudrivers\*grid*.exe" "$packer_folder\$downloadfolder\Guest_Drivers\Nvidia_GPU_Windows_Driver_Latest.exe"

Write-Host -NoNewLine 'Press any key to continue...';
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');
