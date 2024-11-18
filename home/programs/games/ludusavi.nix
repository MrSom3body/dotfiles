{pkgs, ...}: {
  home.packages = with pkgs; [
    ludusavi
  ];

  systemd.user = {
    services.ludusavi-backup = {
      Unit.Description = "Ludusavi backup";
      Service = {
        ExecStart = "ludusavi backup --force";
      };
    };
    timers.ludusavi-backup = {
      Unit.Description = "Ludusavi backup timer";
      Timer = {
        OnCalendar = "*-*-* 00:00:00";
        Unit = "ludusavi-backup.service";
      };
      Install.WantedBy = ["timers.target"];
    };
  };
}
