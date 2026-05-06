#change password

if ($password){
	
    #Linux
    $file = "$packer_folder\Config_OS\Ubuntu\http\user-data"
    Write-Host "working on: $($file)" -ForegroundColor Yellow
	
    $old_linux_password_encpt = (Get-Content $file | select-string "password:" | Select-Object -ExpandProperty Line).replace("    password: ","").replace("   # SHA-512 hash","")
    $new_linux_password_encpt = & "C:\Program Files\OpenSSL-Win64\bin\openssl.exe" passwd -6 "$password"

	(Get-Content $file -raw ).replace("$old_linux_password_encpt",$new_linux_password_encpt) | Set-Content $file
     
     
    # AutoLogon password encoding
    $new_win_password_encpt = [Convert]::ToBase64String([System.Text.Encoding]::Unicode.GetBytes($password + "Password"))

    # Administrator password encoding  
    $new_win_password_encpt_adm = [Convert]::ToBase64String([System.Text.Encoding]::Unicode.GetBytes($password + "AdministratorPassword"))

    #win
    $versions = ("win11-23h2","win11-24h2","win11-25h2")
    foreach ($version in $versions){
        $file = "$packer_folder\setup\$($version)\efi\autounattend.xml"
        Write-Host "working on: $($file)" -ForegroundColor Yellow
    
        #2 passwords uit de xml halen 
        $xml = [xml](Get-Content $file)
        $old_win_password_encpt = $xml.unattend.settings[1].component[1].AutoLogon.Password.Value
        $old_win_password_encpt_adm = $xml.unattend.settings[1].component[1].UserAccounts.AdministratorPassword.Value
        
        (Get-Content $file -raw ) -replace $old_win_password_encpt,$new_win_password_encpt -replace $old_win_password_encpt_adm,$new_win_password_encpt_adm | Set-Content $file
    }

    #SRV
    $versions = ("win16","win19","win22","win22core","win25","win25core")
    foreach ($version in $versions){
        $file = "$packer_folder\setup\$($version)\efi\autounattend.xml"
        Write-Host "working on: $($file)" -ForegroundColor Yellow
    
        #2 passwords uit de xml halen 
        $xml = [xml](Get-Content $file)
        $old_win_password_encpt = $xml.unattend.settings[2].component.AutoLogon.Password.Value
        $old_win_password_encpt_adm = $xml.unattend.settings[2].component.UserAccounts.AdministratorPassword.Value
        
        (Get-Content $file -raw ) -replace $old_win_password_encpt,$new_win_password_encpt -replace $old_win_password_encpt_adm,$new_win_password_encpt_adm | Set-Content $file
    }
}
Else{
    Write-Host "Password was empty & XML files are not updated"
}

