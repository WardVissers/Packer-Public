# Hardware specifications
vm_name                    = "Unbuntu-24.04-PCK-T01"
operating_system_vm     = "ubuntu64Guest" # windows2022srvNext_64Guest Microsoft Windows Server 2025 (64-bit)
vm_cdrom_type           = "sata"
vm_cpus                 = "2"
vm_cores                = "2"
vm_firmware             = "efi-secure"
vbs_enabled             = "true"
vvtd_enabled            = "true"
vhv_enable              = "false"
vm_memory               = "8192"
vm_memory_reserve_all   = "false"
vm_disk_controller_type = ["pvscsi"]
vm_disk_size            = "102400"
vm_disk_thin            = "true"
# Boot Settings
vm_boot_command         = ["c<wait>linux /casper/vmlinuz --- autoinstall 'ds=nocloud;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/'<enter><wait>",
  "initrd /casper/initrd<enter><wait><wait>",
  "boot<enter><wait>"]
convert_to_template     = "true"
ovf                     = "false"
library_vm_destroy      = "false"
content_library_destination = "WardPacker"
SSH_User                 = "ubuntu"
vm_shutdown_command     = "shutdown -h now"
ssh_timeout             = "20m" 


# ISO location
datastore_iso_file      = "Linux/Ubuntu/ubuntu-24.04.3-live-server-amd64.iso"