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

          exclude_patterns = lib.map (dir: "sh:" + dir) [
            "**/.cache"
            "**/.direnv"
            "**/.venv"
            "**/node_modules"
            "**/result"
            "**/result-*"
            "**/__pycache__"

            "/home/*/.local/share/Steam"
            "/home/*/.local/share/Trash"
            "/home/*/.local/share/containers"
            "/home/*/Documents/Codes/nixpkgs"
            "/home/*/Games"
            "/home/*/dotfiles"

            "**/*.qcow2"
            "**/*.vmdk"
            "**/*.vmx"
            "/var/lib/libvirt/images"
          ];

          exclude_if_present = [ ".nobackup" ];

          encryption_passcommand = "cat ${config.sops.secrets.borgmatic-passphrase.path}";
          ssh_command = "ssh -i /etc/ssh/borgmatic_ed25519 -o StrictHostKeyChecking=accept-new";

          compression = "auto,zstd";
          keep_daily = 7;
          keep_weekly = 4;
          keep_monthly = 6;

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
