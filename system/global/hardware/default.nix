{
  imports = [
    ./fwupd.nix
    ./zswap.nix
  ];

  hardware.enableAllFirmware = true;
}
