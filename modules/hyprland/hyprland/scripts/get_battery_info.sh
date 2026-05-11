#!/usr/bin/env bash

battery=$(cat /sys/class/power_supply/BAT*/capacity)
battery_status=$(cat /sys/class/power_supply/BAT*/status)

charging_icons=("󰢜" "󰂆" "󰂇" "󰂈" "󰢝" "󰂉" "󰢞" "󰂊" "󰂋" "󰂅")
discharging_icons=("󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹")

icon=$(( (battery + 5) / 10 - 1 ))
(( icon > 9 )) && icon=9
(( icon < 0 )) && icon=0

if [[ "$battery_status" == Full ]]; then
    echo "${charging_icons[-1]} Battery full"
elif [[ "$battery_status" == Discharging ]]; then
    echo "${discharging_icons[$icon]} Discharging $battery%"
elif [[ "$battery_status" == "Not charging" ]]; then
    echo "${charging_icons[$icon]} Battery charged"
else
    echo "${charging_icons[$icon]} Charging $battery%"
fi
