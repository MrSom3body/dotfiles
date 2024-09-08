#!/bin/fish

switch $argv[1]
    case volume
        set -l OUTPUT (wpctl get-volume @DEFAULT_AUDIO_SINK@)
        if echo $OUTPUT | grep -q MUTED
            echo 0 >$WOBSOCK
            exit 0
        end
        math (echo $OUTPUT | awk '{print $2}') x 100 >$WOBSOCK
    case brightness
        math floor\((brightnessctl get) / 255 x 100\) >$WOBSOCK
end
