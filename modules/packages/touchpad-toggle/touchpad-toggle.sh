#!/usr/bin/env bash

print_help() {
    echo "Usage: $(basename "$0") [flags]"
    echo
    echo "Toggle your touchpad on Hyprland"
    echo
    echo "flags:"
    echo " -h, --help   Display this help message"
}

enable_touchpad() {
    hyprctl eval "hl.device({ name = \"$touchpad\", enabled = true })"
    if command -v swayosd-client &>/dev/null; then
        swayosd-client --custom-message "Touchpad enabled" --custom-icon touchpad-enabled
    fi
    echo true > "$statusFile"
}

disable_touchpad() {
    hyprctl eval "hl.device({ name = \"$touchpad\", enabled = false })"
    if command -v swayosd-client &>/dev/null; then
        swayosd-client --custom-message "Touchpad disabled" --custom-icon touchpad-disabled
    fi
    echo false > "$statusFile"
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        -h|--help) print_help; exit 0 ;;
        *) echo "Unknown option: $1" >&2; exit 1 ;;
    esac
done

touchpad=$(hyprctl devices | rg touchpad | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
statusFile="$XDG_RUNTIME_DIR/touchpad.status"
tp_status=$(cat "$statusFile" 2>/dev/null || echo "")

case "$tp_status" in
    true)  disable_touchpad ;;
    false) enable_touchpad ;;
    *)     disable_touchpad ;;
esac
