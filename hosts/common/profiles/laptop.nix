{
  imports = [
    ./workstation.nix

    ../optional/hardware/bluetooth.nix

    ../optional/services/location.nix
    ../optional/services/power.nix
  ];
}
