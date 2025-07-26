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
      animation = [
        "fade, 1, 4, default"

        "border, 1, 2, default"
        "windows, 1, 3, default, slide"

        "workspaces, 1, 2, default, slide"
      ];
    };
  };
}
