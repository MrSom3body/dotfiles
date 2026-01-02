{ lib, ... }:
let
  inherit (lib) getExe;
  inherit (lib) escapeRegex;
in
{
  flake.modules.homeManager.desktop =
    {
      osConfig ? null,
      config,
      pkgs,
      ...
    }:
    let
      portalPackage =
        if osConfig != null then
          osConfig.programs.hyprland.portalPackage
        else
          config.wayland.windowManager.hyprland.portalPackage;
    in
    {
      wayland.windowManager.hyprland.settings = {
        ecosystem.enforce_permissions = true;

        permission = [
          # Allow hyprlock
          "${escapeRegex (getExe config.programs.hyprlock.package)}, screencopy, allow"

          # Allow xdph
          "${
            escapeRegex ((builtins.toString portalPackage) + "/libexec/.xdg-desktop-portal-hyprland-wrapped")
          }, screencopy, allow"

          # Allow to screenrecording & screenshots
          "${escapeRegex (getExe pkgs.grim)}, screencopy, allow"
          "${escapeRegex (getExe pkgs.wl-screenrec)}, screencopy, allow"
          "${escapeRegex (getExe pkgs.hyprpicker)}, screencopy, allow"
        ];
      };
    };
}
