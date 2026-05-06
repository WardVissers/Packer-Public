     $vcenter_items = Get-ChildItem "$packer_folder\Config_vsphere\"
    if ($vcenter_items){
        Write-Host "Make a Choice for vCenter to read:`n" -ForegroundColor Blue

        for ($i = 0; $i -lt $vcenter_items.Count; $i++) {
            Write-Host "$($i + 1) - $($vcenter_items[$i].Name)"
        }

        $choice = Read-Host "`nEnter choice"
        switch ($choice) {
            { $_ -as [int] -and $_ -ge 1 -and $_ -le $vcenter_items.Count } {
                $index = [int]$choice - 1
                #import 
                $vCenter = Get-Item -Path $vcenter_items[$index].FullName | Select-Object FullName
                $vCenter = $vCenter.FullName
                Write-Host "vCenter Credentials  "$vcenter_items[$index].Name " are loaded" -ForegroundColor Green
            } default {
                Write-Host "Invalid selection" -ForegroundColor RED
            }
        }
    } else{
        Write-Host "no vCenter Found found" -ForegroundColor Red
    }
