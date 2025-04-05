{
  lib,
  pkgs,
  ...
}: {
  stylix = {
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

  # TODO remove when https://github.com/danth/stylix/issues/865 get resolved
  nixpkgs.overlays = lib.mkForce null;
}
