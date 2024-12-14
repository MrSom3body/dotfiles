{
  lib,
  config,
  pkgs,
  dotfiles,
  ...
}:
with config.lib.stylix.colors;
with config.stylix.fonts; let
  opacity = lib.toHexString (((builtins.ceil (config.stylix.opacity.popups * 100)) * 255) / 100);
  # this is a hacky workaround for https://codeberg.org/dnkl/fnott/issues/137
  settings = {
    globalSection = {
      min-width = 500;
      max-width = 500;

      icon-theme = config.gtk.iconTheme.name;

      selection-helper = "fuzzel --dmenu0 --prompt \"󰛰 \" --placeholder \"Search for notification action...\"";
      selection-helper-uses-null-separator = true;

      edge-margin-vertical = 10;
      edge-margin-horizontal = 10;
      notification-margin = 10;

      background = base00 + opacity;
      border-color = base0D + "ff";
      progress-bar-color = base02 + "ff";

      border-size = 3;
      border-radius = dotfiles.rounding;

      title-format = "<i>%a%A<i>";
      title-font = "${sansSerif.name}:size=${toString sizes.popups}";
      title-color = base05 + "ff";
      summary-format = "<b>%s</b>";
      summary-font = "${sansSerif.name}:size=${toString sizes.popups}";
      summary-color = base05 + "ff";
      body-format = "%b";
      body-font = "${sansSerif.name}:size=${toString sizes.popups}";
      body-color = base05 + "ff";

      max-timeout = 30;
      default-timeout = 8;
      idle-timeout = 60;
    };

    sections = {
      low = {
        border-color = base03 + "ff";
        default-timeout = 5;
      };

      critical = {
        layer = "overlay";

        border-color = base08 + "ff";

        max-timeout = 0;
        default-timeout = 0;
      };
    };
  };
in {
  services.fnott = {
    enable = true;
  };

  xdg.configFile."fnott/fnott.ini".source = lib.mkForce (pkgs.writeText "fnott.ini" (lib.generators.toINIWithGlobalSection {} settings));

  home.file."bin/fnott-dnd.fish" = {
    source = ./scripts/fnott-dnd.fish;
    executable = true;
  };
}
