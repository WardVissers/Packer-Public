# Hardware specifications
vm_name                 = "WSRV2025STDDEXP-PCK"
operating_system_vm     = "windows2022srvNext_64Guest" # windows2022srvNext_64Guest Microsoft Windows Server 2025 (64-bit)
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
floppy_files            = ["setup/win25/efi/autounattend.xml","setup/begin.ps1","setup/install-vmtools.ps1","setup/enable-ssh.ps1","setup/secure-ssh.ps1","setup/Server_ChangeCDRomDriveLetter.ps1","setup/Server_Disable_IPv6_NetBios.ps1","setup/Server_Print_Spooler_Disable.ps1","setup/disable-autologon.ps1","setup/disable-ssh.ps1","setup/Eventvwr_FixSecureboot.ps1"]# ["${path.root}/setup/"]
# SSH
SSH_User = "administrator"
# ISO location
datastore_iso_file      = "Microsoft/Server/Server 2025/SW_DVD9_Win_Server_STD_CORE_2025_24H2_64Bit_English_DC_STD_MLF_X23-81891.ISO"