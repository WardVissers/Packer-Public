[CmdletBinding()]
param(
    [string]$SevenZipPath = "C:\Program Files\7-Zip\7z.exe",
    [string]$IisLogsRoot = "C:\inetpub\logs\LogFiles",
    [string]$ArchiveRoot = "D:\IIS-Log-Archive",
    [int]$ArchiveOlderThanDays = 1,
    [int]$KeepArchivesDays = 180,
    [switch]$DeleteOriginalLogs
)

function Assert-Path {
    param(
        [string]$Path,
        [string]$Message
    )
    if (-not (Test-Path -LiteralPath $Path)) {
        throw "$Message: $Path"
    }
}

Assert-Path -Path $SevenZipPath -Message "7-Zip not found"

if (-not (Test-Path -LiteralPath $IisLogsRoot)) {
    Write-Host "IIS log root not found, skipping: $IisLogsRoot"
    exit 0
}

if (-not (Test-Path -LiteralPath $ArchiveRoot)) {
    New-Item -ItemType Directory -Path $ArchiveRoot -Force | Out-Null
}

$cutoff = (Get-Date).AddDays(-$ArchiveOlderThanDays)
$siteFolders = Get-ChildItem -LiteralPath $IisLogsRoot -Directory -ErrorAction SilentlyContinue

foreach ($site in $siteFolders) {
    $logs = Get-ChildItem -LiteralPath $site.FullName -File -Filter "*.log" -ErrorAction SilentlyContinue |
            Where-Object { $_.LastWriteTime -lt $cutoff }

    if (-not $logs) {
        Write-Host "[$($site.Name)] No logs to archive."
        continue
    }

    $stamp = Get-Date -Format "yyyy-MM-dd_HHmmss"
    $siteArchiveDir = Join-Path $ArchiveRoot $site.Name

    if (-not (Test-Path -LiteralPath $siteArchiveDir)) {
        New-Item -ItemType Directory -Path $siteArchiveDir -Force | Out-Null
    }

    $archiveFile = Join-Path $siteArchiveDir ("IIS_{0}_{1}.7z" -f $site.Name, $stamp)
    $logPaths = $logs.FullName

    Write-Host "[$($site.Name)] Archiving $($logs.Count) files to $archiveFile"

    $arguments = @(
        "a"
        "-t7z"
        "-mx=9"
        "-bd"
        "-y"
        $archiveFile
    ) + $logPaths

    $proc = Start-Process -FilePath $SevenZipPath -ArgumentList $arguments -Wait -PassThru -NoNewWindow

    if ($proc.ExitCode -ne 0) {
        Write-Warning "[$($site.Name)] 7-Zip failed with exit code $($proc.ExitCode)"
        continue
    }

    $archiveInfo = Get-Item -LiteralPath $archiveFile -ErrorAction Stop
    if ($archiveInfo.Length -le 0) {
        Write-Warning "[$($site.Name)] Archive file is empty, original logs not deleted."
        continue
    }

    if ($DeleteOriginalLogs) {
        foreach ($f in $logs) {
            Remove-Item -LiteralPath $f.FullName -Force -ErrorAction SilentlyContinue
        }
    }
}

if ($KeepArchivesDays -gt 0) {
    $archiveCutoff = (Get-Date).AddDays(-$KeepArchivesDays)

    Get-ChildItem -LiteralPath $ArchiveRoot -Recurse -File -Filter "*.7z" -ErrorAction SilentlyContinue |
        Where-Object { $_.LastWriteTime -lt $archiveCutoff } |
        ForEach-Object {
            Remove-Item -LiteralPath $_.FullName -Force -ErrorAction SilentlyContinue
        }
}

Write-Host "Archive-IISLogs completed successfully."
exit 0