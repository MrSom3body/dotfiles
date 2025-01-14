{pkgs, ...}: {
  stylix = {
    targets = {
      fish.enable = false;
      kitty.variant256Colors = true;
      neovim.enable = false;
      rofi.enable = false;
      spicetify.enable = false;
      swaync.enable = false;
      waybar.enable = false;
    };

    iconTheme = {
      enable = true;
      package = pkgs.papirus-icon-theme;
      light = "Papirus-Light";
      dark = "Papirus-Dark";
    };
  };
}
