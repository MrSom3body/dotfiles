{ self, config, ... }:
{
  flake.modules.homeManager = {
    laptop = {
      imports = [ config.flake.modules.homeManager.power-monitor ];
    };

    power-monitor =
      { pkgs, ... }:
      {
        systemd.user.services.power-monitor = {
          Unit = {
            Description = "Power Monitor";
            After = [ "power-profiles-daemon.service" ];
          };

          Service = {
            Type = "simple";
            ExecStart = "${self.packages.${pkgs.stdenv.hostPlatform.system}.power-monitor}/bin/power-monitor";
            Restart = "on-failure";
          };

          Install.WantedBy = [ "default.target" ];
        };
      };
  };
}
