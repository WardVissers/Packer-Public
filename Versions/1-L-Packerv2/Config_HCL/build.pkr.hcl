build {
  name = "Ubuntu"
  sources = ["vsphere-iso.linux-ubuntu"]
  # Next Steps

  provisioner "file" {
    source      = "setup/Files_Linux/sshd_config_cis"
    destination = "/tmp/sshd_config"
  } 

  provisioner "shell" {
    execute_command = "echo '${var.SSH_Pass}' | sudo -S env {{ .Vars }} {{ .Path }}"
    inline = [
    "sudo sshd -t -f /tmp/sshd_config",
    "sudo cp /tmp/sshd_config /etc/ssh/sshd_config",
    "sudo chown root:root /etc/ssh/sshd_config",
    "sudo chmod 600 /etc/ssh/sshd_config",
    "sudo systemctl restart ssh"
  ]
  }

   provisioner "shell" {
  execute_command = "echo '${var.SSH_Pass}' | sudo -S env {{ .Vars }} {{ .Path }}"
  inline = [
    "sudo apt-get update -y",
    "sudo apt-get install -y cloud-init open-vm-tools",
    "sudo systemctl enable cloud-init",

    # reset machine identity
    "sudo truncate -s 0 /etc/machine-id",
    "sudo rm -f /var/lib/dbus/machine-id",

    # clean cloud-init for template
    "sudo cloud-init clean --logs",

    # remove ssh host keys
    "sudo rm -f /etc/ssh/ssh_host_*"
  ]
 }
}

build {
  name = "Ubuntu_vGPU"
  sources = ["vsphere-iso.linux-ubuntu"]
  # Next Steps

  provisioner "file" {
    source      = "setup/Files_Linux/sshd_config_cis"
    destination = "/tmp/sshd_config"
  } 

  provisioner "shell" {
    execute_command = "echo '${var.SSH_Pass}' | sudo -S env {{ .Vars }} {{ .Path }}"
    inline = [
    "sudo sshd -t -f /tmp/sshd_config",
    "sudo cp /tmp/sshd_config /etc/ssh/sshd_config",
    "sudo chown root:root /etc/ssh/sshd_config",
    "sudo chmod 600 /etc/ssh/sshd_config",
    "sudo systemctl restart ssh"
  ]
  }

  # provisioner "shell" {
  #execute_command = "echo '${var.SSH_Pass}' | sudo -S env {{ .Vars }} {{ .Path }}"
  #inline = ["chmod +x /tmp/nvidia*.deb",
  #          "dpkg -i /tmp/nvidia*.deb",
  #          "rm /tmp/nvidia.deb*"]
  #}

  provisioner "shell" {
  execute_command = "echo '${var.SSH_Pass}' | sudo -S env {{ .Vars }} {{ .Path }}"
  inline = [
    "sudo apt-get update -y",
    "sudo apt-get install -y cloud-init open-vm-tools",
    "sudo systemctl enable cloud-init",

    # reset machine identity
    "sudo truncate -s 0 /etc/machine-id",
    "sudo rm -f /var/lib/dbus/machine-id",

    # clean cloud-init for template
    "sudo cloud-init clean --logs",

    # remove ssh host keys
    "sudo rm -f /etc/ssh/ssh_host_*"
  ]
 }
}


build {
  name = "Windows11"
  sources = ["source.vsphere-iso.Windows"]
  
  provisioner "windows-restart" {
    restart_check_command = "powershell -command \"& {Write-Output 'restarted.'}\""
    restart_timeout       = "20m"
  }

 provisioner "powershell" {
  elevated_user     = var.winrm_User
  elevated_password = var.winrm_Pass
  inline = ["powercfg /s 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c"]
 }

  provisioner "windows-update" {
   pause_before    = "30s"
    search_criteria = "IsInstalled=0"
    filters = [
      "exclude:$_.Title -like '*Preview*'",
      "exclude:$_.InstallationBehavior.CanRequestUserInput",
      "include:$true"
    ]
    restart_timeout = "120m"
  }

  provisioner "windows-restart" {
    restart_check_command = "powershell -command \"& {Write-Output 'restarted.'}\""
    restart_timeout       = "20m"
  }

 provisioner "powershell" {
  elevated_user     = var.winrm_User
  elevated_password = var.winrm_Pass
  scripts = [
       "./setup/Download_Mozilla_Firefox.ps1", 
       "./setup/Download_Google_Chrome.ps1"      
    ]
 }

 provisioner "file" {
  source = "./setup/SecurebootCert/"
  destination = "C:/Windows/Temp"
 }

  provisioner "powershell" {
    elevated_user     = var.winrm_User
    elevated_password = var.winrm_Pass
    scripts = [
       "./setup/disable-autologon.ps1"      
    ]
  }

}

build {
  name = "Windows11_vGPU"
  sources = ["source.vsphere-iso.Windows"]
  
  provisioner "windows-restart" {
    restart_check_command = "powershell -command \"& {Write-Output 'restarted.'}\""
    restart_timeout       = "20m"
  }
 
  provisioner "powershell" {
  elevated_user     = var.winrm_User
  elevated_password = var.winrm_Pass
  inline = ["powercfg /s 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c"]
 }
 
  # provisioner "windows-update" {
  #  pause_before    = "30s"
  #  search_criteria = "IsInstalled=0"
  #  filters = [
  #    "exclude:$_.Title -like '*Preview*'",
  #    "exclude:$_.InstallationBehavior.CanRequestUserInput",
  #    "include:$true"
  #  ]
  #  restart_timeout = "120m"
  # }

  provisioner "windows-restart" {
    restart_check_command = "powershell -command \"& {Write-Output 'restarted.'}\""
    restart_timeout       = "20m"
  }

  provisioner "powershell" {
  elevated_user     = var.winrm_User
  elevated_password = var.winrm_Pass
  scripts = [
       "./setup/Download_Mozilla_Firefox.ps1", 
       "./setup/Download_Google_Chrome.ps1"      
    ]
 }
 
 provisioner "file" {
  source = "./setup/SecurebootCert/"
  destination = "C:/Windows/Temp"
 }

   provisioner "powershell" {
    elevated_user     = var.winrm_User
    elevated_password = var.winrm_Pass
    inline = [
      # Access the variables directly (they're set by Packer)
      "Write-Host \"Server: ${build.PackerHTTPAddr}\"",
      "$url = \"http://${build.PackerHTTPAddr}/Nvidia_GPU_Windows_Driver_Latest.exe\"",
      "$dst = 'C:\\Install\\Nvidia_GPU_Windows_Driver_Latest.exe'",
      "$webclient = New-object -TypeName System.Net.WebClient",
      "$webclient.DownloadFile($url, $dst)",
      "Start-Process -FilePath $dst -ArgumentList '-s' -Wait -NoNewWindow",
      "Write-Host \"Nvidia Driver is installed\""
    ]
  }

  provisioner "powershell" {
    elevated_user     = var.winrm_User
    elevated_password = var.winrm_Pass
    scripts = [
       "./setup/disable-autologon.ps1"      
    ]
  }

}

build {
   name = "Windows-ServerGeneral"
   sources = ["source.vsphere-iso.Windows"]

provisioner "windows-restart" {
    restart_check_command = "powershell -command \"& {Write-Output 'restarted.'}\""
    restart_timeout       = "20m"
  }

provisioner "windows-update" {
    pause_before    = "30s"
    search_criteria = "IsInstalled=0"
    filters = [ 
      "exclude:$_.Title -like '*Preview*'",
      # "exclude:$_.InstallationBehavior.CanRequestUserInput",
      "include:$true"
    ]
    restart_timeout = "120m"
 }

  provisioner "windows-restart" {
    restart_check_command = "powershell -command \"& {Write-Output 'restarted.'}\""
    restart_timeout       = "20m"
  }

  provisioner "powershell" {
    elevated_user     = var.SSH_User
    elevated_password = var.SSH_Pass
    scripts = [
      "./setup/Server_ChangeCDRomDriveLetter.ps1",
      "./setup/Server_Disable_IPv6_NetBios.ps1",
      "./setup/Server_Print_Spooler_Disable.ps1",
      "./setup/disable-autologon.ps1"      
    ]
  }

  provisioner "powershell" {
    elevated_user     = var.SSH_User
    elevated_password = var.SSH_Pass
    scripts = ["./setup/install-edge.ps1"]
  }


provisioner "powershell" {
    elevated_user     = var.SSH_User
    elevated_password = var.SSH_Pass
    inline = ["if ((Get-CimInstance Win32_OperatingSystem).Caption -match 'Windows Server 2022|Windows Server 2025') { Get-AppxPackage Microsoft.Edge.* | Reset-AppxPackage }"]    
  } 

 provisioner "file" {
  source = "./setup/Files_Win/"
  destination = "C:/Temp"
 }

  provisioner "file" {
  source = "./setup/SecurebootCert/"
  destination = "C:/Windows/Temp"
 }
 

   provisioner "powershell" {
    elevated_user     = var.SSH_User
    elevated_password = var.SSH_Pass
    scripts = [
       "./setup/Eventvwr_FixSecureboot.ps1"
    ]
  }
 
 provisioner "powershell" {
    elevated_user     = var.SSH_User
    elevated_password = var.SSH_Pass
    scripts = [
       "./setup/disable-ssh.ps1"
    ]
  }
}

build {
   name = "Windows-ServerGeneral_vGPU"
   sources = ["source.vsphere-iso.Windows"]

provisioner "windows-restart" {
    restart_check_command = "powershell -command \"& {Write-Output 'restarted.'}\""
    restart_timeout       = "20m"
  }

provisioner "windows-update" {
    pause_before    = "30s"
    search_criteria = "IsInstalled=0"
    filters = [ 
      "exclude:$_.Title -like '*Preview*'",
      # "exclude:$_.InstallationBehavior.CanRequestUserInput",
      "include:$true"
    ]
    restart_timeout = "120m"
 }

  provisioner "windows-restart" {
    restart_check_command = "powershell -command \"& {Write-Output 'restarted.'}\""
    restart_timeout       = "20m"
  }

  provisioner "powershell" {
    elevated_user     = var.SSH_User
    elevated_password = var.SSH_Pass
    scripts = [
      "./setup/Server_ChangeCDRomDriveLetter.ps1",
      "./setup/Server_Disable_IPv6_NetBios.ps1",
      "./setup/Server_Print_Spooler_Disable.ps1",
      "./setup/disable-autologon.ps1"      
    ]
  }

  provisioner "powershell" {
    elevated_user     = var.SSH_User
    elevated_password = var.SSH_Pass
    scripts = ["./setup/install-edge.ps1"]
  }

provisioner "powershell" {
  elevated_user     = var.SSH_User
  elevated_password = var.SSH_Pass
     inline = [
      # Access the variables directly (they're set by Packer)
      "Write-Host \"Server: ${build.PackerHTTPAddr}\"",
      "$url = \"http://${build.PackerHTTPAddr}/Nvidia_GPU_Windows_Driver_Latest.exe\"",
      "$dst = 'C:\\Install\\Nvidia_GPU_Windows_Driver_Latest.exe'",
      "$webclient = New-object -TypeName System.Net.WebClient",
      "$webclient.DownloadFile($url, $dst)",
      "Start-Process -FilePath $dst -ArgumentList '-s' -Wait -NoNewWindow"
    ]
  }


provisioner "powershell" {
    elevated_user     = var.SSH_User
    elevated_password = var.SSH_Pass
    inline = ["if ((Get-CimInstance Win32_OperatingSystem).Caption -match 'Windows Server 2022|Windows Server 2025') { Get-AppxPackage Microsoft.Edge.* | Reset-AppxPackage }"]    
  } 

 provisioner "file" {
  source = "./setup/Files_Win/"
  destination = "C:\\Temp"
 }

provisioner "file" {
  source = "./setup/SecurebootCert/"
  destination = "C:/Windows/Temp"
   }

    provisioner "powershell" {
    elevated_user     = var.SSH_User
    elevated_password = var.SSH_Pass
    scripts = [
       "./setup/disable-ssh.ps1"
    ]
  }
}


build {
   name = "Windows-ServerCore"
   sources = ["source.vsphere-iso.Windows"]

provisioner "windows-restart" {
    restart_check_command = "powershell -command \"& {Write-Output 'restarted.'}\""
    restart_timeout       = "20m"
  }

provisioner "windows-update" {
    pause_before    = "30s"
    search_criteria = "IsInstalled=0"
    filters = [
      "exclude:$_.Title -like '*Preview*'",
      # "exclude:$_.InstallationBehavior.CanRequestUserInput",
      "include:$true"
    ]
    restart_timeout = "120m"
  }

  provisioner "windows-restart" {
    restart_check_command = "powershell -command \"& {Write-Output 'restarted.'}\""
    restart_timeout       = "20m"
  }

  provisioner "powershell" {
    elevated_user     = var.SSH_User
    elevated_password = var.SSH_Pass
    scripts = [
      "./setup/Server_ChangeCDRomDriveLetter.ps1",
      "./setup/Server_Disable_IPv6_NetBios.ps1",
      "./setup/disable-autologon.ps1"      
    ]
  }

provisioner "file" {
  source = "./setup/Files_Win/"
  destination = "C:/Temp"
 }

 provisioner "file" {
  source = "./setup/SecurebootCert/"
  destination = "C:/Windows/Temp"
 }

    provisioner "powershell" {
    elevated_user     = var.SSH_User
    elevated_password = var.SSH_Pass
    scripts = [
       "./setup/disable-ssh.ps1"
    ]
  }
}

build {
   name = "Windows-ServerCoreFod"
   sources = ["source.vsphere-iso.Windows"]

provisioner "windows-restart" {
    restart_check_command = "powershell -command \"& {Write-Output 'restarted.'}\""
    restart_timeout       = "20m"
  }

provisioner "windows-update" {
    pause_before    = "30s"
    search_criteria = "IsInstalled=0"
    filters = [
      "exclude:$_.Title -like '*Preview*'",
      # "exclude:$_.InstallationBehavior.CanRequestUserInput",
      "include:$true"
    ]
    restart_timeout = "120m"
  }

  provisioner "windows-restart" {
    restart_check_command = "powershell -command \"& {Write-Output 'restarted.'}\""
    restart_timeout       = "20m"
  }

  provisioner "powershell" {
    elevated_user     = var.SSH_User
    elevated_password = var.SSH_Pass
    scripts = [
      "./setup/Server_ChangeCDRomDriveLetter.ps1",
      "./setup/Server_Disable_IPv6_NetBios.ps1",
      "./setup/disable-autologon.ps1"      
    ]
  }

provisioner "powershell" {
  elevated_user     = var.SSH_User
  elevated_password = var.SSH_Pass
  inline = [
    "powershell -NoProfile -ExecutionPolicy Bypass -Command \"if ((Get-ItemProperty 'HKLM:\\SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion').InstallationType -ne 'Server Core') { exit 0 }\"",
    "powershell -NoProfile -ExecutionPolicy Bypass -Command \"[Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12\"",
    "powershell -NoProfile -ExecutionPolicy Bypass -Command \"Add-WindowsCapability -Online -Name 'ServerCore.AppCompatibility~~~~0.0.1.0' -ErrorAction SilentlyContinue -WarningAction SilentlyContinue\""
  ]
}

provisioner "file" {
  source = "./setup/Files_Win/"
  destination = "C:\\Temp"
 }


provisioner "file" {
  source = "./setup/SecurebootCert/"
  destination = "C:/Windows/Temp"
 }

    provisioner "powershell" {
    elevated_user     = var.SSH_User
    elevated_password = var.SSH_Pass
    scripts = [
       "./setup/disable-ssh.ps1"
    ]
  }
}