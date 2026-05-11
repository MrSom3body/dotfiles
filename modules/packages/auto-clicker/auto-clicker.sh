#!/usr/bin/env bash

print_help() {
    echo "Usage: auto-clicker [flags]"
    echo
    echo "Spam left click for whatever you want"
    echo
    echo "flags:"
    echo " -h, --help   Display this help message"
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        -h|--help) print_help; exit 0 ;;
        *) echo "Unknown option: $1" >&2; exit 1 ;;
    esac
done

if pgrep auto-clicker > /dev/null; then
    pkill auto-clicker
else
    while true; do
        echo click
        # ydotool click 0xC0
    done
fi
