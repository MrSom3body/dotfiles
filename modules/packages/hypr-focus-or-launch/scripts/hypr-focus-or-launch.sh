#!/usr/bin/env bash

print_help() {
  echo "Usage: $(basename "$0") [options] <window-class> <launch-command...>"
  echo
  echo "Options:"
  echo "  -h, --help      Show this help message and exit"
}

opts=$(getopt -o +h -l help -n "${0##*/}" -- "$@") || exit 1
eval set -- "$opts"

while true; do
  case "$1" in
  -h | --help)
    print_help
    exit 0
    ;;
  --)
    shift
    break
    ;;
  esac
done

if [ "$#" -lt 1 ]; then
  print_help
  exit 1
fi

CLASS="$1"
shift
COMMAND="${*:-$CLASS}"

ADDRESS=$(hyprctl clients -j | jq -r --arg p "$CLASS" '.[] | select((.class|test("\\b" + $p + "\\b";"i")) or (.title|test("\\b" + $p + "\\b";"i"))) | .address' | head -n1)

if [ -n "$ADDRESS" ]; then
  hyprctl dispatch "hl.dsp.focus({window=\"address:$ADDRESS\"})"
else
  eval "uwsm-app -- $COMMAND"
fi
