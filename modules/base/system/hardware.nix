{
  flake.modules.nixos.nixos = {
    hardware.enableAllFirmware = true;
    services.fwupd.enable = true;
  };
}
