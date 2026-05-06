# Start scheduled task
$taskName = "\Microsoft\Windows\PI\Secure-Boot-Update"

try {
    Start-ScheduledTask -TaskName $taskName
    Write-Host "Scheduled task started: $taskName"
}
catch {
    Write-Warning "Failed to start scheduled task: $_"
}