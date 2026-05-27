#!/usr/bin/env bash

query_monitors() {
    hyprctl monitors all -j | jq -r "$1"
}

dmenu() {
    vicinae dmenu -n "Hyprland Monitors" "$@"
}

mapfile -t monitorss < <(query_monitors '.[] | select(.focused != true) | .name')

if [[ ${#monitorss[@]} -eq 0 ]]; then
    exit 1
fi

while true; do
    selected_monitors=$(printf "%s\n" "${monitorss[@]}" | dmenu -s "Monitors ({count})" -p "Select a monitor to transform")

    if [[ -z "$selected_monitors" ]]; then
        exit 1
    fi

    found=false
    for m in "${monitorss[@]}"; do
        [[ "$m" == "$selected_monitors" ]] && found=true && break
    done
    if ! $found; then
        exit 1
    fi

    combined_actions=("Left" "Right" "Above" "Below" "Reset" "Back")
    while IFS= read -r d; do
        combined_actions=("Mirror $d" "${combined_actions[@]}")
    done < <(query_monitors ".[] | select (.name != \"$selected_monitors\") | .name")

    selection=$(printf "%s\n" "${combined_actions[@]}" | dmenu -p "Select position or action")

    if [[ -z "$selection" ]]; then
        exit 1
    elif [[ "$selection" == Back ]]; then
        continue
    elif [[ "$selection" == Reset ]]; then
        hyprctl eval "hl.monitor({ output = \"$selected_monitors\", mirror = \"\", position = \"auto\" })"
    else
        read -ra parts <<< "$selection"
        action="${parts[0]}"
        ref_monitors="${parts[-1]}"

        case "$action" in
            Mirror) hyprctl eval "hl.monitor({ output = \"$selected_monitors\", mirror = \"$ref_monitors\" })" ;;
            Left)   hyprctl eval "hl.monitor({ output = \"$selected_monitors\", position = \"auto-center-left\" })" ;;
            Right)  hyprctl eval "hl.monitor({ output = \"$selected_monitors\", position = \"auto-center-right\" })" ;;
            Above)  hyprctl eval "hl.monitor({ output = \"$selected_monitors\", position = \"auto-center-up\" })" ;;
            Below)  hyprctl eval "hl.monitor({ output = \"$selected_monitors\", position = \"auto-center-down\" })" ;;
        esac
    fi

    exit 0
done
