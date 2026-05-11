#!/usr/bin/env bash

topology=$(ls ~/GNS3/projects | fzf --header "Select a GNS3 Project")

mkdir -p "$topology"

read -rp "Domain: " domain
read -rp "Username: " user
read -rp "Password: " password

while IFS= read -r device; do
    device="${device#\"}"
    device="${device%\"}"
    devicePath="$topology/$device"
    if [[ -f "$devicePath" ]]; then
        echo "Config for $device exists -> skipping"
        continue
    fi

    echo "Creating config for $device..."
    printf "\
en
conf t
hostname %s
no banner *
no ip domain lookup
ip domain name %s

crypto key gen rsa usa mod 1024
ip ssh version 2

username %s algo scry secret %s
username %s priv 15

line con 0
login local
logging sync
exec-timeout 0

line vty 0 1500
login local
logging sync
exec-timeout 0
transport input telnet ssh
" "$device" "$domain" "$user" "$password" "$user" > "$devicePath"
done < <(cat ~/GNS3/projects/"$topology"/*.gns3 | jq '.topology | .nodes | .[] | .name')
