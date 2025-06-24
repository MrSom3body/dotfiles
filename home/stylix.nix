{
  lib,
  osConfig ? null,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;

  inherit (lib) mkEnableOption;
  cfg = config.my.styling;
in {
  options.my.styling = {
    enable =
      mkEnableOption "stylix"
      // {
        default =
          if osConfig != null
          then osConfig.stylix.enable
          else false;
      };
  };

  config = mkIf cfg.enable {
    stylix = {
      overlays.enable = false;

      targets = {
        firefox.profileNames = ["default"];
        fish.enable = false;
        kitty.variant256Colors = true;
        rofi.enable = false;
        spicetify.enable = false;
        waybar = {
          addCss = false;
          font = "sansSerif";
        };
      };

      iconTheme = {
        enable = true;
        package = pkgs.papirus-icon-theme;
        light = "Papirus-Light";
        dark = "Papirus-Dark";
      };
    };
  };
}
