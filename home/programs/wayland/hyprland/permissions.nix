{
  lib,
  osConfig ? null,
  config,
  inputs,
  pkgs,
  ...
}: {
  wayland.windowManager.hyprland.settings = {
    ecosystem.enforce_permissions = true;

    permission = [
      # Allow xdph
      "${
        if osConfig != null
        then osConfig.programs.hyprland.portalPackage
        else config.wayland.windowManager.hyprland.portalPackage
      }/libexec/.xdg-desktop-portal-hyprland-wrapped, screencopy, allow"

      # Allow to screenrecording & screenshots
      "${lib.getExe pkgs.grim}, screencopy, allow"
      "${lib.getExe pkgs.wl-screenrec}, screencopy, allow"
      "${lib.getExe inputs.hyprpicker.packages.${pkgs.system}.hyprpicker}, screencopy, allow"
    ];
  };
}
