#!/usr/bin/env fish

cliphist list | fuzzel --dmenu --prompt "󰅇 " --no-sort | cliphist decode | wl-copy
