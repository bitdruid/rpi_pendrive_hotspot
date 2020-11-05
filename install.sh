#!/bin/bash

#rules
chown -R root:root *
chmod 0755 command/* 
chmod 0644 config/* systemd/* udev/*

#command scripts
sudo cp command/hotspot /usr/bin/hotspot
sudo cp command/wifi /usr/bin/wifi
sudo cp command/wpamod /usr/bin/wpamod
sudo cp command/automount /usr/bin/automount
sudo cp command/logclean /usr/bin/logclean

#add decision: will overwrite following files: proceed?
#configs, services and rules
sudo cp systemd/hotspot.service /etc/systemd/system
sudo cp udev/85-automount.rules /etc/udev/rules.d
sudo cp systemd/dhcpcd@.service /lib/systemd/system
sudo cp systemd/automount@.service /lib/systemd/system
if ! [ -f /etc/samba/smb.conf ]; then
    sudo mv /etc/samba/smb.conf /etc/samba/smb.conf.bak
fi
sudo cp config/smb.conf /etc/samba/smb.conf
sudo cp config/hostapd.conf /etc/hostapd/hostapd.conf
sudo cp config/dnsmasq.conf /etc/dnsmasq.conf

#predictable network interface names
if [[ ! -L /etc/udev/rules.d/80-net-setup-link.rules ]]; then
    sudo ln -s /dev/null /etc/udev/rules.d/80-net-setup-link.rules
fi

#prepare udevrule
if ! [[ $(grep -o "MountFlags=shared" /lib/systemd/system/systemd-udevd.service) ]]; then
    sudo bash -c 'echo "MountFlags=shared" >> /lib/systemd/system/systemd-udevd.service'
    udevadm control --reload-rules && udevadm trigger
fi

#prepare wpa_supplicant
if [ ! -f /etc/wpa_supplicant.conf ]; then
    cp misc/wpa_supplicant.conf /etc/wpa_supplicant/
fi
sudo cp /etc/wpa_supplicant/wpa_supplicant.conf /etc/wpa_supplicant/wpa_supplicant-wlan0.conf

#prepare services
sudo systemctl unmask hostapd.service
sudo wpamod -disable
sudo systemctl enable hotspot.service
sudo systemctl disable --now dhcpcd.service
sudo systemctl disable --now dnsmasq.service
sudo systemctl disable --now hostapd.service
