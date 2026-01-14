#!/usr/bin/env fish

function query_monitors
    hyprctl monitors all -j | jq -r "$argv"
end

function dmenu
    vicinae dmenu -n "Hyprland Monitors" $argv
end

set monitorss (query_monitors '.[] | select(.focused != true) | .name')

if test -z "$monitorss"
    exit 1
end

while true
    set selected_monitors (string join \n $monitorss | dmenu -s "Monitors ({count})" -p "Select a monitor to transform")

    if test -z "$selected_monitors" || ! contains $selected_monitors $monitorss
        exit 1
    end

    set combined_actions Left Right Above Below Reset Back
    for d in (query_monitors ".[] | select (.name != \"$selected_monitors\") | .name" )
        set -p combined_actions "Mirror $d"
    end
    set selection (string join \n $combined_actions | dmenu -p "Select position or action")

    if test -z "$selection"
        exit 1
    else if test "$selection" = Back
        continue
    else if test "$selection" = Reset
        hyprctl keyword monitorv2[$selected_monitors]:mirror ""
        hyprctl keyword monitorv2[$selected_monitors]:position auto
    else
        set parts (string split ' ' -- $selection)
        set action $parts[1]
        set ref_monitors $parts[-1]

        switch $action
            case Mirror
                hyprctl keyword monitorv2[$selected_monitors]:mirror $ref_monitors
            case Left
                hyprctl keyword monitorv2[$selected_monitors]:position auto-center-left
            case Right
                hyprctl keyword monitorv2[$selected_monitors]:position auto-center-right
            case Above
                hyprctl keyword monitorv2[$selected_monitors]:position auto-center-up
            case Below
                hyprctl keyword monitorv2[$selected_monitors]:position auto-center-down
        end
    end

    exit
end
