#!/usr/bin/env fish

function print_help
    echo "Usage: $(status filename) [options]"
    echo
    echo "Options:"
    echo "  -h, --help      Show this help message and exit"
    echo "  -w, --waybar    Get the current Waybar output"
    echo
    echo "Description:"
    echo "  This script manages the 'Do Not Disturb' state of fnott. By default, it toggles"
    echo "  between active and inactive states. Use the options to customize behavior."
end

set options h/help
set options $options w/waybar
argparse $options -- $argv
or return

if set -ql _flag_h
    print_help
    exit 0
end

set fnott_state (journalctl --user -u fnott.service -b -r | rg --max-count 1 "(un)?pausing" -o)

function toggle
    switch $fnott_state
        case pausing
            fnottctl unpause
            notify-send -a fnott -i notification-active "Do Not Disturb" deactivated
        case unpausing
            notify-send -a fnott -i notification-disabled "Do Not Disturb" activated
            fnottctl pause
        case '*'
            notify-send -a fnott -i notification-disabled "Do Not Disturb" activated
            fnottctl pause
    end
    pkill -36 waybar
end

function waybar_output
    switch $fnott_state
        case pausing
            echo "{\"text\": \"󰂛\", \"tooltip\": \"DND activated\", \"class\": \"dnd-on\"}"
        case unpausing
            echo "{\"text\": \"󰂚\", \"tooltip\": \"DND deactivated\"}"
        case '*'
            echo "{\"text\": \"󰂚\", \"tooltip\": \"DND deactivated\"}"
    end
end

if set -ql _flag_w
    waybar_output
else
    toggle
end
