#!/bin/bash

#
# psx-pi-smbshare setup script
#
# *What it does*
# This script will install and configure an smb share at /share
# It will also compile ps3netsrv from source to allow operability with PS3/Multiman
# It also configures the pi ethernet port to act as dhcp server for connected devices and allows those connections to route through wifi on wlan0
# Finally, XLink Kai is installed for online play.
#
# *More about the network configuration*
# This configuration provides an ethernet connected PS2 or PS3 a low-latency connection to the smb share running on the raspberry pi
# The configuration also allows for outbound access from the PS2 or PS3 if wifi is configured on the pi
# This setup should work fine out the box with OPL and multiman
# Per default configuration, the smbserver is accessible on 192.168.2.1


USER=`whoami`

# Make sure we're not root otherwise the paths will be wrong
if [ $USER = "root" ]; then
  echo "Do not run this script as root or with sudo"
  exit 1
fi

# Update packages
sudo apt-get -y update
sudo apt-get -y upgrade

# Ensure basic tools are present
sudo apt-get -y install screen wget git curl coreutils

# Install and configure Samba
sudo apt-get install -y samba samba-common-bin
wget https://raw.githubusercontent.com/4gordi/udpbd-server/main/clear_usb.sh -O /home/${USER}/clear_usb.sh
chmod 755 /home/${USER}/clear_usb.sh
sudo cp /home/${USER}/clear_usb.sh /usr/local/bin
sudo mkdir -m 1777 /share

# Install wifi-to-eth route settings
#sudo apt-get install -y dnsmasq
#wget https://raw.githubusercontent.com/4gordi/psx-pi-smbshare/master/wifi-to-eth-route.sh -O /home/${USER}/wifi-to-eth-route.sh
#chmod 755 /home/${USER}/wifi-to-eth-route.sh

# Install USB automount settings
wget https://raw.githubusercontent.com/4gordi/udpbd-server/main/automount-usb.sh -O /home/${USER}/automount-usb.sh
chmod 755 /home/${USER}/automount-usb.sh
sudo /home/${USER}/automount-usb.sh

# Set samba-init + ps3netsrv, wifi-to-eth-route, setup-wifi-access-point, and XLink Kai to run on startup
# { echo -e "@reboot sudo bash /usr/local/bin/samba-init.sh\n@reboot sudo bash /home/${USER}/wifi-to-eth-route.sh"; } | crontab -u pi -
{ echo -e "@reboot sudo bash /usr/local/bin/clear_usb.sh"; } | crontab -u pi -

# Start services
sudo /usr/local/bin/clear_usb.sh
#sudo /home/${USER}/wifi-to-eth-route.sh

# Not a bad idea to reboot
sudo reboot
