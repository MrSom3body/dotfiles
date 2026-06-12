#!/usr/bin/env bash

CALENDAR_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/calendars"

# Maps khal/urwid named colors to Pango-compatible hex + bold.
# Light colors are bold to match khal's own bold_for_light_color convention.
COLOR_MAP='{
  "black":         {"color": "#000000", "bold": false},
  "dark red":      {"color": "#aa0000", "bold": false},
  "dark green":    {"color": "#00aa00", "bold": false},
  "brown":         {"color": "#aa5500", "bold": false},
  "dark blue":     {"color": "#0000aa", "bold": false},
  "dark magenta":  {"color": "#aa00aa", "bold": false},
  "dark cyan":     {"color": "#00aaaa", "bold": false},
  "light gray":    {"color": "#aaaaaa", "bold": true},
  "dark gray":     {"color": "#555555", "bold": false},
  "light red":     {"color": "#ff5555", "bold": true},
  "light green":   {"color": "#55ff55", "bold": true},
  "yellow":        {"color": "#ffff55", "bold": true},
  "light blue":    {"color": "#5555ff", "bold": true},
  "light magenta": {"color": "#ff55ff", "bold": true},
  "light cyan":    {"color": "#55ffff", "bold": true},
  "white":         {"color": "#ffffff", "bold": true}
}'

format_tooltip='
  reduce .[] as $item ([];
    if length == 0 or .[-1].date != $item."start-date-long" then
      . + [{date: $item."start-date-long", events: [$item]}]
    else
      .[-1].events += [$item] | .
    end
  )[] |
  (if .date != "" then
    "<b>" + (
      if .date == $today then "Today, "
      elif .date == $tomorrow then "Tomorrow, "
      else (.date | strptime("%d.%m.%Y") | strftime("%A, "))
      end
    ) + .date + "</b>"
   else empty end),
  (.events[] |
    (."calendar-color") as $raw |
    ($color_map[$raw] // {color: (if ($raw // "") | startswith("#") then $raw else null end), bold: false}) as $style |
    "<span" +
    (if $style.color then " foreground=\"" + $style.color + "\"" else "" end) +
    (if $style.bold then " weight=\"bold\"" else "" end) +
    ">" +
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
    --arg tooltip "$(jq -r --arg today "$today" --arg tomorrow "$tomorrow" --argjson color_map "$COLOR_MAP" "$format_tooltip" <<<"$events_json")" \
    --arg alt "$status" \
    --arg class "$class" \
    '{text:$text,tooltip:$tooltip,alt:$alt,class:$class}'
}

exec 9>/tmp/waybar-khal-events.lock
if flock -n 9; then
  # Master instance: processes events and updates cache
  while true; do
    out=$(emit)
    echo "$out" >/tmp/waybar-khal-events-cache.json
    echo "$out"
    inotifywait -t 120 -rq "$CALENDAR_DIR" &>/dev/null
  done
else
  # Follower instance: just outputs the cache when it changes
  while [[ ! -f /tmp/waybar-khal-events-cache.json ]]; do sleep 1; done
  cat /tmp/waybar-khal-events-cache.json

  while true; do
    inotifywait -qq -e close_write /tmp/waybar-khal-events-cache.json &>/dev/null
    cat /tmp/waybar-khal-events-cache.json
  done
fi
