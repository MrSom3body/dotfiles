{
  imports = [
    ./workstation.nix

    ../optional/network/wifi.nix

    ../optional/hardware/bluetooth.nix

    ../optional/services/location.nix
    ../optional/services/power.nix
  ];
}
