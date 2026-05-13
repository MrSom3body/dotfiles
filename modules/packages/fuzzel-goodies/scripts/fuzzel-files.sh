#!/usr/bin/env bash

xdg-open "$(fd -E Games -E "$XDG_PROJECTS_DIR"/nixpkgs | fuzzel --dmenu --placeholder "Search for files/directories...")"
