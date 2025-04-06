{
  lib,
  config,
  pkgs,
  settings,
  ...
}: let
  cfg = config.my.programs.rclone;
in {
  options.my.programs.rclone = {
    enable = lib.mkEnableOption "the rclone program";
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.rclone;
      defaultText = lib.literalExpression "pkgs.rclone";
      description = "foo package to use.";
    };

    protonDriveBackup = {
      enable = lib.mkEnableOption "the rclone proton backup service to backup your ~";
      filters = lib.mkOption {
        type = lib.types.str;
        default = "- *";
        description = "filter files like described here: https://rclone.org/filtering";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [cfg.package];

    systemd.user = let
      unitName = "rclone-proton-drive-backup";
      mountpoint = "proton:Computers/${settings.hostname}";
      filterFile = pkgs.writeText "rclone-filters" cfg.protonDriveBackup.filters;
    in
      lib.mkIf cfg.protonDriveBackup.enable {
        services.${unitName} = {
          Unit.Description = "Sync some folders to Proton Drive automatically";

          Service = {
            Type = "oneshot";
            ExecStartPre = pkgs.writeShellScript "waitForNetwork" ''
              while ! ${pkgs.inetutils}/bin/ping -c 1 9.9.9.9; do
                sleep 1
              done
            '';
            ExecStart = pkgs.writeShellScript "rcloneProtonDriveBackupScript" ''
              ${pkgs.rclone}/bin/rclone --config=.config/rclone/rclone.conf \
                sync ${config.home.homeDirectory} ${mountpoint}/ \
                --filter-from ${filterFile}
                -vv \
                --ignore-errors \
                --protondrive-replace-existing-draft=true
            '';
          };
        };

        timers.${unitName} = {
          Unit = {
            Description = "Proton Drive Backup Timer";
          };

          Timer = {
            OnCalendar = "daily";
            Unit = "${unitName}.service";
            Persistent = true;
          };

          Install.WantedBy = ["timers.target"];
        };
      };
  };
}
