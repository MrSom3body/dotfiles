#!/usr/bin/env fish

function query_monitors
    hyprctl monitors all -j | jq -r "$argv"
end

function get_param -a display attr
    query_monitors ".[] | select(.name == \"$display\") | .$attr"
end

set displays (query_monitors '.[].name')

while true
    set selected_display (printf "%s\n" $displays | fuzzel --dmenu --placeholder "Select a display to transform")

    if test -z "$selected_display"
        exit 1
    end

    set combined_actions Reset Back
    for d in (query_monitors ".[] | select (.name != \"$selected_display\") | .name" )
        set -p combined_actions "Mirror $d" "Left of $d" "Right of $d" "Above $d" "Below $d"
    end
    set selection (printf "%s\n" $combined_actions | fuzzel --dmenu --placeholder "Select position or action")

    set width (get_param $selected_display "width")
    set height (get_param $selected_display "height")
    set refresh (get_param $selected_display "refreshRate")
    set scale (get_param $selected_display "scale")
    set resolution "$width"x"$height"@"$refresh"

    if test -z "$selection"
        exit 1
    else if test "$selection" = Back
        continue
    else if test "$selection" = Reset
        hyprctl keyword monitor "$selected_display,$resolution,0x0,$sscale"
    else
        set parts (string split ' ' -- $selection)
        set action $parts[1]
        set ref_display $parts[-1]

        set rx (get_param $ref_display "x")
        set ry (get_param $ref_display "y")
        set rwidth (get_param $ref_display "width")
        set rheight (get_param $ref_display "height")

        switch $action
            case Mirror
                hyprctl keyword monitor "$selected_display,preferred,auto,1,mirror,$ref_display"
            case Left
                set pos "$(math $rx - $width)x$ry"
                hyprctl keyword monitor "$selected_display,$resolution,$pos,$scale"
            case Right
                set pos "$(math $rx + $rwidth)x$ry"
                hyprctl keyword monitor "$selected_display,$resolution,$pos,$scale"
            case Above
                set pos "$rx"x"$(math $ry - $height)"
                hyprctl keyword monitor "$selected_display,$resolution,$pos,$scale"
            case Below
                set pos "$rx"x"$(math $ry + $rheight)"
                hyprctl keyword monitor "$selected_display,$resolution,$pos,$scale"
        end
    end

    exit
end
