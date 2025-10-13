{
  flake.modules.homeManager.desktop =
    { config, ... }:
    {
      gtk.gtk3.bookmarks = map (dir: "file://${config.home.homeDirectory}/" + dir) [
        "Desktop"
        "Documents"
        "Downloads"
        "Games"
        "Music"
        "Videos"
        "dotfiles"
        "Documents/Codes"
        "Documents/Notes"
        "Documents/Schule/2025-26"
      ];
    };
}
