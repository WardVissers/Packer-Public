# Copyright 2023-2024 Broadcom. All rights reserved.
# SPDX-License-Identifier: BSD-2

/*
    DESCRIPTION:
    VMware vSphere variables used for all builds.
    - Variables are use by the source blocks.
*/

// vSphere Credentials
vsphere_insecure_connection = true

// vSphere Settings

# vCenter Server / ESXi 
vcenter_host       = "<yourvcenter>"
vcenter_cluster    = "<yourcluster>"
vcenter_datastore  = "<datastore>"
host               = "<host>"
vcenter_network    = "<default_management>"
vcenter_folder     = "Templates"

# datastore
datastore_iso = "[Lun01] "
datastore_iso_path = "ISO/"