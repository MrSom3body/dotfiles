{
  imports = [
    ../../system/core

    ../../system/hardware/fwupd.nix

    ../../system/network
    ../../system/network/avahi.nix

    ../../system/programs

    ../../system/services

    ../../system/virtualisation/vm.nix

    ../../system/style/stylix.nix
  ];

  hardware.enableAllFirmware = true;
}
