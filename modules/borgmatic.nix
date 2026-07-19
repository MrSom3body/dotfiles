{ lib, ... }@flakeArgs:
let
  flakeConfig = flakeArgs.config;
  inherit (flakeConfig.flake) meta;
in
{
  flake.modules.nixos.borgmatic =
    { config, pkgs, ... }:
    let
      inherit (config.networking) hostName;
    in
    {
      sops.secrets = {
        borgmatic-passphrase = {
          sopsFile = ../secrets/borgmatic.yaml;
          owner = "root";
          mode = "0400";
        };

        borgmatic-ssh-key = {
          sopsFile = ../secrets/borgmatic.yaml;
          path = "/etc/ssh/borgmatic_ed25519";
          owner = "root";
          mode = "0400";
        };

        borgmatic-ntfy-password = {
          sopsFile = ../secrets/borgmatic.yaml;
          owner = "root";
          mode = "0400";
        };

        borgmatic-gatus-token = {
          sopsFile = ../secrets/borgmatic-gatus.env;
          format = "dotenv";
        };
      };

      systemd.services.borgmatic.serviceConfig.EnvironmentFile = [
        "-${config.sops.secrets.borgmatic-gatus-token.path}"
      ];

      services.borgmatic = {
        enable = true;
        settings = {
          encryption_passcommand = "cat ${config.sops.secrets.borgmatic-passphrase.path}";
          ssh_command = "ssh -i /etc/ssh/borgmatic_ed25519 -o StrictHostKeyChecking=accept-new";

          compression = "auto,zstd";
          keep_daily = 7;
          keep_weekly = 4;
          keep_monthly = 6;

          checkpoint_interval = 300;

          repositories = [
            {
              path = "ssh://u564683-sub1@u564683-sub1.your-storagebox.de:23/./${hostName}";
              label = "som3box";
            }
          ];

          source_directories = [ "/home/karun" ];

          exclude_patterns = [
            # nix
            "/home/karun/.nix-defexpr"
            "/home/karun/.nix-profile"

            # development
            "*/.cache"
            "*/.direnv"
            "*/.venv"
            "*/__pycache__"
            "*/node_modules"
            "*/result"
            "*/result-*"

            # gaming
            "*/shadercache"
            "*/steamapps"
            "/home/karun/.local/share/Steam"
            "/home/karun/.local/share/umu"
            "/home/karun/.steam"

            # programs
            "/home/karun/.local/share/vicinae"

            # large & temporary files/directories
            "*.db-shm"
            "*.db-wal"
            "*.temp"
            "*.tmp"
            "*~"
            "/home/karun/.local/share/Trash"
            "/home/karun/Projects/nixpkgs"
            "/home/karun/Downloads"

            # virtualization & containers
            "/home/karun/.local/share/containers"
            "/home/karun/.local/share/distrobox"
            "/home/karun/.local/share/libvirt"
            "/home/karun/vmware"
            "/var/lib/libvirt/images"

            # AI/ML models (downloaded on demand, not user data)
            "/var/lib/private/ollama"

            # IDE caches & build tools
            "/home/karun/.gradle"
            "/home/karun/.m2"
            "/home/karun/.local/share/JetBrains"

            # service data that is redundant or regeneratable
            "/var/cache"
            "/var/lib/jellyfin/transcodes"
            "/var/lib/meilisearch"
            "/var/lib/postgresql"
            "/var/lib/systemd/coredump"
          ];

          patterns = [
            "+ /home/karun/Games/saves"
            "- /home/karun/Games"
          ];

          exclude_if_present = [ ".nobackup" ];

          checks = [
            {
              name = "repository";
              frequency = "2 weeks";
            }
            {
              name = "archives";
              frequency = "4 weeks";
            }
          ];

          postgresql_databases = lib.mkIf config.services.postgresql.enable [
            {
              name = "all";
              username = "postgres";
            }
          ];

          ntfy = {
            topic = "alerts";
            server = meta.services.ntfy.url;
            username = "borgmatic";
            password = "{credential file ${config.sops.secrets.borgmatic-ntfy-password.path}}";

            start = {
              title = "Backup started";
              message = "Starting backup on ${hostName}";
              priority = "low";
              tags = "${hostName},borgmatic,floppy_disk";
            };
            finish = {
              title = "Backup finished";
              message = "Backup completed successfully on ${hostName}";
              priority = "low";
              tags = "${hostName},borgmatic,white_check_mark";
            };
            fail = {
              title = "Backup failed";
              message = "Backup failed on ${config.networking.hostName}: {error}";
              priority = "high";
              tags = "${hostName},borgmatic,rotating_light";
            };
            states = [
              "start"
              "fail"
              "finish"
            ];
          };

          commands = [
            {
              after = "action";
              when = [ "create" ];
              run = [
                "${lib.getExe pkgs.curl} -X POST -H \"Authorization: Bearer $BORGMATIC_GATUS_TOKEN\" \"${meta.services.gatus.url}/api/v1/endpoints/backups_${hostName}/external?success=true\""
              ];
            }
            {
              after = "error";
              run = [
                "${lib.getExe pkgs.curl} -G -X POST -H \"Authorization: Bearer $BORGMATIC_GATUS_TOKEN\" \"${meta.services.gatus.url}/api/v1/endpoints/backups_${hostName}/external\" --data-urlencode \"success=false\" --data-urlencode \"error={error}\""
              ];
            }
          ];
        };
      };
    };
}
