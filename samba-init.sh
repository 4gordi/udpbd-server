#!/bin/bash

#If a USB drive is present, do not initialize the samba share
USBDisk_Present=`sudo fdisk -l | grep /dev/sd`
if [ -n "${USBDisk_Present}" ]
then
    echo "exited to due to presence of USB storage"
    exit
fi

sudo cat <<'EOF' | sudo tee /etc/samba/smb.conf
[global]
server min protocol = NT1
workgroup = WORKGROUP
usershare allow guests = yes
map to guest = bad user
allow insecure wide links = yes
[share]
Comment = Pi shared folder
Path = /share
Browseable = yes
Writeable = Yes
only guest = no
create mask = 0777
directory mask = 0777
Public = yes
Guest ok = yes
force user = pi
follow symlinks = yes
wide links = yes
EOF

#if you wish to create a samba user with password you can use the following:
#sudo smbpasswd -a pi
sudo /etc/init.d/smbd restart
