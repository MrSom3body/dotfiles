{
  flake.modules.homeManager.shell = {
    programs.tealdeer = {
      enable = true;
      settings.updates.auto_update = true;
    };
  };
}
