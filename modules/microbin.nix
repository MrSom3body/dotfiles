{ config, ... }:
let
  inherit (config.flake) meta;
in
{
  flake.modules.nixos.microbin = { config, ... }: {
    sops.secrets.microbin-env.sopsFile = ../secrets/${config.networking.hostName}/microbin.yaml;

    services = {
      cloudflared.tunnels.${config.networking.hostName}.ingress."${meta.services.microbin.domain}" = {
        service = "https://localhost:443";
        originRequest.originServerName = meta.services.microbin.domain;
      };

      caddy.virtualHosts."${meta.services.microbin.domain}".extraConfig = ''
        handle /auth_admin* {
          forward_auth ${meta.services.oauth2-proxy.url} {
            uri /oauth2/auth?allowed_groups=admin.role
            copy_headers X-Auth-Request-User X-Auth-Request-Email

            @error status 401
            handle_response @error {
              redir ${meta.services.oauth2-proxy.url}/oauth2/start?rd={scheme}://{host}{uri}
            }
          }
          reverse_proxy http://127.0.0.1:${toString meta.services.microbin.port}
        }

        handle {
          reverse_proxy http://127.0.0.1:${toString meta.services.microbin.port}
        }
      '';

      fail2ban.jails.microbin = ''
        enabled = true
        filter = microbin
        backend = systemd
        journalmatch = _SYSTEMD_UNIT=microbin.service
      '';

      microbin = {
        enable = true;
        passwordFile = config.sops.secrets.microbin-env.path;
        settings =
          let
            MICROBIN_NO_LISTING = true; # removes the /list endpoint
          in
          {
            MICROBIN_BIND = "127.0.0.1";
            MICROBIN_PORT = meta.services.microbin.port;
            MICROBIN_PUBLIC_PATH = meta.services.microbin.url;

            MICROBIN_TITLE = "Karun's MicroBin";
            MICROBIN_HIDE_HEADER = false;
            MICROBIN_HIDE_FOOTER = true;

            MICROBIN_DEFAULT_EXPIRY = "1hour";
            MICROBIN_MAX_EXPIRY = "24hour";
            MICROBIN_ENABLE_BURN_AFTER = true;
            MICROBIN_DEFAULT_BURN_AFTER = 1;
            MICROBIN_GC_DAYS = 7;

            inherit MICROBIN_NO_LISTING;
            MICROBIN_HIGHLIGHTSYNTAX = true;

            MICROBIN_QR = true;

            MICROBIN_PRIVATE = !MICROBIN_NO_LISTING; # unlisted mode (can be disabled when MICROBIN_NO_LISTING is enabled)
            MICROBIN_ENABLE_READONLY = true; # protected mode
            MICROBIN_ENCRYPTION_SERVER_SIDE = true; # secret mode
            MICROBIN_ENCRYPTION_CLIENT_SIDE = true; # private mode
            MICROBIN_DEFAULT_PRIVACY = "unlisted";
          };
      };
    };

    environment.etc."fail2ban/filter.d/microbin.conf".text = ''
      [Definition]
      failregex = - <HOST> "GET /auth_admin/incorrect HTTP/\d\.\d" 200
      ignoreregex =
    '';
  };
}
