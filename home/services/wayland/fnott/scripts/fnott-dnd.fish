#!/usr/bin/env fish

set fnott_state (journalctl --user -u fnott.service -b -r | rg --max-count 1 "(un)?pausing" -o)

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
