{ self, config, ... }:
let
  inherit (config.flake) meta;
in
{
  flake.modules.homeManager.desktop =
    { config, pkgs, ... }:
    {
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

            border-radius = meta.appearance.border.radius;
            border-size = meta.appearance.border.size;

            title-format = "<i>%a%A<i>";
            summary-format = "<b>%s</b>";
            body-format = "%b";

            progress-style = "background";

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

      home.packages = [ self.packages.${pkgs.system}.fnott-dnd ];
    };
}
