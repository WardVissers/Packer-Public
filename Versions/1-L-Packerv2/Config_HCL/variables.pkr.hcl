# Windows Server 2025 deployment
# Change log:
#   Ivo Beerens November 8, 2024, Creation

locals {
  timestamp        = regex_replace(timestamp(), "[- TZ:01]", "")
  buildtime        = formatdate("DD-MM-YYYY hh:mm ZZZ", timestamp())
  manifest_date    = formatdate("DD-MM-YYYY hh:mm:ss", timestamp())

}

variable "datastore_iso" { 
 type    = string
}

variable "local_ip" {
  type    = string
  description = "local ip from the packer host"
  default = "XXX.XXX.XXX.XXX"
}

variable "datastore_iso_path" {
  type    = string
 }

variable "datastore_iso_file" {
  type    = string
  description = "Golden Image name"
}

variable "vcenter_admin" {
  type    = string
  default = ""
}

variable "vcenter_password" {
  type      = string
  default   = ""
  sensitive = true
}

variable "vsphere_insecure_connection" {
  type        = string
  description = "vsphere_insecure_connection"
  default = "false"
}

variable "host" {
  type        = string
  description = "VMware ESXi host"
}


variable "vcenter_cluster" {
  type        = string
  description = "vCenter cluster name"
}

variable "vcenter_datastore" {
  type        = string
  description = "vSphere datastore"
}

variable "vcenter_host" {
  type        = string
  description = "vCenter Server"
}

variable "vcenter_network" {
  type        = string
  description = "Portgroup name"
}

variable "vcenter_folder" {
  type        = string
  description = "Folder name"
 }

variable "vm_name" {
  default     = "packer-vm"
  type        = string
  description = "Golden Image name"
}

variable "operating_system_vm" {
  type        = string
  description = "OS Guest OS"
}

variable "vm_memory" {
  type        = string
  description = "VM Memory"
  default = "8192"
}

variable "vm_memory_reserve_all" {
  type        = string
  description = "Reserve all memory?"
  default = "false"
}

variable "vm_cores" {
  type        = string
  description = "Amount of cores"
  default = "2"
}

variable "vm_cpus" {
  type        = string
  description = "amount of vCPUs"
  default = "2"
}

variable "vm_disk_controller_type" {
  type        = list(string)
  description = "Controller type"
  default = ["pvscsi"]
}

variable "vm_disk_size" {
  type        = string
  description = "Harddisk size"
  default = "102400"
}

variable "vm_disk_thin" {
  type        = string
  description = "Enable/Disable thin provisioning"
  default = "true"
}

variable "vm_second_disk_size" {
  type        = string
  description = "Size of the second hard disk in MB"
  default     = "30720"
}

variable "vm_second_disk_thin" {
  type        = bool
  description = "Enable thin provisioning for second disk"
  default     = true
}

# VMware Hardware versions https://kb.vmware.com/s/article/1003746
# VMware ESXi 8 = 21
variable "vm_hardwareversion" {
  type        = string
  description = "VM hardware version"
  default = "21"
}

variable "floppy_files" {
type        = list(string)
description = "Setup Files"
default =["leegbestand.txt"]
}

variable "floppy_content" {
  default = null
  description = "Floppy_Content"
}

variable "vm_firmware" {
  type        = string
  description = "The virtual machine firmware. (e.g. 'efi-secure'. 'efi', or 'bios')"
  default     = "efi-secure"
}



variable "vm_cdrom_type" {
  type        = string
  description = "The virtual machine CD-ROM type. (e.g. 'sata', or 'ide')"
  default     = "ide"
}

variable "common_remove_cdrom" {
  type        = bool 
  description = "Remove the virtual CD-ROM(s)."
  default     = false
}

variable "vm_hotplug" {
  type        = string
  description = "Enable/Disable hotplug?"
  default = "false"
}

variable "vm_logging" {
  type        = string
  description = "Enable/Disable VM Logging"
  default = "false"
}

variable "vm_network_card" {
  type        = string
  description = "Networkcard type"
  default = "vmxnet3"
}

variable "vm_vgpu" {
  type        = string
  description = "VM vGPU size"
  default = "none"
}

variable "vm_boot_order" {
  type        = string
  description = "The boot order for virtual machines devices. (e.g. 'disk,cdrom')"
  default     = "disk,cdrom"
}

variable "vm_boot_wait" {
  type        = string
  description = "The time to wait before boot."
  default = "3s"
}

variable "vm_boot_command" {
  type        = list(string)
  description = "The virtual machine boot command."
  default     = []
}

variable "vm_shutdown_command" {
  type        = string
  description = "Command(s) for guest operating system shutdown."
}

variable "vm_tpm" {
  type    = string
  default = "false"
}

variable "create_snapshot" {
  type = string
  default = "false"
}

variable "remove_cdrom" {
  type = string
  default = "false"
}

variable "vbs_enabled" {
  type = string
  default = "true"
}

variable "vvtd_enabled" {
  type = string
  default = "true"
}

variable "vhv_enable" {
  type        = string
  description = "Enabled Nested HardWare Virtualisation"
  default     = "true"
}

variable "convert_to_template" {
  type = string
  default = "false"
}

variable "library_vm_destroy" {
  type = string
  default = "false"
}

variable "content_library_destination" {
  type = string
  default = "false"
}

variable "template_library_Name" {
  type = string
  default = "TemplateOS"
}

variable "ovf" {
  type = string
  default = "false"
}

variable "communicator" {
  type = string
  default = "ssh"
}

variable "winrm_timeout" {
  type = string
  default = "12h"
}
variable "winrm_port" {
  type = string
  default = "5985"
}
variable "ssh_timeout" {
  type = string
  default = "2h"
}
variable "ssh_clear_authorized_keys" {
  type = string
  default = "true"
}

variable "SSH_User" {
  type    = string
  default = "administrator"
}

variable "SSH_Pass" {
  type      = string
  sensitive = true
  default = ""
}

variable "winrm_User" { 
 type    = string
 default = "administrator"
}

variable "winrm_Pass" { 
 type    = string
 sensitive = true
 default = ""
}

variable "http_server" {
  default = ""  # Will be set by Packer when http_directory is used
}

variable "http_port" {
  default = ""  # Will be set by Packer when http_directory is used
}