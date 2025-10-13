{
  flake.modules.nixos.desktop = {
    services = {
      power-profiles-daemon.enable = true;

      upower.enable = true;
    };
  };
}
