#!/usr/bin/env fish

cliphist list | fuzzel --dmenu --placeholder "Search for clipboard entries..." --no-sort | cliphist decode | wl-copy
