# Variables
$downloadfolder = 'd:\packer\'


# Go to the Packer download folder
Set-Location $downloadfolder

# Show Packer Version
.\packer.exe -v

# Download Packer plugins
.\packer.exe init "${downloadfolder}basis.pkr.hcl"

# Validate 
.\packer.exe validate "${downloadfolder}windows2016.json.pkr.hcl"
.\packer.exe validate "${downloadfolder}windows2019.json.pkr.hcl"
.\packer.exe validate "${downloadfolder}windows2022.json.pkr.hcl"
.\packer.exe validate "${downloadfolder}windows2022core.json.pkr.hcl"
.\packer.exe validate "${downloadfolder}windows2022corefed.json.pkr.hcl"

# Packer build Server 2022Core with FED
.\packer.exe build -force -var-file="${downloadfolder}windowsserver2022corefed.auto.pkrvars.hcl" "${downloadfolder}windows2022corefed.json.pkr.hcl"

# Packer build Server 2022Core
.\packer.exe build -force -var-file="${downloadfolder}windowsserver2022core.auto.pkrvars.hcl" "${downloadfolder}windows2022core.json.pkr.hcl"

# Packer build Server 2022
.\packer.exe build -force -var-file="${downloadfolder}windowsserver2022.auto.pkrvars.hcl" "${downloadfolder}windows2022.json.pkr.hcl"

# Packer build Server 2019
.\packer.exe build -force -var-file="${downloadfolder}windowsserver2019.auto.pkrvars.hcl" "${downloadfolder}windows2019.json.pkr.hcl"

# Packer build Server 2016
.\packer.exe build -force -var-file="${downloadfolder}windowsserver2016.auto.pkrvars.hcl" "${downloadfolder}windows2016.json.pkr.hcl"

