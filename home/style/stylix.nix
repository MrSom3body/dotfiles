{pkgs, ...}: {
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
}
