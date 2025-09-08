{
  lib,
  config,
  ...
}:
let
  inherit (lib) mkIf;
  cfg = config.my.desktop.hyprland;
in
{
  config = mkIf cfg.enable {
    wayland.windowManager.hyprland.settings = {
      "$floatingSize" = "600 400";
      "$pwvucontrol" = "com.saivert.pwvucontrol";

      windowrule = [
        # inhibit idle when fullscreen
        "idleinhibit focus, fullscreenstate:2 *"

        # Smart Gaps
        "noborder 1, floating:0, onworkspace:w[tv1] s[false]"
        "norounding 1, floating:0, onworkspace:w[tv1] s[false]"
        "noshadow 1, floating:0, onworkspace:w[tv1] s[false]"
        "noborder 1, floating:0, onworkspace:f[1] s[false]"
        "norounding 1, floating:0, onworkspace:f[1] s[false]"
        "noshadow 1, floating:0, onworkspace:f[f1] s[false]"

        # Ignore maximize requests from apps
        "suppressevent maximize, class:.*"

        # Fix some dragging issues with XWayland
        "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"

        # NetworkManager applet
        "float, class:^(nm-connection-editor)$"
        "size $floatingSize, class:^(nm-connection-editor)$"
        "center, class:^(nm-connection-editor)$"

        # Blueman
        "float, class:^(.blueman-manager-wrapped)$"
        "size $floatingSize, class:^(.blueman-manager-wrapped)$"
        "center, class:^(.blueman-manager-wrapped)$"

        # Audio control
        "float, class:^($pwvucontrol)$"
        "size $floatingSize, class:^($pwvucontrol)$"
        "center, class:^($pwvucontrol)$"

        # Udiskie
        "float, class:^(udiskie)$"
        "center, class:^(udiskie)$"

        # make some windows floating and sticky
        "float, title:^(Picture-in-Picture)$" # firefox
        "pin, title:^(Picture-in-Picture)$" # firefox

        # Proton Pass
        "float, class:^(Proton Pass)$"
        "noscreenshare, class:^(Proton Pass)$"

        # GNS3
        "stayfocused, class:^(gns3)$, title:^(Change hostname)$"

        # Anki
        "float, class:^(Anki)$, title:^(Add)$"
        "size 600 400, class:^(Anki)$, title:^(Add)$"
        "center, class:^(Anki)$, title:^(Add)$"

        # Calculator
        "float, class:^(org.gnome.Calculator)$"
        "size > >, class:^(org.gnome.Calculator)$"

        # Clock
        "float, class:^(org.gnome.clocks)$"
        "size 800 600, class:^(org.gnome.clocks)$"

        # Move apps to workspaces
        "workspace special:discord, class:^(vesktop)$"
        "workspace special:todoist, class:^(todoist)$"

        # Dim some programs
        "dimaround, class:^(xdg-desktop-portal-gtk)$"
        "dimaround, class:^(polkit-gnome-authentication-agent-1)$"

        # Games
        "immediate, class:^(Minecraft.*)$"
        "immediate, class:^(steam_app_.*)$"
        "renderunfocused, class:^(steam_app_960090)$" # don't kick me out of bloons
        "immediate, class:^(hl2_linux)$" # Left 4 Dead 2
      ];

      layerrule = [
        # Sway notification Center
        "animation slide right, swaync-control-center"
        "dimaround, swaync-control-center"

        # Rofi
        "animation slide, rofi"
        "dimaround, rofi"

        # fuzzel
        "animation slide, launcher"
        "dimaround, launcher"

        # fnott
        "animation slide, notifications"
      ]
      # only blur if not fully opaque
      ++ lib.optional (config.stylix.opacity.desktop != 1.0) [
        # waybar
        "blur, waybar"
        "ignorezero, waybar"

        # swaync
        "blur, swaync-control-center"
        "ignorezero, swaync-control-center"

        # rofi
        "blur, rofi"
        "ignorezero, rofi"

        # fuzzel
        "blur, launcher"
        "ignorezero, launcher"

        # fnott
        "blur, notifications"
        "ignorezero, notifications"
      ];

      workspace = [
        # Smart Gaps
        "w[tv1], gapsout:0, gapsin:0"
        "f[1], gapsout:0, gapsin:0"

        "special:magic, gapsout:75"

        "special:obsidian, on-created-empty:uwsm app -- obsidian"

        "special:spotify, on-created-empty:uwsm app -- spotify"
        "special:spotify, gapsout:75"

        "special:monitor, on-created-empty:uwsm app -- xdg-terminal-exec btop"
        "special:monitor, gapsout:50"

        "special:discord, on-created-empty:uwsm app -- vesktop"
        "special:discord, gapsout:75"

        "special:todoist, on-created-empty:uwsm app -- todoist-electron"
        "special:todoist, gapsout:75"
      ];
    };
  };
}
