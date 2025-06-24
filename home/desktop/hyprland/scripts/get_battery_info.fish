#!/usr/bin/env fish

set battery (cat /sys/class/power_supply/BAT*/capacity)
set battery_status (cat /sys/class/power_supply/BAT*/status)

set charging_icons 󰢜 󰂆 󰂇 󰂈 󰢝 󰂉 󰢞 󰂊 󰂋 󰂅
set discharging_icons 󰁺 󰁻 󰁼 󰁽 󰁾 󰁿 󰂀 󰂁 󰂂 󰁹

set icon (math round\($battery/10\))

if test $battery_status = Full
    echo "$charging_icons[10] Battery full"
else if test $battery_status = Discharging
    echo "$discharging_icons[$icon] Discharging $battery%"
else if test $battery_status = "Not charging"
    echo "$charging_icons[$icon] Battery charged"
else
    echo "$charging_icons[$icon] Charging $battery%"
end
