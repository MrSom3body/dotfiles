{
  flake.modules.nixos.base = {
    hardware.enableAllFirmware = true;
    services.fwupd.enable = true;
  };
}
