{
  flake.modules.homeManager.desktop = {
    services.psd = {
      enable = true;
      resyncTimer = "10m";
    };
  };
}
