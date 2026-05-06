# Hardware specifications
vm_name                  = "W11-24H2-vGPU"
operating_system_vm     = "windows11_64Guest" # windows2022srvNext_64Guest Microsoft Windows Server 2025 (64-bit)
vm_cdrom_type           = "sata"
vm_cpus                 = "2"
vm_cores                = "2"
vm_firmware             = "efi-secure"
vbs_enabled             = "true"
vvtd_enabled            = "true"
vhv_enable              = "true"
vm_memory               = "8192"
vm_memory_reserve_all   = "false"
vm_disk_controller_type = ["pvscsi"]
vm_disk_size            = "102400"
vm_disk_thin            = "true"
# Boot Settings
vm_boot_command         = ["<spacebar><spacebar>"]
vm_shutdown_command     = "shutdown /s /t 10 /f /d p:4:1 /c \"Shutdown by Packer\""
convert_to_template     = "true"
ovf                     = "false"
library_vm_destroy      = "false"
content_library_destination = "WardPacker"
floppy_files         = ["setup/win11-24h2/efi/autounattend.xml","setup/install-vmtools.ps1","setup/enable-winrm.ps1","setup/disable-autologon.ps1","setup/disable-ssh.ps1","setup/Download_Mozilla_Firefox.ps1","setup/Download_Google_Chrome.ps1"]# ["${path.root}/setup/"]
communicator = "winrm"
winrm_User = "Administrator"
winrm_timeout = "30m"

# ISO location
datastore_iso_file      = "Microsoft/Client/Windows11/24H2/SW_DVD9_WIN_ENT_LTSC_2024_64-bit_English_MLF_X23-70046.ISO"