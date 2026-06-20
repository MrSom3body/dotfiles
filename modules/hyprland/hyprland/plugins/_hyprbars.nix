{ inputs, ... }:
let
  rgb = color: "rgb(${color})";
in
{
  flake.modules.homeManager.hyprland = { config, pkgs, ... }: {
    wayland.windowManager.hyprland = {
      plugins = [ inputs.hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}.hyprbars ];
      settings = {
        plugin.hyprbars = {
          bar_height = config.stylix.fonts.sizes.desktop * 2;
          bar_color = rgb config.lib.stylix.colors.base00;
          "col.text" = rgb config.lib.stylix.colors.base05;

          bar_text_size = config.stylix.fonts.sizes.desktop;
          bar_text_font = config.stylix.fonts.sansSerif.name;

          bar_part_of_window = true;
          bar_precedence_over_border = true;

          icon_on_hover = true;
          bar_button_padding = config.stylix.fonts.sizes.desktop / 2;
          hyprbars-button =
            let
              buttonSize = toString (config.stylix.fonts.sizes.desktop * 1.5);
            in
            [
              "rgb(${config.lib.stylix.colors.base08}), ${buttonSize}, 󰖭, hyprctl dispatch 'hl.dsp.window.close()'"
              "rgb(${config.lib.stylix.colors.base0B}), ${buttonSize}, , hyprctl dispatch 'hl.dsp.window.fullscreen({ mode = \"maximized\" })'"
            ];
        };

        window_rule = [
          # don't render hyprbars on tiling windows
          {
            match = {
              floating = false;
            };
            "plugin:hyprbars:nobar" = true;
          }
          # don't render hyprbars on pinned floating windows (firefox PiP)
          {
            match = {
              floating = true;
              pinned = true;
            };
            "plugin:hyprbars:nobar" = true;
          }
        ];
      };
    };
  };
}
