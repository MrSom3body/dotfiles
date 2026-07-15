{ ... }: {
  flake.modules.nixos.laptop = {
    services = {
      tuned.enable = false;
      tlp.enable = false;
      power-profiles-daemon.enable = false;
      watt.enable = true;
    };
  };
}
