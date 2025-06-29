{
  lib,
  osConfig ? null,
  config,
  inputs,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib) getExe;
  inherit (lib) escapeRegex;

  cfg = config.my.desktop.hyprland;
  portalPackage =
    if osConfig != null
    then osConfig.programs.hyprland.portalPackage
    else config.wayland.windowManager.hyprland.portalPackage;
in {
  config = mkIf cfg.enable {
    wayland.windowManager.hyprland.settings = {
      ecosystem.enforce_permissions = true;

      permission = [
        # Allow hyprlock
        "${escapeRegex (getExe config.programs.hyprlock.package)}, screencopy, allow"

        # Allow xdph
        "${escapeRegex ((builtins.toString portalPackage) + "/libexec/.xdg-desktop-portal-hyprland-wrapped")}, screencopy, allow"

        # Allow to screenrecording & screenshots
        "${escapeRegex (getExe pkgs.grim)}, screencopy, allow"
        "${escapeRegex (getExe pkgs.wl-screenrec)}, screencopy, allow"
        "${escapeRegex (getExe inputs.hyprpicker.packages.${pkgs.system}.hyprpicker)}, screencopy, allow"
      ];
    };
  };
}
