{
  flake.modules.nixos.asus = {
    services = {
      asusd.enable = true;
      supergfxd.enable = true;
    };
  };
}
