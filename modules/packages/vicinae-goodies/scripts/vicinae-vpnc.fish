#!/usr/bin/env fish

function dmenu
    vicinae dmenu -n "VPNC Connections" $argv
end

if pgrep vpnc &>/dev/null
    set selection (echo -en "yes\nno" | dmenu -p "Do you want to disconnect from the currenct VPN?")
    switch $selection
        case yes
            pkexec vpnc-disconnect
        case no
            notify-send -a vpnc "Disconnecting cancelled"
    end
else
    set selections ()
    for file in /etc/vpnc/*
        set -a selections (basename $file .conf)
    end

    set selection (string join \n $selections | dmenu -s "VPNs ({count})" -p "Search for vpnc VPNs...")

    if test "$selection" != ""
        pkexec vpnc $selection &&
            notify-send -a vpnc "Connected successfully to $selection" ||
            notify-send -a vpnc "Could not connect to $selection"
    end

    waitpid (pgrep vpnc) &&
        notify-send -a vpnc "Disconnected from $selection"
end
