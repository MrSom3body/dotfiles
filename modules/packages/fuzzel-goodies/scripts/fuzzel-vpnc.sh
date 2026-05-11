#!/usr/bin/env bash

if pgrep vpnc &>/dev/null; then
    selection=$(printf "yes\nno" | fuzzel --dmenu --placeholder "Do you want to disconnect from the current VPN?")
    case "$selection" in
        yes) pkexec vpnc-disconnect ;;
        no)  notify-send -a vpnc "Disconnecting cancelled" ;;
    esac
else
    selections=""
    for file in /etc/vpnc/*; do
        name=$(basename "$file" .conf)
        selections="$name\n$selections"
    done

    selection=$(printf "%b" "$selections" | fuzzel --dmenu --placeholder "Search for vpnc VPNs...")

    if [[ -n "$selection" ]]; then
        pkexec vpnc "$selection" &&
            notify-send -a vpnc "Connected successfully to $selection" ||
            notify-send -a vpnc "Could not connect to $selection"
    fi

    if pgrep vpnc &>/dev/null; then
        pidwait vpnc
        notify-send -a vpnc "Disconnected from $selection"
    fi
fi
