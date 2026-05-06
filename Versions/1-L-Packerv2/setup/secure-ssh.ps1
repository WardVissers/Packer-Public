# -----------------------------
# General Variables
# -----------------------------
$SshDir      = "C:\ProgramData\ssh"
$ConfigFile  = "$SshDir\sshd_config"
$BackupFile  = "$SshDir\sshd_config.bak_$(Get-Date -Format yyyyMMdd_HHmmss)"
$BannerFile  = "$SshDir\banner.txt"
$AllowGroup  = "Administrators"   # Dedicated SSH access group (recommended)

function Set-SshdOption {
    param (
        [string]$Key,
        [string]$Value
    )

    $pattern = "^\s*#?\s*$Key\s+.*$"

    if (Select-String -Path $ConfigFile -Pattern $pattern -Quiet) {
        (Get-Content $ConfigFile) |
            ForEach-Object {
                if ($_ -match $pattern) { "$Key $Value" } else { $_ }
            } | Set-Content $ConfigFile -Encoding utf8
    } else {
        Add-Content -Path $ConfigFile -Value "$Key $Value"
    }
}

Write-Host "`n[$env:COMPUTERNAME] OpenSSH hardening gestart" -ForegroundColor Cyan

# -----------------------------
# Validations
# -----------------------------
if (-not (Get-Service sshd -ErrorAction SilentlyContinue)) {
    Write-Warning "sshd service niet gevonden � script wordt afgebroken"
    return
}

# -----------------------------
# Backup
# -----------------------------
Copy-Item $ConfigFile $BackupFile -Force

# -----------------------------
# Banner
# -----------------------------
@"
Authorized use only.
All activity may be monitored and logged.
"@ | Set-Content -Path $BannerFile -Encoding ascii

Set-SshdOption "Banner" $BannerFile

# -----------------------------
# Access Control
# -----------------------------
Set-SshdOption "AllowGroups" $AllowGroup
Set-SshdOption "PermitEmptyPasswords" "no"
Set-SshdOption "PermitUserEnvironment" "no"

# -----------------------------
# Crypto
# -----------------------------
Set-SshdOption "Ciphers" "chacha20-poly1305@openssh.com,aes256-gcm@openssh.com"

# Uncomment only if supported by your OpenSSH version
#Set-SshdOption "MACs" "hmac-sha2-512-etm@openssh.com,hmac-sha2-256-etm@openssh.com"
#Set-SshdOption "KexAlgorithms" "curve25519-sha256,curve25519-sha256@libssh.org"

# -----------------------------
# Session Hardening
# -----------------------------
Set-SshdOption "LoginGraceTime" "30"
Set-SshdOption "MaxAuthTries" "3"
Set-SshdOption "MaxSessions" "5"
Set-SshdOption "MaxStartups" "10:30:60"
Set-SshdOption "ClientAliveInterval" "300"
Set-SshdOption "ClientAliveCountMax" "0"

# -----------------------------
# Disable Risky Features
# -----------------------------
Set-SshdOption "DisableForwarding" "yes"
Set-SshdOption "GSSAPIAuthentication" "no"
Set-SshdOption "HostbasedAuthentication" "no"
Set-SshdOption "IgnoreRhosts" "yes"

# -----------------------------
# Logging
# -----------------------------
Set-SshdOption "LogLevel" "VERBOSE"

# -----------------------------
# File Permissions (before restart)
# -----------------------------
icacls $ConfigFile /inheritance:r | Out-Null
icacls $ConfigFile /grant:r "SYSTEM:F" "Administrators:F" | Out-Null

Get-ChildItem "$SshDir\ssh_host_*_key" -ErrorAction SilentlyContinue | ForEach-Object {
    icacls $_.FullName /inheritance:r | Out-Null
    icacls $_.FullName /grant:r "SYSTEM:F" | Out-Null
}

# -----------------------------
# Validate config
# -----------------------------
sshd.exe -t

# -----------------------------
# Restart sshd
# -----------------------------
Restart-Service sshd -Force

Write-Host "[$env:COMPUTERNAME] OpenSSH hardening voltooid" -ForegroundColor Green
