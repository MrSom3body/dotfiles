#!/bin/fish

set ACTIVE_OPACITY_PREV (hyprctl getoption "decoration:active_opacity" -j | jq .float)
set INACTIVE_OPACITY_PREV (hyprctl getoption "decoration:inactive_opacity" -j | jq .float)

hyprctl --batch "keyword decoration:active_opacity 1; keyword decoration:inactive_opacity 1"
sleep 0.5
hyprpicker -a; and hyprctl --batch "keyword decoration:active_opacity $ACTIVE_OPACITY_PREV; keyword decoration:inactive_opacity $INACTIVE_OPACITY_PREV"
