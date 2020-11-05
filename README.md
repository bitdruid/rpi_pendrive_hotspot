# usb, wifi and hotspot automation for raspberry-pi (portable pendrive-reader)

approved with RPI 4B

The scripts are made for a simple wifi-connection and an easy way to get (samba) access to pendrives even without a display. With the hotspot scripts you can connect to your raspberry from anywhere just by starting it up and create a Startscript or cronjob for the hotspot to come up.

Wifi control is completly given to the scripts. Predictable network interface names are activated. Partial use is not possible. Or by modifying manually.

### disclaimer
ONLY use this if you want to give complete network control to command-line. Network-managers will no longer work. Stored networks may be lost!!!

Yes i know there are some security-vulnerabilities but as this scripts are for my very simple-private use and i prefered to make them *as-simple-as*. However if some parts of the code or the whole idea would be usefull for you let me know.

### used packages
- dnsmasq
- hostapd
- dhcpcd
- nmap
- samba

## install and uninstall
run install_dependencies.sh and install.sh

```
[Service]
MountFlags=shared
```
is added to ```/lib/systemd/system/systemd-udevd.service``` for automount-script to work properly

IMPORTANT:
The script will use predictable network interface names and automatically activate them.

## wifi
Command for easy wifi-connection. This will only work with the ```dhcpcd@.service```
This is an interface-specified version of the ```dhcpcd.service``` and not delivered by raspbian.
The file will be placed at
```
/lib/systemd/system/dhcpcd@.service
```

## automount
Automatically mount a plugged pendrive. The script will generate a mountpoint in ```/media/share```
This folder will be removed after device is unplugged and the folder is empty. 
The udev-rule ```85-automount.rules```is absolutely neccessary.

will be placed at
```/etc/udev/rules.d/```

Adding ```sudo service udev restart``` @reboot (e.g. crontab) may help if it wont work on startup.

## wpamod
Was just usefull because sometimes wpa_supplicant needs to be disabled.

## hotspot
Generates an access-point with the raspberry. The script will also start samba-sharing.
I'm use it with the automount-script. This will transform the raspberry to a portable pendrive-reader. 
You can connect via hotspot and access any pendrive without the need of I/O (keyboard, display, etc.)
This script will only work if you already configured:
- dnsmasq
- hostapd
- samba

for samba-share of the automount-folder configure your smb.conf something like (default smb.conf for script):
```
[piUSB]
path = /media/share/
force user = nobody
public = yes
writable = yes
read only = no
guest ok = yes
create mode = 0777
directory mode = 0777
```
Modes are set because every hotspot-user should be able to access and edit the files. Change this to any.
