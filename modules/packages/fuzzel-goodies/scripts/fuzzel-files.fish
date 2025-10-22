#!/usr/bin/env fish

xdg-open (fd -E Games -E Documents/Codes/nixpkgs | fuzzel --dmenu --placeholder "Search for files/directories...")
