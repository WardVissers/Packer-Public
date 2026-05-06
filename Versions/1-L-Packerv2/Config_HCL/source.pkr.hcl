# Alle Sources

source "vsphere-iso" "linux-ubuntu" {
  CPUs     = var.vm_cpus
  notes    = "Built by HashiCorp Packer on ${local.buildtime}."
  RAM      = var.vm_memory
  firmware = var.vm_firmware
  # Enable nested hardware virtualization for the virtual machine.
  NestedHV        = var.vhv_enable
  RAM_reserve_all = var.vm_memory_reserve_all
  cluster         = var.vcenter_cluster
  configuration_parameters = {
    "devices.hotplug"  = var.vm_hotplug
    "logging"          = var.vm_logging
    "svga.autodetect"  = "FALSE"
    "svga.numDisplays" = "2"
  }
  create_snapshot      = var.create_snapshot
  remove_cdrom         = var.remove_cdrom
  cpu_cores            = var.vm_cores
  datastore            = var.vcenter_datastore
  disk_controller_type = var.vm_disk_controller_type
  # floppy_files         = [""]
  guest_os_type        = var.operating_system_vm
  host                 = var.host
  iso_paths            = ["${var.datastore_iso}${var.datastore_iso_path}${var.datastore_iso_file}"]
  network_adapters {
    network      = var.vcenter_network
    network_card = var.vm_network_card
  }
  storage {
    disk_size             = var.vm_disk_size
    disk_thin_provisioned = var.vm_disk_thin
  }
  username       = var.vcenter_admin
  password       = var.vcenter_password
  vcenter_server = var.vcenter_host
  insecure_connection  = var.vsphere_insecure_connection
  vm_name        = var.vm_name
  vm_version     = var.vm_hardwareversion
  folder         = var.vcenter_folder
  # CPU
  # vTPM = var.vm_tpm
  # Enable VBS
  vbs_enabled  = var.vbs_enabled
  vvtd_enabled = var.vvtd_enabled
  #Templates
  convert_to_template  = var.convert_to_template
  # content_library_destination {
  #  name = var.template_library_Name
  #  destroy = var.library_vm_destroy
  #  library = var.content_library_destination
  #  ovf     = var.ovf
  #}
  
   http_directory       = "./Config_OS/Ubuntu/http"
   http_ip              = var.local_ip


  # SSH
  communicator              = var.communicator
  ssh_username              = var.SSH_User
  ssh_password              = var.SSH_Pass
  winrm_username            = var.winrm_User
  winrm_password            = var.winrm_Pass
  ssh_timeout               = var.ssh_timeout
  ssh_clear_authorized_keys = var.ssh_clear_authorized_keys

  // Boot and Provisioning Settings
  boot_wait = "3s"
  boot_command = [
    "c<wait>linux /casper/vmlinuz --- autoinstall 'ds=nocloud;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/'<enter><wait>",
    "initrd /casper/initrd<enter><wait><wait>",
    "boot<enter><wait>"
  ]
  shutdown_command    = "echo '${var.SSH_Pass}' | sudo -S shutdown -P now"
  
}

source "vsphere-iso" "Windows" {
  vm_name  = var.vm_name
  CPUs     = var.vm_cpus
  notes    = "Built by HashiCorp Packer on ${local.buildtime}."
  RAM      = var.vm_memory
  firmware = var.vm_firmware
  # Enable nested hardware virtualization for the virtual machine.
  NestedHV        = var.vhv_enable
  RAM_reserve_all = var.vm_memory_reserve_all
  cluster         = var.vcenter_cluster
  configuration_parameters = {
    "devices.hotplug"  = var.vm_hotplug
    "logging"          = var.vm_logging
    "svga.autodetect"  = "FALSE"
    "svga.numDisplays" = "2"
  }
  create_snapshot      = var.create_snapshot
  remove_cdrom         = var.remove_cdrom
  cpu_cores            = var.vm_cores
  datastore            = var.vcenter_datastore
  disk_controller_type = var.vm_disk_controller_type
  guest_os_type        = var.operating_system_vm
  host                 = var.host
  iso_paths            = ["${var.datastore_iso}${var.datastore_iso_path}${var.datastore_iso_file}"]
  network_adapters {
    network      = var.vcenter_network
    network_card = var.vm_network_card
  }
  # Primary disk
  storage {
    disk_size             = var.vm_disk_size
    disk_thin_provisioned = var.vm_disk_thin
  }
  # Secondary disk
  storage {
    disk_size             = var.vm_second_disk_size
    disk_thin_provisioned = var.vm_second_disk_thin
    disk_controller_index = 0
  }
  username       = var.vcenter_admin
  password       = var.vcenter_password
  vcenter_server = var.vcenter_host
  insecure_connection  = var.vsphere_insecure_connection
  vm_version     = var.vm_hardwareversion
  folder         = var.vcenter_folder
  floppy_files   = var.floppy_files

  http_directory       = "./vGPU/Guest_Drivers"
  http_ip              = var.local_ip

  
  # CPU
  vTPM = var.vm_tpm
  # Enable VBS
  vbs_enabled  = var.vbs_enabled
  vvtd_enabled = var.vvtd_enabled
  #Templates
  convert_to_template  = var.convert_to_template
  # content_library_destination {
  #  name = var.template_library_Name
  #  destroy = var.library_vm_destroy
  #  library = var.content_library_destination
  #  ovf     = var.ovf
  #}

  # SSH
    # SSH/WinRM
  communicator              = var.communicator
  ssh_username              = var.SSH_User
  ssh_password              = var.SSH_Pass
  ssh_timeout               = var.ssh_timeout
  ssh_clear_authorized_keys = var.ssh_clear_authorized_keys
  winrm_port          =  var.winrm_port
  winrm_username      = var.winrm_User
  winrm_password      = var.winrm_Pass
  winrm_timeout       = var.winrm_timeout 

  // Boot and Provisioning Settings
  boot_order       = var.vm_boot_order
  boot_wait        = var.vm_boot_wait
  boot_command     = var.vm_boot_command
  shutdown_command = var.vm_shutdown_command
}