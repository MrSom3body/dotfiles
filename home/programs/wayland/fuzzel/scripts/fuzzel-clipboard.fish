#!/usr/bin/env fish

cliphist list | fuzzel --dmenu --prompt "󰅇 " --placeholder "Search for clipboard entries..." --no-sort | cliphist decode | wl-copy
