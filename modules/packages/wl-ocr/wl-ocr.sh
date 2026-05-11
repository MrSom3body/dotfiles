#!/usr/bin/env bash

print_help() {
    echo "Usage: $(basename "$0") [flags]"
    echo
    echo "OCR your screen (wayland)"
    echo
    echo "flags:"
    echo " -h, --help   Display this help message"
    echo " -l, --lang   Languages to OCR (default: eng+deu)"
    echo " -c, --copy   Copy to clipboard"
    echo " -n, --notify Send a notification on success"
}

flag_help=false
flag_lang=""
flag_notify=false
flag_copy=false

opts=$(getopt -o hl:nc -l help,lang:,notify,copy -n "${0##*/}" -- "$@") || exit 1
eval set -- "$opts"

while true; do
    case "$1" in
        -h|--help) flag_help=true; shift ;;
        -l|--lang) flag_lang="$2"; shift 2 ;;
        -n|--notify) flag_notify=true; shift ;;
        -c|--copy) flag_copy=true; shift ;;
        --) shift; break ;;
    esac
done

if $flag_help; then
    print_help
    exit 0
fi

lang="${flag_lang:-eng+deu}"

content=$(grim -g "$(slurp)" -t ppm - | tesseract -l "$lang" - -)

if [[ -n "$content" ]]; then
    echo "$content"

    if $flag_notify; then
        notify-send -a ocrfeeder wl-ocr "$content"
    fi

    if $flag_copy; then
        wl-copy "$content"
    fi
fi
