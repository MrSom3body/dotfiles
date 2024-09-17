{config, ...}: {
  gtk.gtk3.bookmarks = map (dir: "file://${config.home.homeDirectory}/" + dir) [
    "Desktop"
    "Games"
    "Notes"
    "Sync"
    "Documents/Codes"
    "Documents/Schule/2024-25"
  ];
}
