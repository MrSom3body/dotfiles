#!/usr/bin/env bash

AUTO_SELECT=1

show_help() {
  echo "Usage: send-to-phone [OPTIONS] [FILE/URL...]"
  echo "Send files or URLs to a KDE Connect device."
  echo ""
  echo "Options:"
  echo "  -n, --no-auto    Disable auto-selecting the device when only one is available"
  echo "  -h, --help       Show this help message and exit"
  echo ""
  echo "Example:"
  echo "  send-to-phone file1.txt file2.jpg"
  echo "  send-to-phone https://google.com"
  echo "  send-to-phone --no-auto file.txt"
}

while [[ "$#" -gt 0 ]]; do
  case $1 in
  -h | --help)
    show_help
    exit 0
    ;;
  -n | --no-auto)
    AUTO_SELECT=0
    shift
    ;;
  *)
    break
    ;;
  esac
done

if [[ "$#" -eq 0 ]]; then
  echo "Error: No files or URLs specified to send."
  show_help
  exit 1
fi

DEVICES=$(kdeconnect-cli -a --id-name-only)
DEVICE_COUNT=$(echo "$DEVICES" | grep -c . || true)

if [ "$DEVICE_COUNT" -eq 0 ]; then
  echo "❌ No KDE Connect devices found or reachable. Make sure the device is paired and on the same network."
  exit 1
elif [ "$DEVICE_COUNT" -eq 1 ] && [ "$AUTO_SELECT" -eq 1 ]; then
  DEVICE_ID=$(echo "$DEVICES" | awk '{print $1}')
  echo "Auto-selecting device: $(echo "$DEVICES" | cut -d' ' -f2-)"
else
  SELECTION=$(echo "$DEVICES" | fzf \
    --prompt="📱 Send to: " \
    --border=rounded \
    --layout=reverse \
    --info=hidden \
    --header=" KDE Connect Devices ")
  if [ -z "$SELECTION" ]; then
    echo "No device selected. Aborting."
    exit 1
  fi
  DEVICE_ID=$(echo "$SELECTION" | awk '{print $1}')
fi

for item in "$@"; do
  kdeconnect-cli -d "$DEVICE_ID" --share "$item"
done
