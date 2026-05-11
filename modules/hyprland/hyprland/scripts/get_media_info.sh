#!/usr/bin/env bash

if [[ "$(playerctl status)" == Playing ]]; then
    artist=$(playerctl metadata xesam:artist)
    title=$(playerctl metadata xesam:title)
    echo " $artist - $title"
fi
