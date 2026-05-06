[Net.ServicePointManager]::SecurityProtocol = "tls12"

$os = (Get-CimInstance Win32_OperatingSystem).Caption

if ($os -match 'Windows Server 2016|Windows Server 2019') {
Write-Host "Detected supported OS: $os"
mkdir -Path $env:temp\edgeinstall -erroraction SilentlyContinue | Out-Null
$Download = join-path $env:temp\edgeinstall MicrosoftEdgeEnterpriseX64.msi
Invoke-WebRequest 'http://go.microsoft.com/fwlink/?LinkID=2093437'  -OutFile $Download
Start-Process -Wait "$Download" -ArgumentList "/quiet /passive /norestart"
# placeholder for "enter" autokeyhit
}
else {
     Write-Host "OS not supported for Edge install: $os"
}