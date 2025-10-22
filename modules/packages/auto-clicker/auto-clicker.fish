#!/usr/bin/env -S fish --no-config

function print_help
    echo "Usage: auto-clicker [flags]"
    echo
    echo "Spam left click for whatever you want"
    echo
    echo "flags:"
    echo " -h, --help   Display this help message"
end

set options h/help
argparse $options -- $argv
or return

if set -ql _flag_help
    print_help
    return
end

if pgrep auto-clicker
    pkill auto-clicker
else
    while true
        echo click
        # ydotool click 0xC0
    end
end
