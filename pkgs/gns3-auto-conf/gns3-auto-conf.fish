#!/usr/bin/env -S fish --no-config

set topology (ls ~/GNS3/projects | fzf --header "Select a GNS3 Project")

mkdir $topology >/dev/null

read -P "Domain: " domain
read -P "Username: " user
read -P "Password: " password

for device in (cat ~/GNS3/projects/$topology/*.gns3 | jq '.topology | .nodes | .[] | .name')
    set device (string trim $device -c \")
    set devicePath $topology/$device
    if test -f $devicePath
        echo "Config for $device exists -> skipping"
    end

    echo "Creating config for $device..."
    printf "\
en
conf t
hostname $device
no banner *
no ip domain lookup
ip domain name $domain

crypto key gen rsa usa mod 1024
ip ssh version 2

username $user algo scry secret $password
username $user priv 15

line con 0
login local
logging sync
exec-timeout 0

line vty 0 1500
login local
logging sync
exec-timeout 0
transport input telnet ssh
" >$devicePath
end
