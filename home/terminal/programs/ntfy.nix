{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (lib) mkEnableOption;

  cfg = config.my.terminal.programs.ntfy;
in
{
  options.my.terminal.programs.ntfy = {
    enable = mkEnableOption "my ntfy config";
  };

  config = mkIf cfg.enable {
    sops = {
      secrets.karun-password.sopsFile = ../../../secrets/promethea/ntfy.yaml;
      templates."ntfy-client-config.yml" = {
        content = ''
          default-host: https://ntfy.sndh.dev
          default-user: karun
          default-password: ${config.sops.placeholder.karun-password}

          subscribe:
            - topic: sonarr
              command: ${lib.getExe pkgs.libnotify} -a "ntfy - $topic" "$t" "$m"
            - topic: radarr
              command: ${lib.getExe pkgs.libnotify} -a "ntfy - $topic" "$t" "$m"
            - topic: prowlarr
              command: ${lib.getExe pkgs.libnotify} -a "ntfy - $topic" "$t" "$m"
            - topic: jellyseer
              command: ${lib.getExe pkgs.libnotify} -a "ntfy - $topic" "$t" "$m"
            - topic: miniflux
              command: ${lib.getExe pkgs.libnotify} -a "ntfy - $topic" "$t" "$m"
        '';
      };
    };

    home = {
      packages = [ pkgs.ntfy-sh ];
      file.".config/ntfy/client.yml".source =
        config.lib.file.mkOutOfStoreSymlink
          config.sops.templates."ntfy-client-config.yml".path;
    };

    systemd.user.services = {
      ntfy-client = {
        Unit = {
          Description = "ntfy client";
          After = "network.target";
        };

        Service = {
          ExecStart = ''${pkgs.ntfy-sh}/bin/ntfy subscribe --config "%h/.config/ntfy/client.yml" --from-config'';
          Restart = "on-failure";
        };

        Install = {
          WantedBy = [ "default.target" ];
        };
      };
    };
  };
}
