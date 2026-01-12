#!/usr/bin/env fish

function query_monitors
    hyprctl monitors all -j | jq -r "$argv"
end

set displays (query_monitors '.[] | select(.focused != true) | .name')

if not set -q displays
    exit 1
end

while true
    set selected_display (printf "%s\n" $displays | fuzzel --dmenu --placeholder "Select a display to transform")

    if test -z "$selected_display" || ! contains $selected_display $displays
        exit 1
    end

    set combined_actions Left Right Above Below Reset Back
    for d in (query_monitors ".[] | select (.name != \"$selected_display\") | .name" )
        set -p combined_actions "Mirror $d"
    end
    set selection (printf "%s\n" $combined_actions | fuzzel --dmenu --placeholder "Select position or action")

    if test -z "$selection"
        exit 1
    else if test "$selection" = Back
        continue
    else if test "$selection" = Reset
        hyprctl keyword monitorv2[$selected_display]:mirror ""
        hyprctl keyword monitorv2[$selected_display]:position auto
    else
        set parts (string split ' ' -- $selection)
        set action $parts[1]
        set ref_display $parts[-1]

        switch $action
            case Mirror
                hyprctl keyword monitorv2[$selected_display]:mirror $ref_display
            case Left
                hyprctl keyword monitorv2[$selected_display]:position auto-center-left
            case Right
                hyprctl keyword monitorv2[$selected_display]:position auto-center-right
            case Above
                hyprctl keyword monitorv2[$selected_display]:position auto-center-up
            case Below
                hyprctl keyword monitorv2[$selected_display]:position auto-center-down
        end
    end

    exit
end
