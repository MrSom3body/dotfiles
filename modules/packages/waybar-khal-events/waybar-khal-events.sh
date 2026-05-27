#!/usr/bin/env bash

CALENDAR_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/calendars"

exec 9>/tmp/waybar-khal-events.lock
flock -n 9 || exit 0

format_tooltip='
  reduce .[] as $item ([];
    if length == 0 or .[-1].date != $item."start-date-long" then
      . + [{date: $item."start-date-long", events: [$item]}]
    else
      .[-1].events += [$item] | .
    end
  )[] |
  (if .date != "" then
    "<b>" + (if .date == $today then "Today, " elif .date == $tomorrow then "Tomorrow, " else "" end) + .date + "</b>"
   else empty end),
  (.events[] |
    "<span foreground=\"" + (."calendar-color" // "inherit") + "\">" +
    (if ."start-time" != "" then ."start-time" + "-" + ."end-time" + " " else "" end) +
    (.title | @html) + "</span>"
  )
'

emit() {
  today=$(date +%d.%m.%Y)
  tomorrow=$(date -d "tomorrow" +%d.%m.%Y)

  events_json=$(khal list now \
    --json title \
    --json start-time \
    --json end-time \
    --json calendar-color \
    --json start-date-long | jq -cs 'add // []')

  count=$(jq 'length' <<<"$events_json")
  text=""
  status="none"
  class=""

  if [[ $count -gt 0 ]]; then
    text="$count"
    status="has-event"

    now=$(date +%H:%M)
    close_json=$(khal list now 30m --json title --json start-time | jq -cs 'add // []')

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
    --arg today "$today" \
    --arg tomorrow "$tomorrow" \
    --arg text "$text" \
    --arg tooltip "$(jq -r --arg today "$today" --arg tomorrow "$tomorrow" "$format_tooltip" <<<"$events_json")" \
    --arg alt "$status" \
    --arg class "$class" \
    '{text:$text,tooltip:$tooltip,alt:$alt,class:$class}'
}

while true; do
  emit
  inotifywait -t 120 -rq "$CALENDAR_DIR" &>/dev/null
done
