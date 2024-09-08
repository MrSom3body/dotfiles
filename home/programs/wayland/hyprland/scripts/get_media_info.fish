#!/usr/bin/env fish

if test (playerctl status) = Playing
    set artist (playerctl metadata xesam:artist)
    set title (playerctl metadata xesam:title)
    echo " $artist - $title"
end
