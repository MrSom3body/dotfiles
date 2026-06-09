{
  flake.modules.homeManager.desktop = { config, ... }: {
    gtk.gtk3.bookmarks = map (dir: "file://${config.home.homeDirectory}/" + dir) [
      "dotfiles"
      "Desktop"
      "Documents"
      "Projects"
      "Downloads"
      "Games"
      "Music"
      "Videos"
      "Documents/Notes"
    ];
  };
}
