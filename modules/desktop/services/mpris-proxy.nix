{
  flake.modules.homeManager.desktop = {
    services.mpris-proxy = {
      enable = true;
    };
  };
}
