#!/usr/bin/env -S fish --no-config

set MON (echo /sys/class/backlight/amdgpu_bl*/brightness)

# under which threshold wich kbd brightness should be used
set LOW 75
set MEDIUM 50
set HIGH 25

# start the monitor loop
function set_kbd_bl
    if test (cat "$MON") -lt $HIGH
        brightnessctl set -d "*::kbd_backlight" 3
    else if test (cat "$MON") -lt $MEDIUM
        brightnessctl set -d "*::kbd_backlight" 2
    else if test (cat "$MON") -lt $LOW
        brightnessctl set -d "*::kbd_backlight" 1
    else
        brightnessctl set -d "*::kbd_backlight" 0
    end
end

# initial run
set_kbd_bl

# event loop
while true
    set_kbd_bl

    # wait for the next power change event
    inotifywait -qq --event modify "$MON"
end
