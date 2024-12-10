#!/usr/bin/env fish

set clients (hyprctl clients -j)
set classes (echo $clients | jq -r '.[] | .class')
set titles (echo $clients | jq -r '.[] | .title')
set addresses (echo $clients | jq -r '.[] | .address')
set choices ""

for i in (seq (count $classes))
    if string match "*.*.*" $classes[$i]
        set choices "$choices$titles[$i]\t$classes[$i]\0icon\x1f$classes[$i]\n"
    else
        set class (string lower (string replace "jetbrains-" "" $classes[$i]))
        set class (string lower (string replace "footclient" "foot" $classes[$i]))
        set choices "$choices$titles[$i]\t$classes[$i]\0icon\x1f$class\n"
    end
end

set choices (string trim -c "\n" $choices)

# EXTREMELY hacky workaround for hidden text but idc it works :)
set choice (echo -e $choices | fuzzel --dmenu --prompt " " --placeholder "Search for windows..." --index --tabs 200 || exit)
hyprctl dispatch focuswindow address:$addresses[(math $choice + 1)]
