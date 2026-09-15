{
  flake.modules.nixos.nixos = {
    services.userborn.enable = true;
    system = {
      activatable = true;
      etc.overlay.enable = true;
    };
  };
}
