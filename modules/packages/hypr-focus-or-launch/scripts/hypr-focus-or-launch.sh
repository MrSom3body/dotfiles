#!/usr/bin/env bash

print_help() {
    echo "Usage: $(basename "$0") [options] <window-class> <launch-command...>"
    echo
    echo "Options:"
    echo "  -h, --help      Show this help message and exit"
    echo "  -p, --pull      Pull the window to the current workspace instead of jumping to it"
}

flag_pull=false

opts=$(getopt -o +hp -l help,pull -n "${0##*/}" -- "$@") || exit 1
eval set -- "$opts"

while true; do
    case "$1" in
        -h|--help) print_help; exit 0 ;;
        -p|--pull) flag_pull=true; shift ;;
        --) shift; break ;;
    esac
done

if [ "$#" -lt 2 ]; then
  print_help
  exit 1
fi

CLASS="$1"
shift
COMMAND="$@"

ADDRESS=$(hyprctl clients -j | jq -r ".[] | select(.class == \"$CLASS\") | .address" | head -n1)

if [ -n "$ADDRESS" ]; then
  if $flag_pull; then
    hyprctl dispatch "hl.dsp.window.move({workspace=\"m+0\", follow=true, window=\"address:$ADDRESS\"})"
  else
    hyprctl dispatch "hl.dsp.focus({window=\"address:$ADDRESS\"})"
  fi
else
  eval "$COMMAND"
fi
