{ lib, ... }:
{
  flake.modules.homeManager.desktop =
    { config, ... }:
    {
      wayland.windowManager.hyprland.settings = {
        "$floatingSize" = "600 400";

        windowrule = [
          # inhibit idle when fullscreen
          "match:fullscreen true, idle_inhibit always"

          # Smart Gaps
          "match:workspace w[tv1] s[false], match:float false, border_size 0, rounding 0, no_shadow true"
          "match:workspace f[1] s[false], match:float false, border_size 0, rounding 0"
          "match:workspace f[f1] s[false], match:float false, no_shadow true"

          # Fix some dragging issues with XWayland
          "match:class ^$, match:title ^$, match:xwayland true, match:float true, match:fullscreen false, match:pin false, no_focus true"

          # Ignore maximize requests from apps
          "match:class .*, suppress_event maximize"

          # Move apps to workspaces
          "match:class ^(vesktop)$, workspace special:discord silent"
          "match:class ^(Todoist|@lunatask/electron)$, workspace special:todo silent"

          # Dim some programs
          "match:class ^(xdg-desktop-portal-gtk)$, dim_around true"
          "match:class ^(polkit-gnome-authentication-agent-1)$, dim_around true"

          # NetworkManager applet
          "match:class ^(nm-connection-editor)$, float true, size $floatingSize, center true"

          # Blueman
          "match:class ^(.blueman-manager-wrapped)$, float true, size $floatingSize, center true"

          # Audio control
          "match:class ^(com.saivert.pwvucontrol)$, float true, size $floatingSize, center true"

          # Udiskie
          "match:class ^(udiskie)$, float true, center true"

          # make some windows floating and sticky
          "match:title ^(Picture-in-Picture)$, float true, pin true"

          # Proton Pass
          "match:class ^(Proton Pass)$, float true, no_screen_share true"

          # GNS3
          "match:class ^(gns3)$, match:title ^(Change hostname)$, stay_focused false"

          # Anki
          "match:class ^(Anki)$, match:title ^(Add)$, float true, size 600 400, center true"

          # Calculator
          "match:class ^(org.gnome.Calculator)$, float true, size > >"

          # Clock
          "match:class ^(org.gnome.clocks)$, float true, size 800 600"

          # Grayjay
          "match:title ^(Grayjay)$, tile true"

          # Games
          "match:class ^(Minecraft.*)$, immediate true"
          "match:class ^(steam_app_.*)$, immediate true"
          "match:class ^(steam_app_960090)$, render_unfocused true" # don't kick me out of bloons
          "match:class ^(hl2_linux)$, immediate true" # Left 4 Dead 2
        ];

        layerrule = [
          # Sway notification Center
          "match:namespace swaync-control-center, animation slide right, dim_around true"

          # Rofi
          "match:namespace rofi, animation slide, dim_around true"

          # fuzzel
          "match:namespace launcher, animation slide, dim_around true"

          # fnott
          "match:namespace notifications, animation slide "
        ]
        # only blur if not fully opaque
        ++ lib.optional (config.stylix.opacity.desktop != 1.0) [
          # waybar
          "match:namespace waybar, blur true, ignore_alpha 0"

          # swaync
          "match:namespace swaync-control-center, blur true, ignore_alpha 0"

          # rofi
          "match:namespace rofi, blur true, ignore_alpha 0"

          # fuzzel
          "match:namespace launcher, blur true, ignore_alpha 0"

          # fnott
          "match:namespace notifications, blur true, ignore_alpha 0"
        ];

        workspace =
          let
            gaps = "50";
          in
          [
            # Smart Gaps
            "w[tv1], gapsout:0, gapsin:0"
            "f[1], gapsout:0, gapsin:0"

            "special:magic, gapsout:${gaps}"

            "special:spotify, on-created-empty:uwsm app -- spotify"
            "special:spotify, gapsout:${gaps}"

            "special:monitor, on-created-empty:uwsm app -- xdg-terminal-exec btop"
            "special:monitor, gapsout:${gaps}"

            "special:discord, on-created-empty:uwsm app -- vesktop"
            "special:discord, gapsout:${gaps}"

            "special:todo, on-created-empty:uwsm app -- lunatask"
            "special:todo, gapsout:${gaps}"
          ];
      };
    };
}
