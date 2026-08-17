{ config, ... }:
let
  inherit (config.flake) meta;
in
{
  flake.modules.nixos.transmission = { config, pkgs, ... }: {
    sops = {
      secrets.transmission-password.sopsFile = ../secrets/${config.networking.hostName}/transmission.yaml;
      secrets.transmission-basic-auth.sopsFile = ../secrets/${config.networking.hostName}/transmission.yaml;

      templates."transmission.json" = {
        owner = "transmission";
        content =
          #json
          ''
            {
              "rpc-password": "${config.sops.placeholder.transmission-password}"
            }
          '';
      };

      templates."transmission-caddy.env" = {
        owner = "caddy";
        content = ''
          TRANSMISSION_BASIC_AUTH="${config.sops.placeholder.transmission-basic-auth}"
        '';
      };
    };

    systemd.services.caddy.serviceConfig.EnvironmentFile = [
      "-${config.sops.templates."transmission-caddy.env".path}"
    ];

    services = {
      caddy.virtualHosts."${meta.services.transmission.domain}" = {
        extraConfig = ''
          @has_auth_header header Authorization *

          handle @has_auth_header {
            reverse_proxy http://localhost:${toString meta.services.transmission.port}
          }

          handle {
            import oauth2_routes
            import oauth2 admin.role

            reverse_proxy http://localhost:${toString meta.services.transmission.port} {
              header_up Authorization "{$TRANSMISSION_BASIC_AUTH}"
            }
          }
        '';
      };

      transmission = {
        enable = true;
        package = pkgs.transmission_4;
        credentialsFile = config.sops.templates."transmission.json".path;
        settings = {
          rpc-username = "karun";
          rpc-port = meta.services.transmission.port;
          rpc-authentication-required = true;

          incomplete_dir_enabled = false;

          ratio-limit = 1;
          ratio-limit-enabled = true;

          alt_speed_time_enabled = true;
          alt_speed_up = 3000; # kB/s
          alt_speed_down = 3000; # kB/s
          alt_speed_time_begin = 9 * 60; # min
          alt_speed_time_end = 23 * 60; # min
        };
      };
    };
  };
}
