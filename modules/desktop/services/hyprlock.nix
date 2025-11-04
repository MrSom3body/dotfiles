{ config, inputs, ... }:
let
  inherit (config.flake) meta;
in
{
  flake.modules.homeManager.desktop =
    { config, pkgs, ... }:
    let
      inherit (config.lib.stylix) colors;
      rgb = color: "rgb(${color})";
    in
    {
      programs.hyprlock = {
        enable = true;

        package = inputs.hyprlock.packages.${pkgs.stdenv.hostPlatform.system}.hyprlock;

        settings = {
          general.hide_cursor = false;

          auth.fingerprint.enabled = true;

          background = {
            blur_size = 4;
            blur_passes = 2;
            brightness = 0.75;
          };

          input-field = {
            size = "300, 50";
            outline_thickness = 3;
            dots_size = 0.25;
            dots_spacing = 0.15;
            dots_center = true;
            dots_rounding = -1;
            fade_on_empty = false;
            fade_timeout = 1000;
            placeholder_text = "<span foreground=\"##${colors.base05}\">󰌾  Logged in as <span foreground=\"##${colors.base0D}\"><i>$USER</i></span></span>";
            hide_input = false;
            rounding = -1;
            fail_text = "<i>$FAIL <b>($ATTEMPTS)</b></i>";
            capslock_color = rgb colors.base0A;

            position = "0, -70";
            halign = "center";
            valign = "center";
          };

          image = {
            path = "~/.face";
            size = 150;
            border_color = rgb colors.base0D;

            position = "0, 75";
            halign = "center";
            valign = "center";
          };

          label = [
            {
              text = "$TIME";
              color = rgb colors.base05;
              font_size = 90;
              font_family = config.stylix.fonts.sansSerif.name;
              position = "-30, 0";
              halign = "right";
              valign = "top";
            }
            {
              text = "cmd[update:43200000] echo \"$(date +\"%A, %d %B %Y\")\"";
              color = rgb colors.base05;
              font_size = 25;
              font_family = config.stylix.fonts.sansSerif.name;
              position = "-30, -150";
              halign = "right";
              valign = "top";
            }
            {
              text = "cmd[update:1000] ~/.config/hypr/scripts/get_battery_info.fish";
              color = rgb colors.base05;
              font_size = 18;
              font_family = config.stylix.fonts.sansSerif.name;
              position = "-30, -210";
              halign = "right";
              valign = "top";
            }
            {
              text = "cmd[update:1000] ~/.config/hypr/scripts/get_media_info.fish";
              color = rgb colors.base05;
              font_size = 18;
              font_family = config.stylix.fonts.sansSerif.name;
              position = "-30, -253";
              halign = "right";
              valign = "top";
            }
            {
              text = "Suspend";
              color = rgb colors.base05;
              position = "0, 10";
              halign = "center";
              valign = "bottom";
            }
          ];

          shape = [
            {
              color = rgb colors.base00;
              onclick = "systemctl suspend-then-hibernate";
              size = "120, 36"; # 10 (not visible) + 10 (from bottom) + 20 (arround text) + 16 (font)
              rounding = meta.appearance.border.radius;
              position = "0, 4";
              halign = "center";
              valign = "bottom";
            }
          ];
        };
      };
    };
}
