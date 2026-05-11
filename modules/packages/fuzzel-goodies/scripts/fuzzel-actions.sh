#!/usr/bin/env bash

choices=" Lock
 Suspend
󰿅 Exit
 Reboot
 Poweroff
 Hibernate
󱄅 Update"

choice=$(echo -en "$choices" | fuzzel --dmenu --placeholder "Search for system actions..." --lines 5)
action=$(echo "$choice" | awk '{print $2}')

case "$action" in
    Lock)      loginctl lock-session ;;
    Suspend)   systemctl suspend ;;
    Exit)      uwsm stop ;;
    Reboot)    systemctl reboot ;;
    Poweroff)  systemctl poweroff ;;
    Hibernate) systemctl hibernate ;;
    Update)    hyprctl dispatch exec "[float; size 1000 600] xdg-terminal-exec nh os switch -au" ;;
esac
