{
  flake.modules.homeManager.desktop = { config, ... }: {
    services.tailscale-systray = {
      enable = true;
      theme = config.stylix.polarity;
    };
  };
}
