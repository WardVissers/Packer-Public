$CustomViewName = "SecurebootFix"
$OutputFile = "C:\Temp\$CustomViewName.xml"

$xml = @"
<ViewerConfig><QueryConfig><QueryParams><Simple><Channel>System</Channel><RelativeTimeInfo>0</RelativeTimeInfo><Source>Microsoft-Windows-TPM-WMI</Source><Level>1,2,3,4,0,5</Level><BySource>True</BySource></Simple></QueryParams><QueryNode><Name>SecureBootFix</Name><QueryList><Query Id="0"><Select Path="System">*[System[Provider[@Name='Microsoft-Windows-TPM-WMI'] and (Level=1  or Level=2 or Level=3 or Level=4 or Level=0 or Level=5)]]</Select></Query></QueryList></QueryNode></QueryConfig></ViewerConfig>
"@

# Create folder if needed
$folder = Split-Path $OutputFile
if (-not (Test-Path $folder)) {
    New-Item -Path $folder -ItemType Directory -Force | Out-Null
}

# Save XML
$xml | Set-Content -Path $OutputFile -Encoding UTF8

Write-Host "Custom View XML created: $OutputFile" -ForegroundColor Green
Copy-Item "C:\Temp\$CustomViewName.xml"  "$env:ProgramData\Microsoft\Event Viewer\Views\" -Force