#!/bin/bash
#connecting to WPA networks requires software such as wpa_supplicant or nmcli
#I opted for nmcli as it is easier to use and installed in most distros by default

#gathers ssid and psk info from the user
read -p 'Please enter the primary ssid: ' ssid
read -p 'Please enter the key: ' key
read -p 'Please enter the secondary ssid: ' ssid2
read -p 'Please enter the key: ' key2

#connects to the wireless network using nmcli 
nmcli d wifi connect "$ssid" password "$key" 
sleep 5s #gives time to establish connection
#nmcli will sometimes change the name of connection, so nameconn verifies
nameconn="$(nmcli -t -f NAME c show --active)" 
ping -c 1 google.com #tests internet connectivity
if [ $? -eq 0 ] #if I can ping, then...
then
    sleep 5m #stay connected for 5 minutes
else #connects to the secondary network if primary fails
    nmcli d wifi connect "$ssid2" password "$key2" 
fi
nmcli con down "$nameconn" #then disconnect