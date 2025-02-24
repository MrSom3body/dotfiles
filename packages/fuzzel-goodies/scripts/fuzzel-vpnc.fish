#!/usr/bin/env fish

if pgrep vpnc &>/dev/null
    set selection (echo -en "yes\nno" | fuzzel --dmenu --prompt "󰖂 " --placeholder "Do you want to disconnect from the currenct VPN?")
    switch $selection
        case yes
            pkexec vpnc-disconnect
            notify-send -a vpnc "VPN disconnected"
        case no
            notify-send -a vpnc "Disconnecting cancelled"
    end
else
    for file in (fd ".*" /etc/vpnc/)
        set selections "$(basename $file .conf)\n$selections"
    end

    set selection (echo -en $selections | fuzzel --dmenu --prompt "󰖂 " --placeholder "Search for vpnc VPNs...")

    if test "$selection" != ""
        pkexec vpnc $selection &&
            notify-send -a vpnc "Connected successfully to $selection" ||
            notify-send -a vpnc "Could not connect to $selection"
    end
end
