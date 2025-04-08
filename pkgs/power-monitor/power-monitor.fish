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

    # wait for the next power change event
    inotifywait -qq "$BAT_STATUS" "$BAT_CAP"
end
