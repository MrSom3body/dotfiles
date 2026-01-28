{ inputs, ... }:
let
  rgb = color: "rgb(${color})";
in
{
  flake.modules.homeManager.hyprland =
    { config, pkgs, ... }:
    {
      wayland.windowManager.hyprland = {
        plugins = [ inputs.hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}.hyprexpo ];
        settings = {
          plugin.hyprexpo = {
            columns = 3;
            gap_size = 10;
            bg_col = rgb config.lib.stylix.colors.base00;
            workspace_method = "first 1";

            enable_gesture = true;
            gesture_fingers = 3;
            gesture_distance = 300;
            gesture_positive = false;
          };

          hyprexpo-gesture = [
            "3, vertical, expo"
          ];

          bindd = [
            "SUPER, U, Open expose, hyprexpo:expo, toggle"
          ];
        };
      };
    };
}
