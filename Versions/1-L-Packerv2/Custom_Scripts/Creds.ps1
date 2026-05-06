#create dir
If(!(Test-Path -path "$packer_folder\Creds\")) {
    Write-host "creating creds dir" -ForegroundColor Yellow
    New-Item -Typ Directory "$packer_folder\Creds\" | Out-Null
}
Write-Host "Select or Create Creds" -ForegroundColor Blue
Write-Host "1. create new" -ForegroundColor Yellow
Write-Host "2. select existing" -ForegroundColor Blue
$ask = Read-Host "Make a Choice"
if ($ask -eq "1") {
    $ask_name = Read-Host "give name of host"
    #create
    $vCenterCredentials = Get-Credential -Message "Input a username and password to connect"
    $vCenterCredentials | Export-Clixml -Path "$packer_folder\Creds\$ask_name.xml"
} elseif ($ask -eq "2") {
    
    $creds_items = Get-ChildItem "$packer_folder\Creds\"
    if ($creds_items){
        Write-Host "Select an item to read:`n" -ForegroundColor Blue

        for ($i = 0; $i -lt $creds_items.Count; $i++) {
            Write-Host "$($i + 1) - $($creds_items[$i].Name)"
        }

        $choice = Read-Host "`nEnter choice"
        switch ($choice) {
            { $_ -as [int] -and $_ -ge 1 -and $_ -le $creds_items.Count } {
                $index = [int]$choice - 1
                #import 
                $vCenterCredentials = Import-Clixml -Path $creds_items[$index].FullName
                Write-Host "vCenter Credentials  "$creds_items[$index].Name" are loaded" -ForegroundColor Green
            } default {
                Write-Host "Invalid selection" -ForegroundColor RED
            }
        }
    } else{
        Write-Host "no creds found" -ForegroundColor Red
    }
} else {
    Write-Host "Invalid choiche: $ask" -ForegroundColor Yellow
}