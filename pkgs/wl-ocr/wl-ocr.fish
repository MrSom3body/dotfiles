#!/usr/bin/env -S fish --no-config

function print_help
    echo "Usage: $(status current-command) [flags]"
    echo
    echo "OCR your screen (wayland)"
    echo
    echo "flags:"
    echo " -h, --help   Display this help message"
    echo " -l, --lang   Languages to OCR (default: eng+deu)"
    echo " -c, --copy   Copy to clipboard"
    echo " -n, --notify Send a notification on success"
end

function notify
    notify-send -a ocrfeeder $argv
end

set options h/help
set options $options l/lang=
set options $options n/notify
set options $options c/copy
argparse $options -- $argv
or return

if set -ql _flag_help
    print_help
    return
end

set lang eng+deu

if set -ql _flag_lang
    set lang $_flag_lang
end

set content (grim -g $(slurp) -t ppm - | tesseract -l $lang - -)

if test -n "$content"
    echo "$content"

    if set -ql _flag_notify
        notify wl-ocr "$content"
    end

    if set -ql _flag_copy
        wl-copy "$content"
    end
end
