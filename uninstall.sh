#!/bin/bash

sudo wpamod -enable
sudo systemctl disable hotspot.service
sudo systemctl enable --now dhcpcd.service
sudo systemctl enable --now dnsmasq.service
sudo systemctl disable --now hostapd.service
sudo systemctl disable wpa_supplicant@wlan0
sudo systemctl disable tor

#remove scripts
sudo rm /usr/bin/hotspot
sudo rm /usr/bin/wifi
sudo rm /usr/bin/wpamod
sudo rm /usr/bin/automount
sudo rm /usr/bin/logclean
sudo rm /usr/bin/tormod

#configs, services and rules
sudo rm /etc/systemd/system/hotspot.service
sudo rm /etc/udev/rules.d/85-automount.rules
sudo rm /lib/systemd/system/dhcpcd@.service
sudo rm /lib/systemd/system/automount@.service
sudo mv /etc/samba/smb.conf.bak /etc/samba/smb.conf
sudo rm /etc/hostapd/hostapd.conf
sudo rm /etc/dnsmasq.conf

#predictable network interface names
if [[ -L /etc/udev/rules.d/80-net-setup-link.rules ]]; then
    sudo unlink /etc/udev/rules.d/80-net-setup-link.rules
fi

#remove udevrule modification
sudo sed -e s/MountFlags=shared//g -i.bak /lib/systemd/system/systemd-udevd.service
udevadm control --reload-rules && udevadm trigger

#remove interface-specified wpa_supplicant.conf
rm /etc/wpa_supplicant/wpa_supplicant-*.conf


