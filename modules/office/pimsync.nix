{
  flake.modules.homeManager.office = {
    programs.pimsync.enable = true;
    services.pimsync.enable = true;
  };
}
