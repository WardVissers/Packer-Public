﻿# Initiele versie
# Graag versie nummer ophogen en melden wat is aangepast.
$source = "C:\TEMP"
$dest = "C:\Windows"
$logFile = "C:\TEMP\uitrol.log"

CLEAR

Out-File -FilePath $logFile -append -InputObject  ===========================================================
Out-File -FilePath $logFile -append -InputObject "BGinfo Installeren"
Out-File -FilePath $logFile -append -InputObject  ===========================================================
try {
    New-Item -ItemType Directory -Path "$dest\BgInfo" -Force
    # Get OS information
    $osInfo = Get-CimInstance -ClassName Win32_OperatingSystem

    # Extract version and caption
    $caption = $osInfo.Caption
    $version = $osInfo.Version
 
    Switch -Regex ($osInfo.Caption) {
        "Windows Server 2016" {Write-Host "Server 2016 detected"; $switch_os = "Server 2016"}
        "Windows Server 2019" {Write-Host "Server 2019 detected"; $switch_os = "Server 2019"}
        "Windows Server 2022" {Write-Host "Server 2022 detected"; $switch_os = "Server 2022"}
        "Windows Server 2025" {Write-Host "Server 2025 detected"; $switch_os = "Server 2025"}
        default {Write-Host "no supported os found for BGinfo"}
    }

    if ($switch_os){
        Out-File -FilePath $logFile -append -InputObject "This system is running $($osInfo.Caption)"
        Copy-Item -Path "$source\$switch_os\*" -Destination "$dest\BgInfo"
        Copy-Item -Path "$source\BgInfo\*" -Destination "$dest\BgInfo"
        Copy-Item -Path "$source\BgInfo\BgInfo.lnk" -Destination "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp\"
    } else {
        Out-File -FilePath $logFile -append -InputObject "This system is not running an supported os- current os:$($osInfo.Caption) "
    }
 
} catch {
    Out-File -FilePath $logFile -append -InputObject "ERROR: Fout bij kopieeren of uitvoeren bginfo"
    Out-File -FilePath $logFile -append -InputObject $_.Exception.Message
}

Out-File -FilePath $logFile -append -InputObject  ===========================================================
Out-File -FilePath $logFile -append -InputObject "Create D Partition"
Out-File -FilePath $logFile -append -InputObject  ===========================================================
try {
  Initialize-Disk 1 -PartitionStyle GPT
  New-Partition -Disknumber 1 -DriveLetter D -UseMaximumSize
  Format-Volume D -FileSystem NTFS -NewFileSystemLabel "Data" -Confirm:$false
} catch {
  Out-File -FilePath $logFile -append -InputObject "ERROR: Fout bij aanmaken D schijf"
  Out-File -FilePath $logFile -append -InputObject $_.Exception.Message
}

Out-File -FilePath $logFile -append -InputObject  ===========================================================
Out-File -FilePath $logFile -append -InputObject "High Performance"
Out-File -FilePath $logFile -append -InputObject  ===========================================================
try {
  powercfg /s 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
} catch {
  Out-File -FilePath $logFile -append -InputObject "ERROR: Fout bij instellen High Performance"
  Out-File -FilePath $logFile -append -InputObject $_.Exception.Message
}

Out-File -FilePath $logFile -append -InputObject  ===========================================================
Out-File -FilePath $logFile -append -InputObject "Disable SSH"
Out-File -FilePath $logFile -append -InputObject  ===========================================================

# ---- SSH SERVICE CHECK ----
$sshService = Get-Service -Name "sshd" -ErrorAction SilentlyContinue

if ($sshService) {
    Out-File "SSH service gevonden - wordt gestopt en disabled"
    if ($sshService.Status -ne "Stopped") {
        Stop-Service -Name "sshd" -Force
    }
    Set-Service -Name "sshd" -StartupType Disabled
} else {
    Out-File "SSH service niet aanwezig"
}

# ---- FIREWALL SSH RULES ----
$sshRules = Get-NetFirewallRule | Where-Object {
    $_.DisplayName -match "SSH" -or
    (Get-NetFirewallPortFilter -AssociatedNetFirewallRule $_ -ErrorAction SilentlyContinue).LocalPort -eq 22
}

if ($sshRules) {
    Out-File "Firewall SSH rules gevonden - worden disabled"
    $sshRules | Disable-NetFirewallRule
} else {
    Out-File "Geen SSH firewall rules gevonden"
}
