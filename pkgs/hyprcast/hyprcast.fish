#!/usr/bin/env -S fish --no-config

function print_help
    echo "Usage: hyprcast.fish [flags]"
    echo
    echo "Start a screen recording or stop a running one"
    echo
    echo "flags:"
    echo " -h, --help   Display this help message"
    echo " -w, --waybar Print output for waybar"
end

function notify
    notify-send -a hyprcast $argv
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
    if pidof wl-screenrec
        echo wl-screenrec running
        pkill -SIGINT wl-screenrec
    else
        kill (head -1 ~/.hyprcast) &&
            notify -e -r (tail -1 ~/.hyprcast) -t 3000 "Screencast cancelled successfully"
    end
    rm ~/.hyprcast
    exit
end

set file_name ~/Videos/Screencasts/$(date +%Y-%m-%d-%H%M%S).mp4
echo $fish_pid >~/.hyprcast

set notif_id 0
for i in (seq 3 -1 1)
    set notif_id (notify -e -p -r $notif_id -t (math $i x 1000) "Screencast will start in $i")
    echo $notif_id >>~/.hyprcast
    sleep 1
end

pkill -35 waybar
wl-screenrec \
    -f $file_name \
    --audio --audio-device (wpctl inspect @DEFAULT_AUDIO_SINK@ | grep "node.name" | cut -d"\"" -f2).monitor
pkill -35 waybar

notify -t 3000 -i $file_name "Screencast finished" "Saved to $file_name"
