#!/usr/bin/env bash

dmenu() {
    vicinae dmenu -n "VPNC Connections" "$@"
}

if pgrep vpnc &>/dev/null; then
    selection=$(printf "yes\nno" | dmenu -p "Do you want to disconnect from the current VPN?")
    case "$selection" in
        yes) pkexec vpnc-disconnect ;;
        no)  notify-send -a vpnc "Disconnecting cancelled" ;;
    esac
else
    selections=()
    for file in /etc/vpnc/*; do
        selections+=("$(basename "$file" .conf)")
    done

    selection=$(printf "%s\n" "${selections[@]}" | dmenu -s "VPNs ({count})" -p "Search for vpnc VPNs...")

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
