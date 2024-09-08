{
  pkgs,
  lib,
  ...
}: {
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        margin = "5 5 0 5";
        height = 16;
        spacing = 0;
        include = ["~/.config/waybar/modules.json"];
        modules-left = [
          "clock"
          "privacy"
          "hyprland/window"
        ];
        modules-center = ["hyprland/workspaces"];
        modules-right = [
          "pulseaudio"
          "backlight"
          "group/power"
          "group/hardware"
          "tray"
          "custom/notification"
        ];
      };
    };
  };

  home.file.".config/waybar" = {
    source = ./configs;
    recursive = true;
  };

  home.activation.restartWaybar = lib.hm.dag.entryAfter ["installPackages"] ''
    if ${lib.getExe' pkgs.procps "pgrep"} waybar > /dev/null; then
      ${lib.getExe' pkgs.procps "pkill"} -SIGUSR2 waybar
    fi
  '';
}
