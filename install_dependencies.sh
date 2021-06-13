#!/bin/bash

#just install all required packages

installer()
{
	sudo apt-get update
	sudo apt-get install samba hostapd dnsmasq nmap dhcpcd5 tor
}

echo 'This will install:'
echo '-samba'
echo '-hostapd'
echo '-dnsmasq'
echo '-nmap'
echo '-dhcpcd5'
echo '-tor'
echo ''
read -p 'proceed? (y/n)' selection
echo ''

case $selection in
	y|Y)	installer ;;
	n|N) 	echo 'aborting...' ;;
	*)	echo 'unknown input. aborting...' ;;
esac
