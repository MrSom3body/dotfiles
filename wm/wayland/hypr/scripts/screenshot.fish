#!/bin/fish

set ACTIVE_OPACITY_PREV (hyprctl getoption "decoration:active_opacity" -j | jq .float)
set INACTIVE_OPACITY_PREV (hyprctl getoption "decoration:inactive_opacity" -j | jq .float)

hyprctl --batch "keyword decoration:active_opacity 1; keyword decoration:inactive_opacity 1"

switch $argv[1]
    case screen
        hyprctl --batch "keyword decoration:active_opacity $ACTIVE_OPACITY_PREV; keyword decoration:inactive_opacity $INACTIVE_OPACITY_PREV"
        hyprshot -F -m output -o ~/Pictures/Screenshots/
    case window
        hyprshot -F -m window -o ~/Pictures/Screenshots/
    case region
        hyprshot -F -m region -o ~/Pictures/Screenshots/
end

hyprctl --batch "keyword decoration:active_opacity $ACTIVE_OPACITY_PREV; keyword decoration:inactive_opacity $INACTIVE_OPACITY_PREV"
