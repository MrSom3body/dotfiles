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
        uwsm stop
    case Reboot
        systemctl reboot
    case Poweroff
        systemctl poweroff
    case Update
        hyprctl dispatch exec "[float; size 1000 600] xdg-terminal-exec -T 'NixOS Update' --app-id 'nix-snowflake' -- nh os switch -au"
end
