#!/usr/bin/env -S fish --no-config

# copied and modified to a fish script from @fufexan

set BAT (echo /sys/class/power_supply/BAT*)
set BAT_STATUS "$BAT/status"
set BAT_CAP "$BAT/capacity"

set AC_PROFILE performance
set BAT_PROFILE power-saver

# wait a while if needed
if test -n "$STARTUP_WAIT"
    sleep $STARTUP_WAIT
end

# start the monitor loop
set currentStatus (cat "$BAT_STATUS")
set prevProfile $AC_PROFILE
set prevStatus Charging

# initial run
echo >$XDG_RUNTIME_DIR/battery
if test "$currentStatus" = Discharging
    set profile $BAT_PROFILE
else
    set profile $AC_PROFILE
end

# set the initial profile
echo "setting power profile to $profile"
powerprofilesctl set $profile

set prevProfile $profile
set prevStatus $currentStatus

# event loop
while true
    set currentStatus (cat "$BAT_STATUS")
    if test "$currentStatus" != "$prevStatus"
        if test "$currentStatus" = Discharging
            set profile $BAT_PROFILE
        else
            set profile $AC_PROFILE
        end

        if test "$prevProfile" != "$profile"
            echo "setting power profile to $profile"
            powerprofilesctl set $profile &&
                notify-send -a power-monitor "Switched power-profiles mode" "Now on $profile mode"
        end

        set prevProfile $profile
        set prevStatus $currentStatus
    end

    set currentCapacity (cat "$BAT_CAP")
    if test $currentCapacity -gt 30
        echo >$XDG_RUNTIME_DIR/battery
    else
        if test $currentCapacity -le 10
            test (cat $XDG_RUNTIME_DIR/battery) != 10 &&
                notify-send -a power-monitor -u critical "Battery Critical" "Battery level is at 10%! Plug in immediately!"
            echo 10 >$XDG_RUNTIME_DIR/battery
        else if test $currentCapacity -le 20
            test (cat $XDG_RUNTIME_DIR/battery) != 20 &&
                notify-send -a power-monitor -u critical "Battery Very Low" "Battery level is at 20%"
            echo 20 >$XDG_RUNTIME_DIR/battery
        else if test $currentCapacity -le 30
            test (cat $XDG_RUNTIME_DIR/battery) != 30 &&
                notify-send -a power-monitor -u critical "Battery Low" "Battery level is at 30%"
            echo 30 >$XDG_RUNTIME_DIR/battery
        end
    end

    # wait for the next power change event
    inotifywait -qq "$BAT_STATUS" "$BAT_CAP"
end
