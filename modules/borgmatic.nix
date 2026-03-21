{ lib, ... }:
{
  flake.modules.nixos.borgmatic =
    { config, ... }:
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
              path = "ssh://u564683@u564683.your-storagebox.de:23/./backups/${config.networking.hostName}";
              label = "som3box";
            }
          ];

          source_directories = [
            "/home/karun"
            "/etc"
          ];

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
            "*.temp"
            "*.tmp"
            "*~"
            "/home/karun/.local/share/Steam"
            "/home/karun/.steam"

            # large & temporary files/directories
            "/home/karun/.local/share/Trash"
            "/home/karun/Documents/Codes/nixpkgs"
            "/home/karun/Downloads/ISOs"
            "/home/karun/Games"

            # virtualization & containers
            "/home/karun/.local/share/containers"
            "/home/karun/.local/share/distrobox"
            "/home/karun/.local/share/libvirt"
            "/home/karun/vmware"
            "/var/lib/libvirt/images"

            # AI/ML models (downloaded on demand, not user data)
            "/var/lib/ollama"

            # IDE caches & build tools
            "/home/karun/.gradle"
            "/home/karun/.m2"
            "/home/karun/.local/share/JetBrains"

            # service data that is redundant or regeneratable
            "/var/lib/jellyfin/transcodes"
            "/var/lib/meilisearch"
            "/var/lib/postgresql"
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
        };
      };
    };
}
