#!/usr/bin/env bash

clients=$(hyprctl clients -j)
mapfile -t classes < <(echo "$clients" | jq -r '.[] | .class')
mapfile -t titles < <(echo "$clients" | jq -r '.[] | .title')
mapfile -t addresses < <(echo "$clients" | jq -r '.[] | .address')

get_choices() {
    for i in "${!classes[@]}"; do
        class="${classes[$i]}"
        title="${titles[$i]}"
        if [[ "$class" == *.*.* ]]; then
            printf "%s\t%s\0icon\x1f%s\n" "$title" "$class" "$class"
        else
            cls=$(echo "$class" | sed -e 's/jetbrains-//' -e 's/footclient/foot/' | tr '[:upper:]' '[:lower:]')
            printf "%s\t%s\0icon\x1f%s\n" "$title" "$class" "$cls"
        fi
    done
}

# EXTREMELY hacky workaround for hidden text but idc it works :)
choice=$(get_choices | fuzzel --dmenu --placeholder "Search for windows..." --index --tabs 200) || exit
hyprctl dispatch focuswindow "address:${addresses[$choice]}"
