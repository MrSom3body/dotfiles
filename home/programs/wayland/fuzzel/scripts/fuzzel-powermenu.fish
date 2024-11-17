#!/usr/bin/env fish

set choices " Lock
 Suspend
󰿅 Exit
 Reboot
 Poweroff"
set choice (echo -en $choices | fuzzel -d -l 5)

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
end
