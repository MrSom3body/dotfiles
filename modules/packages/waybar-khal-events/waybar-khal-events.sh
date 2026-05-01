#!/usr/bin/env bash

CALENDAR_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/calendars"

format_tooltip='
  group_by(."start-date")[] |
  ("<b>" + (.[0]."start-date") + "</b>"),
  (.[] |
    "<span foreground=\"" + (."calendar-color" // "inherit") + "\">" +
    (if ."start-time" != "" then ."start-time" + "–" + ."end-time" + " " else "" end) +
    (.title | @html) + "</span>"
  )
'

emit() {
  events_json=$(khal list now tomorrow \
    --json title \
    --json start-time \
    --json end-time \
    --json calendar-color \
    --json start-date)

  count=$(jq 'length' <<<"$events_json")
  text=""
  status="none"
  class=""

  if [[ $count -gt 0 ]]; then
    text="$count"
    status="has-event"

    now=$(date +%H:%M)
    close_json=$(khal list now 30m --json title --json start-time)

    close_status=$(jq -r --arg now "$now" '
      if [.[] | select(."start-time" != "" and ."start-time" <= $now)] | length > 0 then "ongoing"
      elif [.[] | select(."start-time" != "")] | length > 0 then "close"
      else "none"
      end
    ' <<<"$close_json")

    case "$close_status" in
    ongoing)
      status="has-ongoing-event"
      class="ongoing"
      ;;
    close)
      status="has-close-event"
      class="close"
      ;;
    esac
  fi

  jq -cn \
    --arg text "$text" \
    --arg tooltip "$(jq -r "$format_tooltip" <<<"$events_json")" \
    --arg alt "$status" \
    --arg class "$class" \
    '{text:$text,tooltip:$tooltip,alt:$alt,class:$class}'
}

while true; do
  emit
  inotifywait -t 120 -rq "$CALENDAR_DIR" 2>/dev/null
done
