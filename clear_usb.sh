#!/bin/bash

#If a USB drive is present, do not initialize the samba share
USBDisk_Present=`sudo fdisk -l | grep /dev/sd`
if [ -n "${USBDisk_Present}" ]
then
    echo "Exited to due to presence of USB storage"
    echo "${USBDisk_Present}"
    exit
fi

echo "UDPBD-server is DOWN"
