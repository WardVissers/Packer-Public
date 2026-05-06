Dism /Image:D:\temp /Get-CurrentEdition

DISM /Mount-image /imagefile:d:\temp2\install.wim /index:2 /MountDir:d:\temp /readonly

Dism /Unmount-image /MountDir:d:\temp /Discard

