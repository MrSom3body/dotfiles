{
  config,
  pkgs,
  dotfiles,
  ...
}: {
  stylix = {
    enable = true;
    image = dotfiles.wallpaper;
    inherit (dotfiles) polarity;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/${dotfiles.theme}.yaml";

    fonts = {
      sizes = with dotfiles.fonts; {
        applications = sans.size;
        desktop = sans.size;
        popups = sans.size;
        terminal = mono.size;
      };
      sansSerif = with dotfiles.fonts.sans; {
        package = pkgs.nerd-fonts.${pkgName};
        inherit name;
      };
      serif = config.stylix.fonts.sansSerif;
      monospace = with dotfiles.fonts.mono; {
        package = pkgs.nerd-fonts.${pkgName};
        inherit name;
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
  };
}
