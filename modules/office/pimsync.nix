{
  flake.modules.homeManager.office = {
    programs.pimsync.enable = true;
    services.pimsync.enable = true;

    systemd.user.services.pimsync.Service = {
      Restart = "on-failure";
      RestartSec = "5s";
    };
  };
}
