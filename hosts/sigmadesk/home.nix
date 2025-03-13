{
  imports = [
    ../../home/profiles/server.nix

    # system services
    ../../home/services/system/rclone.nix
    ../../home/services/system/syncthing.nix
  ];
}
