#!/usr/bin/env fish

function print_help
    echo "Usage: $(status current-command) [flags]"
    echo
    echo "Toggle your touchpad on Hyprland"
    echo
    echo "flags:"
    echo " -h, --help   Display this help message"
end

function enable
    hyprctl "keyword device[$touchpad]:enabled" true
    command -q swayosd-client &&
        swayosd-client --custom-message "Touchpad enabled" --custom-icon touchpad-enabled
    echo true >$statusFile
end

function disable
    hyprctl "keyword device[$touchpad]:enabled" false
    command -q swayosd-client &&
        swayosd-client --custom-message "Touchpad disabled" --custom-icon touchpad-disabled
    echo false >$statusFile
end

set options h/help
argparse $options -- $argv
or return

if set -ql _flag_help
    print_help
    return
end

set touchpad (hyprctl devices | rg touchpad | string trim)

set statusFile "$XDG_RUNTIME_DIR/touchpad.status"
set tp_status (cat $statusFile 2>/dev/null || echo "")

switch $tp_status
    case true
        disable
    case false
        enable
    case "*"
        disable
end
