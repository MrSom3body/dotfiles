#!/usr/bin/env bash

query_monitors() {
    hyprctl monitors all -j | jq -r "$1"
}

mapfile -t displays < <(query_monitors '.[] | select(.focused != true) | .name')

if [[ ${#displays[@]} -eq 0 ]]; then
    exit 1
fi

while true; do
    selected_display=$(printf "%s\n" "${displays[@]}" | fuzzel --dmenu --placeholder "Select a display to transform")

    if [[ -z "$selected_display" ]]; then
        exit 1
    fi

    found=false
    for d in "${displays[@]}"; do
        [[ "$d" == "$selected_display" ]] && found=true && break
    done
    if ! $found; then
        exit 1
    fi

    combined_actions=("Left" "Right" "Above" "Below" "Reset" "Back")
    while IFS= read -r d; do
        combined_actions=("Mirror $d" "${combined_actions[@]}")
    done < <(query_monitors ".[] | select (.name != \"$selected_display\") | .name")

    selection=$(printf "%s\n" "${combined_actions[@]}" | fuzzel --dmenu --placeholder "Select position or action")

    if [[ -z "$selection" ]]; then
        exit 1
    elif [[ "$selection" == Back ]]; then
        continue
    elif [[ "$selection" == Reset ]]; then
        hyprctl keyword "monitorv2[$selected_display]:mirror" ""
        hyprctl keyword "monitorv2[$selected_display]:position" auto
    else
        read -ra parts <<< "$selection"
        action="${parts[0]}"
        ref_display="${parts[-1]}"

        case "$action" in
            Mirror) hyprctl keyword "monitorv2[$selected_display]:mirror" "$ref_display" ;;
            Left)   hyprctl keyword "monitorv2[$selected_display]:position" auto-center-left ;;
            Right)  hyprctl keyword "monitorv2[$selected_display]:position" auto-center-right ;;
            Above)  hyprctl keyword "monitorv2[$selected_display]:position" auto-center-up ;;
            Below)  hyprctl keyword "monitorv2[$selected_display]:position" auto-center-down ;;
        esac
    fi

    exit 0
done
