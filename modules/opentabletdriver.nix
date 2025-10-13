{
  flake.modules.nixos.opentabletdriver = {
    hardware.opentabletdriver = {
      enable = true;
      daemon.enable = true;
    };
  };
}
