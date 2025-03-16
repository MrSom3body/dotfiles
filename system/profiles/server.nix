{...}: {
  imports = [
    ../../system/core

    ../../system/hardware/fwupd.nix

    ../../system/network
    ../../system/network/avahi.nix

    ../../system/programs
    ../../system/programs/command-not-found.nix

    ../../system/services
    ../../system/services/location.nix

    ../../system/virtualisation/vm.nix

    ../../system/style/stylix.nix
  ];

  hardware.enableAllFirmware = true;
}
