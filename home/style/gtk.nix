{pkgs, ...}: {
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
      name = "Papirus";
    };
  };
}
