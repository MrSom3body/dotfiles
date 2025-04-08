{pkgs, ...}: {
  systemd.user.services.power-monitor = {
    Unit = {
      Description = "Power Monitor";
      After = ["power-profiles-daemon.service"];
    };

    Service = {
      Type = "simple";
      ExecStart = "${pkgs.power-monitor}/bin/power-monitor";
      Restart = "on-failure";
    };

    Install.WantedBy = ["default.target"];
  };
}
