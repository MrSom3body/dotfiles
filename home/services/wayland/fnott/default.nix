{
  lib,
  config,
  pkgs,
  settings,
  ...
}:
with config.lib.stylix.colors;
with config.stylix.fonts; let
  fg = color: color + "ff";
  bg = color: color + lib.toHexString (((builtins.floor (config.stylix.opacity.popups * 100 + 0.5)) * 255) / 100);

  # this is a hacky workaround for https://codeberg.org/dnkl/fnott/issues/137
  fnott-settings = {
    globalSection = {
      min-width = 500;
      max-width = 500;

      icon-theme = config.gtk.iconTheme.name;

      selection-helper = "fuzzel --dmenu0 --prompt \"󰛰 \" --placeholder \"Search for notification action...\"";
      selection-helper-uses-null-separator = true;

      edge-margin-vertical = 10;
      edge-margin-horizontal = 10;
      notification-margin = 10;

      background = bg base00;
      border-color = fg base0D;
      progress-bar-color = fg base02;

      border-size = settings.appearance.border.size;
      border-radius = settings.appearance.border.radius;

      title-format = "<i>%a%A<i>";
      title-font = "${sansSerif.name}:size=${toString sizes.popups}";
      title-color = fg base05;
      summary-format = "<b>%s</b>";
      summary-font = "${sansSerif.name}:size=${toString sizes.popups}";
      summary-color = fg base05;
      body-format = "%b";
      body-font = "${sansSerif.name}:size=${toString sizes.popups}";
      body-color = fg base05;

      max-timeout = 30;
      default-timeout = 8;
      idle-timeout = 60;
    };

    sections = {
      low = {
        border-color = fg base03;
        default-timeout = 5;
      };

      critical = {
        layer = "overlay";

        border-color = fg base08;

        max-timeout = 0;
        default-timeout = 0;
      };
    };
  };
in {
  services.fnott = {
    enable = true;
  };

  xdg.configFile."fnott/fnott.ini".source = lib.mkForce (pkgs.writeText "fnott.ini" (lib.generators.toINIWithGlobalSection {} fnott-settings));

  home.file."bin/fnott-dnd" = {
    source = ./scripts/fnott-dnd.fish;
    executable = true;
  };
}
