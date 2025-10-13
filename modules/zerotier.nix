{
  flake.modules.nixos.zerotier = {
    services.zerotierone = {
      enable = true;
    };
  };
}
