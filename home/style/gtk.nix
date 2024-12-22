{
  pkgs,
  dotfiles,
  ...
}: {
  gtk = {
    enable = true;

    # cursorTheme = {
    #   name = "Bibata-Modern-Classic";
    #   package = pkgs.bibata-cursors;
    #   size = 24;
    # };
    #
    iconTheme = {
      package = pkgs.papirus-icon-theme;
      name =
        if dotfiles.appearance.polarity == "dark"
        then "Papirus-Dark"
        else "Papirus-Light";
    };
  };
}
