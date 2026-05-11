#!/usr/bin/env bash

print_help() {
    echo "Usage: $(basename "$0") [options]"
    echo
    echo "Options:"
    echo "  -h, --help      Show this help message and exit"
    echo "  -w, --waybar    Get the current Waybar output"
    echo
    echo "Description:"
    echo "  This script manages the 'Do Not Disturb' state of fnott. By default, it toggles"
    echo "  between active and inactive states. Use the options to customize behavior."
}

flag_help=false
flag_waybar=false

opts=$(getopt -o hw -l help,waybar -n "${0##*/}" -- "$@") || exit 1
eval set -- "$opts"

while true; do
    case "$1" in
        -h|--help) flag_help=true; shift ;;
        -w|--waybar) flag_waybar=true; shift ;;
        --) shift; break ;;
    esac
done

if $flag_help; then
    print_help
    exit 0
fi

fnott_state=$(journalctl --user -u fnott.service -b -r | rg --max-count 1 "(un)?pausing" -o)

toggle() {
    case "$fnott_state" in
        pausing)
            fnottctl unpause
            notify-send -a fnott -i notifications-symbolic "Do Not Disturb" deactivated
            ;;
        unpausing)
            notify-send -a fnott -i notifications-disabled-symbolic "Do Not Disturb" activated
            fnottctl pause
            ;;
        *)
            notify-send -a fnott -i notifications-disabled-symbolic "Do Not Disturb" activated
            fnottctl pause
            ;;
    esac
    pkill -36 waybar
}

waybar_output() {
    case "$fnott_state" in
        pausing)
            echo '{"text": "󰂛", "tooltip": "DND activated", "class": "dnd-on"}'
            ;;
        *)
            echo '{"text": "󰂚", "tooltip": "DND deactivated"}'
            ;;
    esac
}

if $flag_waybar; then
    waybar_output
else
    toggle
fi
