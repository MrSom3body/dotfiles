{
  imports = [
    ./workstation.nix

    ../optional/hardware/bluetooth.nix
    ../optional/hardware/powersave.nix

    ../optional/services/location.nix
    ../optional/services/power.nix
  ];

  system.autoUpgrade.operation = "boot";
}
