#!/usr/bin/env fish

function print_help
    echo "Usage: hyprcast.fish [options]"
    echo
    echo "Start a screen recording or stop a running one"
    echo
    echo "Options:"
    echo " -h, --help   Display this help message"
    echo " -w, --waybar Print output for waybar"
end

set options h/help
set options $options w/waybar
argparse $options -- $argv
or return

if set -ql _flag_help
    print_help
    return
end

if set -ql _flag_waybar
    if test -e ~/.hyprcast
        echo "{\"text\": \"\", \"tooltip\": \"Recording screen with hyprcast\"}"
    end
    return
end

if test -e ~/.hyprcast
    pkill -SIGINT wl-screenrec || notify-send -e -u critical -a wl-screenrec -t 1000 "Screencast not started" "A screencast is already starting"
    return
end

set file_name ~/Videos/Screencasts/$(date +%Y-%m-%d-%H%M%S).mp4
touch ~/.hyprcast

set notif_id 0
for i in (seq 5 -1 1)
    set notif_id (notify-send -e -a wl-screenrec -p -r $notif_id -t (math $i x 1000) "Screencast will start in $i")
    sleep 1
end

pkill -35 waybar
wl-screenrec -f $file_name
pkill -35 waybar

notify-send -e -t 3000 -a wl-screenrec -i $file_name "Screencast finished" "Saved to $file_name"
rm ~/.hyprcast
