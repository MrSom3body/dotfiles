#!/usr/bin/env bash

NAME=$(basename "$1")

hypr-focus-or-launch "$NAME" xdg-terminal-exec --app-id="$NAME" -e "$1" "${@:2}"
