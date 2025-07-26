{
  config,
  inputs,
  pkgs,
  settings,
  ...
}:
{
  imports = [
    inputs.stylix.nixosModules.stylix
  ];

  stylix = {
    enable = true;
    image = settings.appearance.wallpaper;
    inherit (settings.appearance) polarity;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/${
      settings.appearance."${settings.appearance.polarity}-theme"
    }.yaml";

    fonts =
      let
        my-fonts = settings.appearance.fonts;
      in
      {
        sizes = {
          applications = my-fonts.sans.size;
          desktop = my-fonts.sans.size;
          popups = my-fonts.sans.size;
          terminal = my-fonts.mono.size;
        };
        sansSerif = {
          package = pkgs.nerd-fonts.${my-fonts.sans.pkgName};
          inherit (my-fonts.sans) name;
        };
        serif = config.stylix.fonts.sansSerif;
        monospace = {
          package = pkgs.nerd-fonts.${my-fonts.mono.pkgName};
          inherit (my-fonts.mono) name;
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

    targets.fish.enable = false;

    # opacity = {
    #   applications = 0.95;
    #   desktop = 0.95;
    #   popups = 0.75;
    #   terminal = 0.95;
    # };
  };
}
