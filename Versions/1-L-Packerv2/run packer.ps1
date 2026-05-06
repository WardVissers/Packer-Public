# Packer Build by Ward Vissers & Rick van Dijk

# Variables
switch ((get-host).Name) { 
    'Windows PowerShell ISE Host' { $packer_folder = $psISE.CurrentFile.FullPath -replace ($psISE.CurrentFile.DisplayName,"") }
    'ConsoleHost' { $packer_folder = $myInvocation.MyCommand.Path -replace ($myInvocation.MyCommand.Name,"")  }
    'Visual Studio Code Host'{ $packer_folder = $psEditor.GetEditorContext().CurrentFile.Path | Split-Path  }
}

# Go to the Packer folder
Set-Location $packer_folder

# Download Packer
.\Custom_scripts\Download_newest_Packer.ps1
# Download OpenSSL Light
.\Custom_scripts\Download_newest_OpenSSL_Light.ps1

#  Select vCenter en Select the Credentials
. ".\Custom_Scripts\Select_vCenter.ps1"
. ".\Custom_Scripts\Creds.ps1"

$password = Read-Host "Give the password for the image"
. ".\Custom_Scripts\Password_Images.ps1"

# Get local IP
$local_ip = (Get-NetIPConfiguration | Where-Object {$_.IPv4DefaultGateway -ne $null -and $_.InterfaceAlias -like "Eth*" }).IPv4Address.IPAddress

Write-Host "Packer is $local_version" -ForegroundColor Green

#  Nvidia GPU Driver Download
. ".\Custom_Scripts\Download_lastest_Nvidia_GPU_Driver.ps1"

# Images wil be build in the Templates folder under VM's and Templates 
# Images must manual clone to content-libary

# Packer build Windows 11 23H2
.\packer.exe validate -var-file "$($packer_folder)\Config_OS\Win11Ent\win11-23H2.pkrvars.hcl" -var-file $vCenter -var "local_ip=$local_ip" -var "vcenter_admin=$($vCenterCredentials.UserName)" -var "vcenter_password=$($vCenterCredentials.GetNetworkCredential().Password)" -var "winrm_Pass=$($password)" .\Config_HCL
.\packer.exe build -only="Windows11.vsphere-iso.Windows" -force -on-error=ask -var-file "$($packer_folder)\Config_OS\Win11Ent\win11-23H2.pkrvars.hcl" -var-file $vCenter -var "local_ip=$local_ip"  -var "vcenter_admin=$($vCenterCredentials.UserName)" -var "vcenter_password=$($vCenterCredentials.GetNetworkCredential().Password)" -var "winrm_Pass=$($password)" .\Config_HCL

# Packer build Windows 11 24H2
.\packer.exe validate -var-file "$($packer_folder)\Config_OS\Win11Ent\win11-24H2.pkrvars.hcl" -var-file $vCenter -var "local_ip=$local_ip" -var "vcenter_admin=$($vCenterCredentials.UserName)" -var "vcenter_password=$($vCenterCredentials.GetNetworkCredential().Password)" -var "winrm_Pass=$($password)" .\Config_HCL
.\packer.exe build -only="Windows11.vsphere-iso.Windows" -force -on-error=ask -var-file "$($packer_folder)\Config_OS\Win11Ent\win11-24H2.pkrvars.hcl" -var-file $vCenter -var "local_ip=$local_ip"  -var "vcenter_admin=$($vCenterCredentials.UserName)" -var "vcenter_password=$($vCenterCredentials.GetNetworkCredential().Password)" -var "winrm_Pass=$($password)" .\Config_HCL

# Packer build Windows 11 25H2
.\packer.exe validate -var-file "$($packer_folder)\Config_OS\Win11Ent\win11-25H2.pkrvars.hcl" -var-file $vCenter -var "local_ip=$local_ip" -var "vcenter_admin=$($vCenterCredentials.UserName)" -var "vcenter_password=$($vCenterCredentials.GetNetworkCredential().Password)" -var "winrm_Pass=$($password)" .\Config_HCL
.\packer.exe build -only="Windows11.vsphere-iso.Windows" -force -on-error=ask -var-file "$($packer_folder)\Config_OS\Win11Ent\win11-25H2.pkrvars.hcl" -var-file $vCenter -var "local_ip=$local_ip" -var "vcenter_admin=$($vCenterCredentials.UserName)" -var "vcenter_password=$($vCenterCredentials.GetNetworkCredential().Password)" -var "winrm_Pass=$($password)" .\Config_HCL

# Packer build Windows 11 24H2 vGPU Nvidia
.\packer.exe validate -var-file "$($packer_folder)\Config_OS\Win11Ent\win11-24H2-vgpu.pkrvars.hcl" -var-file $vCenter -var "local_ip=$local_ip" -var "vcenter_admin=$($vCenterCredentials.UserName)" -var "vcenter_password=$($vCenterCredentials.GetNetworkCredential().Password)" -var "winrm_Pass=$($password)" .\Config_HCL
.\packer.exe build -only="Windows11_vGPU.vsphere-iso.Windows" -force -on-error=ask -var-file "$($packer_folder)\Config_OS\Win11Ent\win11-24H2-vgpu.pkrvars.hcl" -var-file $vCenter -var "local_ip=$local_ip" -var "vcenter_admin=$($vCenterCredentials.UserName)" -var "vcenter_password=$($vCenterCredentials.GetNetworkCredential().Password)" -var "winrm_Pass=$($password)" .\Config_HCL

# Packer build Windows 11 25H2 vGPU Nvidia
.\packer.exe validate -var-file "$($packer_folder)\Config_OS\Win11Ent\win11-25H2-vgpu.pkrvars.hcl" -var-file $vCenter -var "local_ip=$local_ip" -var "vcenter_admin=$($vCenterCredentials.UserName)" -var "vcenter_password=$($vCenterCredentials.GetNetworkCredential().Password)" -var "winrm_Pass=$($password)" .\Config_HCL 
.\packer.exe build -only="Windows11_vGPU.vsphere-iso.Windows" -force -on-error=ask -var-file "$($packer_folder)\Config_OS\Win11Ent\win11-25H2-vgpu.pkrvars.hcl" -var-file $vCenter -var "local_ip=$local_ip" -var "vcenter_admin=$($vCenterCredentials.UserName)" -var "vcenter_password=$($vCenterCredentials.GetNetworkCredential().Password)" -var "winrm_Pass=$($password)" .\Config_HCL

# Packer build Server 2016
.\packer.exe validate -var-file "$($packer_folder)\Config_OS\WindowsServer\win2016-std.pkrvars.hcl" -var-file $vCenter -var "local_ip=$local_ip" -var "vcenter_admin=$($vCenterCredentials.UserName)" -var "vcenter_password=$($vCenterCredentials.GetNetworkCredential().Password)" -var "SSH_Pass=$($password)" .\Config_HCL
.\packer.exe build -only="Windows-ServerGeneral.vsphere-iso.Windows" -force -on-error=ask -var-file "$($packer_folder)\Config_OS\WindowsServer\win2016-std.pkrvars.hcl" -var-file $vCenter -var "local_ip=$local_ip" -var "vcenter_admin=$($vCenterCredentials.UserName)" -var "vcenter_password=$($vCenterCredentials.GetNetworkCredential().Password)" -var "SSH_Pass=$($password)" .\Config_HCL

# Packer build Server 2019
.\packer.exe validate -var-file "$($packer_folder)\Config_OS\WindowsServer\win2019-std.pkrvars.hcl" -var-file $vCenter -var "local_ip=$local_ip" -var "vcenter_admin=$($vCenterCredentials.UserName)" -var "vcenter_password=$($vCenterCredentials.GetNetworkCredential().Password)" -var "SSH_Pass=$($password)" .\Config_HCL
.\packer.exe build -only="Windows-ServerGeneral.vsphere-iso.Windows" -force -on-error=ask -var-file "$($packer_folder)\Config_OS\WindowsServer\win2019-std.pkrvars.hcl" -var-file $vCenter  -var "local_ip=$local_ip" -var "vcenter_admin=$($vCenterCredentials.UserName)" -var "vcenter_password=$($vCenterCredentials.GetNetworkCredential().Password)" -var "SSH_Pass=$($password)" .\Config_HCL

# Packer build Server 2022
.\packer.exe validate -var-file "$($packer_folder)\Config_OS\WindowsServer\win2022-std.pkrvars.hcl" -var-file $vCenter -var "local_ip=$local_ip" -var "vcenter_admin=$($vCenterCredentials.UserName)" -var "vcenter_password=$($vCenterCredentials.GetNetworkCredential().Password)" -var "SSH_Pass=$($password)" .\Config_HCL
.\packer.exe build -only="Windows-ServerGeneral.vsphere-iso.Windows" -force -on-error=ask -force -on-error=ask -var-file "$($packer_folder)\Config_OS\WindowsServer\win2022-std.pkrvars.hcl" -var-file $vCenter -var "local_ip=$local_ip" -var "vcenter_admin=$($vCenterCredentials.UserName)" -var "vcenter_password=$($vCenterCredentials.GetNetworkCredential().Password)" -var "SSH_Pass=$($password)" .\Config_HCL

# Packer build Server 2022 Core
.\packer.exe validate -var-file "$($packer_folder)\Config_OS\WindowsServer\win2022-std.core.pkrvars.hcl" -var-file $vCenter -var "local_ip=$local_ip" -var "vcenter_admin=$($vCenterCredentials.UserName)" -var "vcenter_password=$($vCenterCredentials.GetNetworkCredential().Password)" -var "SSH_Pass=$($password)" .\Config_HCL
.\packer.exe build -only="Windows-ServerCore.vsphere-iso.Windows" -force -on-error=ask -var-file "$($packer_folder)\Config_OS\WindowsServer\win2022-std.core.pkrvars.hcl" -var-file $vCenter -var "local_ip=$local_ip" -var "vcenter_admin=$($vCenterCredentials.UserName)" -var "vcenter_password=$($vCenterCredentials.GetNetworkCredential().Password)" -var "SSH_Pass=$($password)" .\Config_HCL

# Packer build Server 2025
.\packer.exe validate -var-file "$($packer_folder)\Config_OS\WindowsServer\win2025-std.pkrvars.hcl" -var-file $vCenter -var "local_ip=$local_ip" -var "vcenter_admin=$($vCenterCredentials.UserName)" -var "vcenter_password=$($vCenterCredentials.GetNetworkCredential().Password)"  -var "SSH_Pass=$($password)" .\Config_HCL
.\packer.exe build -only="Windows-ServerGeneral.vsphere-iso.Windows" -force -on-error=ask -var-file "$($packer_folder)\Config_OS\WindowsServer\win2025-std.pkrvars.hcl" -var-file $vCenter -var "local_ip=$local_ip" -var "vcenter_admin=$($vCenterCredentials.UserName)" -var "vcenter_password=$($vCenterCredentials.GetNetworkCredential().Password)" -var "SSH_Pass=$($password)" .\Config_HCL

# Packer build Server 2025 vGPU
.\packer.exe validate -var-file "$($packer_folder)\Config_OS\WindowsServer\win2025-std-vgpu.pkrvars.hcl" -var-file $vCenter -var "local_ip=$local_ip" -var "vcenter_admin=$($vCenterCredentials.UserName)" -var "vcenter_password=$($vCenterCredentials.GetNetworkCredential().Password)" -var "SSH_Pass=$($password)" .\Config_HCL
.\packer.exe build -only="Windows-ServerGeneral_vGPU.vsphere-iso.Windows" -force -on-error=ask -var-file "$($packer_folder)\Config_OS\WindowsServer\win2025-std-vgpu.pkrvars.hcl" -var-file $vCenter -var "local_ip=$local_ip" -var "vcenter_admin=$($vCenterCredentials.UserName)" -var "vcenter_password=$($vCenterCredentials.GetNetworkCredential().Password)" -var "SSH_Pass=$($password)" .\Config_HCL

# Packer build Server 2025 Core
.\packer.exe validate -var-file "$($packer_folder)\Config_OS\WindowsServer\win2025-std.core.pkrvars.hcl" -var-file $vCenter -var "local_ip=$local_ip" -var "vcenter_admin=$($vCenterCredentials.UserName)" -var "vcenter_password=$($vCenterCredentials.GetNetworkCredential().Password)" -var "SSH_Pass=$($password)" .\Config_HCL
.\packer.exe build -only="Windows-ServerCore.vsphere-iso.Windows" -force -on-error=ask -var-file "$($packer_folder)\Config_OS\WindowsServer\win2025-std.core.pkrvars.hcl" -var-file $vCenter -var "local_ip=$local_ip" -var "vcenter_admin=$($vCenterCredentials.UserName)" -var "vcenter_password=$($vCenterCredentials.GetNetworkCredential().Password)" -var "SSH_Pass=$($password)" .\Config_HCL

# Packer build Server 2025 Core FOD
.\packer.exe validate -var-file "$($packer_folder)\Config_OS\WindowsServer\win2025-std.corefod.pkrvars.hcl" -var-file $vCenter -var "local_ip=$local_ip" -var "vcenter_admin=$($vCenterCredentials.UserName)" -var "vcenter_password=$($vCenterCredentials.GetNetworkCredential().Password)" -var "SSH_Pass=$($password)" .\Config_HCL
.\packer.exe build -only="Windows-ServerCoreFod.vsphere-iso.Windows" -force -on-error=ask -var-file "$($packer_folder)\Config_OS\WindowsServer\win2025-std.corefod.pkrvars.hcl" -var-file $vCenter -var "local_ip=$local_ip" -var "vcenter_admin=$($vCenterCredentials.UserName)" -var "vcenter_password=$($vCenterCredentials.GetNetworkCredential().Password)" -var "SSH_Pass=$($password)" .\Config_HCL

# Packer build Ubuntu
#done - Hardcoded creds in
#Config_OS\Ubuntu\Ubuntu.pkrvars.hcl
#Config_OS\Ubuntu\http\user-data
.\packer.exe validate -var-file "$($packer_folder)\Config_OS\Ubuntu\Ubuntu.pkrvars.hcl" -var-file $vCenter -var "local_ip=$local_ip" -var "vcenter_admin=$($vCenterCredentials.UserName)" -var "vcenter_password=$($vCenterCredentials.GetNetworkCredential().Password)" -var "SSH_Pass=$password" .\Config_HCL
.\packer.exe build -only="Ubuntu.vsphere-iso.linux-ubuntu" -force -on-error=ask -var-file "$($packer_folder)\Config_OS\Ubuntu\Ubuntu.pkrvars.hcl" -var-file $vCenter -var "local_ip=$local_ip" -var "vcenter_admin=$($vCenterCredentials.UserName)" -var "vcenter_password=$($vCenterCredentials.GetNetworkCredential().Password)" -var "SSH_Pass=$password" .\Config_HCL 

# Packer build Ubuntu vGPU Nvidia
#done - Hardcoded creds in
#Config_OS\Ubuntu\Ubuntu.pkrvars.hcl
#Config_OS\Ubuntu\http\user-data
.\packer.exe validate -var-file "$($packer_folder)\Config_OS\Ubuntu\Ubuntu.pkrvars.hcl" -var-file $vCenter -var "local_ip=$local_ip" -var "vcenter_admin=$($vCenterCredentials.UserName)" -var "vcenter_password=$($vCenterCredentials.GetNetworkCredential().Password)" -var "vgpu_driver=$Ubuntu_Nvidia_Driver" -var "SSH_Pass=$password" .\Config_HCL
.\packer.exe build -only="Ubuntu_vGPU.vsphere-iso.linux-ubuntu" -force -on-error=ask -var-file "$($packer_folder)\Config_OS\Ubuntu\Ubuntu.pkrvars.hcl" -var-file $vCenter -var "local_ip=$local_ip" -var "vcenter_admin=$($vCenterCredentials.UserName)" -var "vcenter_password=$($vCenterCredentials.GetNetworkCredential().Password)" -var "vgpu_driver=$Ubuntu_Nvidia_Driver" -var "SSH_Pass=$password" .\Config_HCL 

