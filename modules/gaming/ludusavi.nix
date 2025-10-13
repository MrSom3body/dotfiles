{ lib, ... }:
{
  flake.modules.homeManager.gaming =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.ludusavi ];

      systemd.user = {
        services.ludusavi-backup = {
          Unit.Description = "Ludusavi backup";
          Service = {
            ExecStartPre = pkgs.writeShellScript "waitForNetwork" ''
              while ! ${pkgs.inetutils}/bin/ping -c 1 9.9.9.9; do
                sleep 1
              done
            '';
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
          Install.WantedBy = [ "timers.target" ];
        };
      };
    };
}
