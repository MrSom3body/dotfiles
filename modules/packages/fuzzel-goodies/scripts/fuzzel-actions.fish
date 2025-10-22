#!/usr/bin/env fish

set choices " Lock
 Suspend
󰿅 Exit
 Reboot
 Poweroff
 Hibernate
󱄅 Update"
set choice (echo -en $choices | fuzzel --dmenu --placeholder "Search for system actions..." --lines 5)

switch (string split -f 2 " " $choice)
    case Lock
        loginctl lock-session
    case Suspend
        systemctl suspend
    case Exit
        uwsm stop
    case Reboot
        systemctl reboot
    case Poweroff
        systemctl poweroff
    case Hibernate
        systemctl hibernate
    case Update
        hyprctl dispatch exec "[float; size 1000 600] xdg-terminal-exec nh os switch -au"
end
