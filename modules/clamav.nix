{
  flake.modules.nixos.clamav = {
    services.clamav = {
      daemon.enable = true;
      scanner.enable = true;
      updater.enable = true;
    };
  };
}
