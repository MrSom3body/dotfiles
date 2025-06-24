{
  imports = [
    ./server.nix

    # terminals
    ../terminal/emulators/foot.nix

    # system services
    ../services/system/polkit.nix
    ../services/system/udiskie.nix
  ];

  my = {
    desktop.enable = true;
  };
}
