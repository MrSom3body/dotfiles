{config, ...}: {
  gtk.gtk3.bookmarks = map (dir: "file://${config.home.homeDirectory}/" + dir) [
    "Desktop"
    "Documents"
    "Documents/Codes"
    "Documents/Schule/2024-25"
    "Downloads"
    "Games"
    "Music"
    "Notes"
    "Sync"
    "Videos"
    "dotfiles"
  ];
}
