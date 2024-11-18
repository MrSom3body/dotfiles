#!/usr/bin/env fish

open (fd | fuzzel --dmenu --prompt " " --placeholder "Search for files/directories...")
