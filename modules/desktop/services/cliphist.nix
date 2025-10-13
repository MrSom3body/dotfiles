{
  flake.modules.homeManager.desktop = {
    services.cliphist = {
      enable = true;
      allowImages = true;
    };
  };
}
