{ lib, ... }:
{
  flake.modules.nixos.borgmatic =
    { config, pkgs, ... }:
    let
      mkNtfyHook =
        {
          name,
          title,
          tags,
          priority,
        }:
        pkgs.writeShellApplication {
          inherit name;
          runtimeInputs = [ pkgs.curl ];
          text = ''
            NTFY_PASSWORD="$(cat ${config.sops.secrets.borgmatic-ntfy-password.path})"
            curl -s \
              -u "borgmatic:$NTFY_PASSWORD" \
              -H "Title: ${title}" \
              -H "Tags: ${tags}" \
              -H "Priority: ${priority}" \
              -d "$*" \
              https://ntfy.sndh.dev/borgmatic
          '';
        };

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
      };

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
              path = "ssh://u564683-sub1@u564683-sub1.your-storagebox.de:23/./${config.networking.hostName}";
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
            "/home/karun/Documents/Codes/nixpkgs"
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
            "/var/lib/jellyfin/transcodes"
            "/var/lib/meilisearch"
            "/var/lib/postgresql"
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

          commands = [
            {
              before = "action";
              when = [ "create" ];
              run = [
                "${
                  lib.getExe (mkNtfyHook {
                    name = "borgmatic-ntfy-start";
                    title = "Backup Started";
                    tags = "floppy_disk";
                    priority = "default";
                  })
                } Starting backup on ${config.networking.hostName}"
              ];
            }
            {
              after = "action";
              when = [ "create" ];
              run = [
                "${
                  lib.getExe (mkNtfyHook {
                    name = "borgmatic-ntfy-finish";
                    title = "Backup Completed";
                    tags = "white_check_mark";
                    priority = "default";
                  })
                } Backup completed successfully on ${config.networking.hostName}"
              ];
            }
            {
              after = "error";
              run = [
                "${
                  lib.getExe (mkNtfyHook {
                    name = "borgmatic-ntfy-error";
                    title = "Backup Failed";
                    tags = "rotating_light";
                    priority = "high";
                  })
                } Backup failed on ${config.networking.hostName}: {error}"
              ];
            }
          ];
        };
      };
    };
}
