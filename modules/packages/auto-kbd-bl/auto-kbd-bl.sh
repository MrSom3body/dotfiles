#!/usr/bin/env bash

MON=$(echo /sys/class/backlight/amdgpu_bl*/brightness)

# under which threshold which kbd brightness should be used
LOW=75
MEDIUM=50
HIGH=25

set_kbd_bl() {
    if [[ $(cat "$MON") -lt $HIGH ]]; then
        brightnessctl set -d "*::kbd_backlight" 3
    elif [[ $(cat "$MON") -lt $MEDIUM ]]; then
        brightnessctl set -d "*::kbd_backlight" 2
    elif [[ $(cat "$MON") -lt $LOW ]]; then
        brightnessctl set -d "*::kbd_backlight" 1
    else
        brightnessctl set -d "*::kbd_backlight" 0
    fi
}

set_kbd_bl

while true; do
    pgrep hyprlock > /dev/null || set_kbd_bl
    inotifywait -qq --event modify "$MON"
done
