{config, ...}: {
  imports = [
    ../../home/profiles/workstation.nix

    # terminals
    ../../home/terminal/emulators/alacritty.nix
    ../../home/terminal/emulators/foot.nix
    ../../home/terminal/emulators/kitty.nix

    # programs
    ../../home/programs/games
    ../../home/programs/school

    # system services
    ../../home/services/system/kdeconnect.nix
    ../../home/services/system/rclone.nix
    ../../home/services/system/syncthing.nix
  ];

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
