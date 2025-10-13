{
  flake.modules.homeManager.rclone =
    {
      osConfig,
      config,
      pkgs,
      ...
    }:
    {
      home.packages = [ pkgs.rclone ];

      systemd.user =
        let
          unitName = "rclone-proton-drive-backup";
          mountpoint = "proton:Computers/${osConfig.networking.hostName}";
          filterFile = pkgs.writeText "rclone-filters" ''
            - {{\.?venv}}/**
            - .devenv/**
            - .direnv/**
            - /Documents/Codes/nixpkgs/**
            - /Documents/Schule/2024-25/INSY/oracle-volume/**
            + /Desktop/**
            + /Documents/**
            + /Games/Saves/**
            + /Music/**
            + /Pictures/**
            + /Templates/**
            + /Videos/**
            - *
          '';
        in
        {
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
                  --filter-from ${filterFile} \
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

            Install.WantedBy = [ "timers.target" ];
          };
        };
    };
}
