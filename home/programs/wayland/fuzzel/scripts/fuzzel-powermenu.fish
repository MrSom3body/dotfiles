#!/usr/bin/env fish

set choices " Lock
 Suspend
󰿅 Exit
 Reboot
 Poweroff
󱄅 Update"
set choice (echo -en $choices | fuzzel --dmenu --prompt " " --placeholder "Search for system actions..." --lines 5)

switch (string split -f 2 " " $choice)
    case Lock
        uwsm app -- hyprlock
    case Suspend
        systemctl suspend
    case Exit
        pkill Hyprland
    case Reboot
        systemctl reboot
    case Poweroff
        systemctl poweroff
    case Update
        hyprctl dispatch exec [floating\; size 1000 600] kitty -- nh os switch -au
end
