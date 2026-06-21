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

# Builds the whole waybar object from the event list ($events), the next-30min
# window ($close), and the current time ($now). A multi-day event is repeated by
# khal once per day, but every occurrence reports the event's *start* date, so we
# group on the day offset (tagged in emit, see below) rather than any date field.
build_payload='
  def header($offset):
    ($today_epoch + $offset * 86400) as $epoch
    | (if $offset == 0 then "Today, "
       elif $offset == 1 then "Tomorrow, "
       else ($epoch | strflocaltime("%A, ")) end)
      + ($epoch | strflocaltime("%d.%m.%Y"));

  def line:
    (."calendar-color" // "") as $key
    | ($color_map[$key] // {color: (if $key | startswith("#") then $key else null end), bold: false}) as $s
    | "<span"
      + (if $s.color then " foreground=\"" + $s.color + "\"" else "" end)
      + (if $s.bold then " weight=\"bold\"" else "" end)
      + ">"
      + (if (."start-end-time-style" // "") != "" then (."start-end-time-style" | @html) + " " else "" end)
      + (.title | @html) + "</span>";

  ($events | length) as $count
  | [$close[] | select(."start-time" != "")] as $timed
  | (if   ($timed | any(."start-time" <= $now)) then "ongoing"
     elif ($timed | length) > 0                 then "close"
     else "none" end) as $near
  | {
      text:    (if $count > 0 then "\($count)" else "" end),
      tooltip: ([$events | group_by(.dayoffset)[]
                 | ("<b>" + header(.[0].dayoffset) + "</b>"), (.[] | line)] | join("\n")),
      alt:     (if   $count == 0          then "none"
                elif $near == "ongoing"   then "has-ongoing-event"
                elif $near == "close"     then "has-close-event"
                else "has-event" end),
      class:   (if $count > 0 and $near != "none" then $near else "" end)
    }
'

emit() {
  # Local noon keeps offset arithmetic (offset * 86400) clear of DST midnight shifts.
  today_epoch=$(date -d "today 12:00" +%s)

  # khal prints one JSON array per day in range; tag each event with its day offset
  # (the line index) so the tooltip can group events by the day they're shown under.
  events=$(khal list now \
    --json title --json start-end-time-style --json calendar-color |
    jq -cs '[to_entries[] | .key as $offset | .value[] | . + {dayoffset: $offset}]')
  close=$(khal list now 30m --json start-time | jq -cs 'add // []')

  jq -cn \
    --argjson events "$events" \
    --argjson close "$close" \
    --argjson today_epoch "$today_epoch" \
    --argjson color_map "$COLOR_MAP" \
    --arg now "$(date +%H:%M)" \
    "$build_payload"
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
