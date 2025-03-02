{
  pkgs,
  settings,
  ...
}: let
  unitName = "rclone-proton-drive-backup";
  mountpoint = "proton:Computers/${settings.hostname}";
  rcloneSync = dir: ''
    ${pkgs.rclone}/bin/rclone --config=.config/rclone/rclone.conf \
      sync ${dir} ${mountpoint}/${dir} \
      -vv \
      --ignore-errors \
      --protondrive-replace-existing-draft=true'';
  rcloneMultiSync = dirs: builtins.concatStringsSep "\n" (map rcloneSync dirs);
  rcloneProtonDriveBackupScript = pkgs.writeShellScript "rcloneProtonDriveBackupScript" "${
    rcloneMultiSync [
      "DataGripProjects"
      "Desktop"
      "Documents"
      "dotfiles"
      "Games/Saves"
      "Music"
      "Notes"
      "Pictures"
      "Public"
      "Templates"
      "Videos"
    ]
  }";
in {
  home.packages = with pkgs; [rclone];

  systemd.user = {
    services.${unitName} = {
      Unit.Description = "Sync some folders to Proton Drive automatically";

      Service = {
        Type = "oneshot";
        ExecStart = rcloneProtonDriveBackupScript;
      };
    };

    timers.${unitName} = {
      Unit = {
        Description = "Proton Drive Backup Timer";
        After = ["network-online.target"];
      };

      Timer = {
        OnCalendar = "daily";
        Unit = "${unitName}.service";
        Persistent = true;
      };

      Install.WantedBy = ["timers.target"];
    };
  };
}
