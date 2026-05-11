#!/usr/bin/env bash

print_help() {
    echo "Usage: hyprcast [flags]"
    echo
    echo "Start a screen recording or stop a running one"
    echo
    echo "flags:"
    echo " -h, --help   Display this help message"
    echo " -a, --audio  Record with audio"
    echo " -w, --waybar Print output for waybar"
}

get_output() {
    hyprctl monitors -j | jq '.[] | select(.focused == true) | .name' -r
}

flag_help=false
flag_audio=false
flag_waybar=false

opts=$(getopt -o haw -l help,audio,waybar -n "${0##*/}" -- "$@") || exit 1
eval set -- "$opts"

while true; do
    case "$1" in
        -h|--help) flag_help=true; shift ;;
        -a|--audio) flag_audio=true; shift ;;
        -w|--waybar) flag_waybar=true; shift ;;
        --) shift; break ;;
    esac
done

if $flag_help; then
    print_help
    exit 0
fi

if $flag_waybar; then
    if [[ -e ~/.hyprcast ]]; then
        echo '{"text": "", "tooltip": "Recording screen with hyprcast"}'
    fi
    exit 0
fi

if [[ -e ~/.hyprcast ]]; then
    if pidof wl-screenrec > /dev/null; then
        echo "wl-screenrec running"
        pkill -SIGINT wl-screenrec
    else
        kill "$(head -1 ~/.hyprcast)" &&
            notify-send -a hyprcast -e -r "$(tail -1 ~/.hyprcast)" -t 3000 "Screencast cancelled successfully"
    fi
    rm ~/.hyprcast
    exit 0
fi

mkdir -p ~/Videos/Screencasts
file_name=~/Videos/Screencasts/$(date +%Y-%m-%d-%H%M%S).mp4
echo $$ > ~/.hyprcast

notif_id=0
for i in $(seq 3 -1 1); do
    notif_id=$(notify-send -a hyprcast -e -p -r "$notif_id" -t $((i * 1000)) "Screencast will start in $i")
    echo "$notif_id" >> ~/.hyprcast
    sleep 1
done

pkill -35 waybar
if $flag_audio; then
    wl-screenrec \
        -f "$file_name" \
        -o "$(get_output)" \
        --audio --audio-device "$(wpctl inspect @DEFAULT_AUDIO_SINK@ | grep "node.name" | cut -d '"' -f2).monitor"
else
    wl-screenrec \
        -f "$file_name" \
        -o "$(get_output)"
fi
pkill -35 waybar

notify-send -a hyprcast -t 3000 "Screencast finished" "Saved to $file_name"
