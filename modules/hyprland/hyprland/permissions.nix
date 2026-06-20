{ lib, ... }:
let
  inherit (lib) getExe escapeRegex;
in
{
  flake.modules.homeManager.hyprland =
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
        config.ecosystem.enforce_permissions = true;

        permission = [
          {
            binary = escapeRegex (getExe config.programs.hyprlock.package);
            type = "screencopy";
            mode = "allow";
          }
          {
            binary = escapeRegex ((toString portalPackage) + "/libexec/.xdg-desktop-portal-hyprland-wrapped");
            type = "screencopy";
            mode = "allow";
          }
          {
            binary = escapeRegex (getExe pkgs.grim);
            type = "screencopy";
            mode = "allow";
          }
          {
            binary = escapeRegex (getExe pkgs.wl-screenrec);
            type = "screencopy";
            mode = "allow";
          }
          {
            binary = escapeRegex (getExe pkgs.hyprpicker);
            type = "screencopy";
            mode = "allow";
          }
        ];
      };
    };
}
