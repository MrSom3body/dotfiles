{
  imports = [
    ../../home/profiles/workstation.nix

    # terminals
    ../../home/terminal/emulators/alacritty.nix
    ../../home/terminal/emulators/ghostty.nix
    ../../home/terminal/emulators/kitty.nix

    # programs
    ../../home/programs/games
    ../../home/programs/school

    # system services
    ../../home/services/system/kdeconnect.nix
    ../../home/services/system/rclone.nix
    ../../home/services/system/syncthing.nix
  ];
}
