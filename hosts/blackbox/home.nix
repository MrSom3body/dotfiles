{
  imports = [
    ../../home/profiles/workstation.nix

    # terminals
    ../../home/terminal/emulators/alacritty.nix
    ../../home/terminal/emulators/kitty.nix

    # programs
    ../../home/programs/games
    ../../home/programs/school

    # media services
    ../../home/services/media/playerctl.nix

    # system services
    ../../home/services/system/kdeconnect.nix
    ../../home/services/system/rclone.nix
    ../../home/services/system/syncthing.nix
  ];
}
