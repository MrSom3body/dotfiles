{
  config,
  pkgs,
  dotfiles,
  ...
}: {
  stylix = {
    enable = true;
    autoEnable = false;
    image = dotfiles.wallpaper;
    polarity = dotfiles.polarity;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/${dotfiles.theme}.yaml";

    fonts = {
      sizes = {
        applications = 14;
        desktop = 14;
        popups = 14;
        terminal = 13;
      };
      sansSerif = {
        package = pkgs.nerdfonts.override {fonts = ["Ubuntu"];};
        name = "Ubuntu Nerd Font";
      };
      serif = config.stylix.fonts.sansSerif;
      monospace = {
        package = pkgs.nerdfonts.override {fonts = ["FiraCode"];};
        name = "Fira Code Nerd Font";
      };
      emoji = {
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };
    };

    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 24;
    };

    opacity = {
      applications = 0.95;
      desktop = 0.7;
      popups = 0.95;
      terminal = 0.95;
    };

    targets = {
      chromium.enable = true;
      console.enable = true;
      fish.enable = true;
      gnome.enable = true;
      gtk.enable = true;
      nixos-icons.enable = true;
      plymouth.enable = true;
    };
  };
}
