{ lib, ... }:
{
  flake.modules.homeManager.hyprland =
    { pkgs, ... }:
    {
      wayland.windowManager.hyprland.settings = {
        bindd = [
          # Reset Zoom
          "SUPER SHIFT, minus, Reset zoom, exec, hyprctl -q keyword cursor:zoom_factor 1"
        ];

        bindde =
          let
            jq = lib.getExe pkgs.jq;
          in
          [
            "SUPER, plus, Zoom in, exec, hyprctl -q keyword cursor:zoom_factor $(hyprctl getoption cursor:zoom_factor -j | ${jq} '.float * 1.1')"
            "SUPER, minus, Zoom out, exec, hyprctl -q keyword cursor:zoom_factor $(hyprctl getoption cursor:zoom_factor -j | ${jq} '(.float * 0.9) | if . < 1 then 1 else . end')"
          ];
      };
    };
}
