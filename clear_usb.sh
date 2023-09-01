#!/bin/bash

#If a USB drive is present, do not initialize the samba share
USBDisk_Present=`sudo fdisk -l | grep /dev/sd`
if [ -n "${USBDisk_Present}" ]
then
    echo "exited to due to presence of USB storage"
    exit
fi

echo "UDPBD-server is DOWN"
printf "UDPBD-server is DOWN"
