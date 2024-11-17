{dotfiles, ...}: {
  wayland.windowManager.hyprland.settings = {
    "$floatingSize" = "600 400";
    "$polkit" = "polkit-gnome-authentication-agent-1";
    "$pwvucontrol" = "com.saivert.pwvucontrol";

    windowrulev2 = [
      # "float, class:^($polkit)$"
      # "size $floatingSize, class:^($polkit)$"
      # "center, class:^($polkit)$"

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

      # make Firefox PiP window floating and sticky
      "float, title:^(Picture-in-Picture)$"
      "pin, title:^(Picture-in-Picture)$"

      # Proton Pass
      "float, class:^(Proton Pass)$"

      # GNS3
      "stayfocused, class:^(gns3)$, title:^(Change hostname)$"

      # Calculator
      "float, class:^(org.gnome.Calculator)$"
      "size > >, class:^(org.gnome.Calculator)$"

      # Move apps to workspaces
      "workspace special:discord, class:^(vesktop)$"
      "workspace special:lunatask, class:^(Lunatask)$"

      # Dim some programs
      "dimaround, class:^(xdg-desktop-portal-gtk)$"
      "dimaround, class:^(polkit-gnome-authentication-agent-1)$"

      # don't render hyprbars on tiling windows
      "plugin:hyprbars:nobar, floating:0"

      # Games
      "immediate, class:^(Minecraft.*)$"
      "immediate, title:^(Warframe)$"
      "immediate, class:^(steam_app_1966720)$"
      "immediate, class:^(steam_app_960090)$" # Bloons TD6
      "immediate, class:^(hl2_linux)$" # Left 4 Dead 2
    ];

    layerrule = [
      # Sway notification Center
      "animation slide right, swaync-control-center"
      "dimaround, swaync-control-center"
      "blur, swaync-control-center"
      "ignorezero, swaync-control-center"

      # waybar
      "blur, waybar"
      "ignorezero, waybar"

      # Rofi
      "animation slide, rofi"
      "dimaround, rofi"
      "blur, rofi"
      "ignorezero, rofi"

      # fuzzel
      "animation slide, launcher"
      "dimaround, launcher"
      "blur, launcher"
      "ignorezero, launcher"
    ];

    workspace = [
      "special:special, gapsout:75"

      "special:obsidian, on-created-empty:uwsm app -- obsidian"

      "special:spotify, on-created-empty:uwsm app -- spotify"
      "special:spotify, gapsout:75"

      "special:monitor, on-created-empty:uwsm app -- ${dotfiles.terminal} -- btop"
      "special:monitor, gapsout:50"

      "special:discord, on-created-empty:uwsm app -- vesktop"
      "special:discord, gapsout:75"

      "special:lunatask, on-created-empty:uwsm app -- lunatask"
      "special:lunatask, gapsout:75"
    ];
  };
}
