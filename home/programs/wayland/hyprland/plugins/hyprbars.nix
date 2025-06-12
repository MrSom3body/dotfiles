{
  config,
  inputs,
  pkgs,
  ...
}: let
  rgb = color: "rgb(${color})";
in {
  wayland.windowManager.hyprland = {
    plugins = [inputs.hyprland-plugins.packages.${pkgs.system}.hyprbars];
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
        hyprbars-button = let
          buttonSize = builtins.toString (config.stylix.fonts.sizes.desktop * 1.5);
        in [
          "rgb(${config.lib.stylix.colors.base08}), ${buttonSize}, 󰖭, hyprctl dispatch killactive"
          "rgb(${config.lib.stylix.colors.base0B}), ${buttonSize}, , hyprctl dispatch fullscreen 1"
        ];
      };

      windowrule = [
        # don't render hyprbars on tiling windows
        "plugin:hyprbars:nobar, floating:0"
      ];
    };
  };
}
