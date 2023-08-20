$vcenter= read-host "What is the name of the vCenter"
connect-viserver $vcenter

[VMware.Vim.VirtualMachineGuestOsIdentifier].GetEnumValues()

Disconnect-VIServer * -Confirm:$false