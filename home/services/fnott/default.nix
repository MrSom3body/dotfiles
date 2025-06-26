{
  lib,
  config,
  pkgs,
  settings,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib) mkEnableOption;
  cfg = config.my.services.fnott;
in {
  options.my.services.fnott = {
    enable = mkEnableOption "the fnott notification service";
  };

  config = mkIf cfg.enable {
    services.fnott = {
      enable = true;
      settings = {
        main = {
          min-width = 500;
          max-width = 500;

          icon-theme = config.gtk.iconTheme.name;

          selection-helper = "fuzzel --dmenu0 --prompt \"󰛰 \" --placeholder \"Search for notification action...\"";
          selection-helper-uses-null-separator = true;

          edge-margin-vertical = 10;
          edge-margin-horizontal = 10;
          notification-margin = 10;

          border-size = settings.appearance.border.size;
          border-radius = settings.appearance.border.radius;

          title-format = "<i>%a%A<i>";
          summary-format = "<b>%s</b>";
          body-format = "%b";

          max-timeout = 30;
          default-timeout = 8;
          idle-timeout = 60;
        };

        low = {
          default-timeout = 5;
        };

        critical = {
          layer = "overlay";

          max-timeout = 0;
          default-timeout = 0;
        };
      };
    };

    home.packages = [pkgs.fnott-dnd];
  };
}
