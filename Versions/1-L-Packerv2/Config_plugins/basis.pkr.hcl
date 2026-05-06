packer {
 
  required_plugins {
    vsphere = {
      version = ">= 2.0.0"
      source  = "github.com/hashicorp/vsphere"
    }
  }


  required_plugins {
    windows-update = {
      version = ">= 0.16.8"
      source  = "github.com/rgl/windows-update"
    }
  }

    required_plugins {
    qemu = {
      version = "~> 1"
      source  = "github.com/hashicorp/qemu"
    }
  }
}