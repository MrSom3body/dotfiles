#!/usr/bin/env bash

# copied and modified from @fufexan

BAT=$(echo /sys/class/power_supply/BAT*)
BAT_STATUS="$BAT/status"
BAT_CAP="$BAT/capacity"

AC_PROFILE=performance
BAT_PROFILE=power-saver

if [[ -n "$STARTUP_WAIT" ]]; then
    sleep "$STARTUP_WAIT"
fi

currentStatus=$(cat "$BAT_STATUS")

echo > "$XDG_RUNTIME_DIR/battery"
if [[ "$currentStatus" == Discharging ]]; then
    profile=$BAT_PROFILE
else
    profile=$AC_PROFILE
fi

echo "setting power profile to $profile"
powerprofilesctl set "$profile"

prevProfile=$profile
prevStatus=$currentStatus

while true; do
    currentStatus=$(cat "$BAT_STATUS")
    if [[ "$currentStatus" != "$prevStatus" ]]; then
        if [[ "$currentStatus" == Discharging ]]; then
            profile=$BAT_PROFILE
        else
            profile=$AC_PROFILE
        fi

        if [[ "$prevProfile" != "$profile" ]]; then
            echo "setting power profile to $profile"
            powerprofilesctl set "$profile" &&
                notify-send -a power-monitor "Switched power-profiles mode" "Now on $profile mode"
        fi

        prevProfile=$profile
        prevStatus=$currentStatus
    fi

    currentCapacity=$(cat "$BAT_CAP")

    if [[ "$currentStatus" == Discharging ]]; then
        if [[ $currentCapacity -le 10 ]]; then
            [[ $(cat "$XDG_RUNTIME_DIR/battery") != 10 ]] &&
                notify-send -a power-monitor -u critical "Battery Critical" "Battery level is at 10%! Plug in immediately!"
            echo 10 > "$XDG_RUNTIME_DIR/battery"
        elif [[ $currentCapacity -le 20 ]]; then
            [[ $(cat "$XDG_RUNTIME_DIR/battery") != 20 ]] &&
                notify-send -a power-monitor -u critical "Battery Very Low" "Battery level is at 20%"
            echo 20 > "$XDG_RUNTIME_DIR/battery"
        elif [[ $currentCapacity -le 30 ]]; then
            [[ $(cat "$XDG_RUNTIME_DIR/battery") != 30 ]] &&
                notify-send -a power-monitor -u critical "Battery Low" "Battery level is at 30%"
            echo 30 > "$XDG_RUNTIME_DIR/battery"
        fi
    else
        echo > "$XDG_RUNTIME_DIR/battery"
    fi

    inotifywait -qq "$BAT_STATUS" "$BAT_CAP"
done
