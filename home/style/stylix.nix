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

  # TODO remove when https://github.com/danth/stylix/issues/865 get resolved
  nixpkgs.overlays = lib.mkForce null;
}
