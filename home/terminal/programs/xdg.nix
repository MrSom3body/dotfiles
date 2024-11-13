{
  config,
  pkgs,
  dotfiles,
  ...
}: {
  xdg = {
    mimeApps = {
      enable = true;
      defaultApplications = {
        "application/pdf" = ["org.gnome.Papers.desktop"]; # PDFs
        "application/zip" = ["org.gnome.Nautilus.desktop" "org.gnome.FileRoller.desktop"]; # ZIPs
        "image/*" = ["org.gnome.Loupe.desktop"]; # Images
        "image/jpeg" = ["org.gnome.Loupe.desktop"]; # Images
        "image/jpg" = ["org.gnome.Loupe.desktop"]; # Images
        "image/png" = ["org.gnome.Loupe.desktop"]; # Images
        "inode/directory" = ["yazi"]; # Files
        "text/plain" = ["Helix.desktop"]; # Plain text
        "x-scheme-handler/http" = ["firefox.desktop"]; # Links
        "x-scheme-handler/https" = ["firefox.desktop"]; # Links
        "x-scheme-handler/mailto" = ["firefox.desktop"]; # Links
      };
    };

    userDirs = {
      enable = true;
      createDirectories = true;
      extraConfig = {
        XDG_SCREENSHOTS_DIR = "${config.xdg.userDirs.pictures}/Screenshots";
      };
    };
  };

  home.packages = [
    # used by `gio open` and xdp-gtk
    (pkgs.writeShellScriptBin "xdg-terminal-exec" ''
      ${dotfiles.terminal} "$@"
    '')
    pkgs.xdg-utils
  ];
}
