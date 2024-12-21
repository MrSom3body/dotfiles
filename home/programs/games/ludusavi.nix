{
  lib,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    ludusavi
  ];

  systemd.user = {
    services.ludusavi-backup = {
      Unit.Description = "Ludusavi backup";
      Service = {
        ExecStart = "${lib.getExe pkgs.ludusavi} backup --force";
      };
    };
    timers.ludusavi-backup = {
      Unit.Description = "Ludusavi backup timer";
      Timer = {
        OnCalendar = "daily";
        Unit = "ludusavi-backup.service";
        Persistent = true;
      };
      Install.WantedBy = ["timers.target"];
    };
  };
}
