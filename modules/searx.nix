{ config, ... }:
let
  inherit (config.flake) meta;
in
{
  flake.modules.nixos.searx =
    { config, ... }:
    let
      inherit (config.networking) hostName;
      cfg = meta.services.searx;
    in
    {
      sops.secrets.searx = {
        sopsFile = ../secrets/${hostName}/searx.env;
        format = "dotenv";
      };

      systemd.tmpfiles.rules = [ "d /var/cache/searx-favicons 0750 searx searx - -" ];

      services = {
        cloudflared.tunnels.${config.networking.hostName}.ingress."${meta.services.searx.domain}" = {
          service = "https://localhost:443";
          originRequest.originServerName = cfg.domain;
        };

        caddy.virtualHosts."${cfg.domain}".extraConfig = ''
          reverse_proxy http://localhost:${toString cfg.port}
        '';

        searx = {
          enable = true;
          redisCreateLocally = true;
          configureUwsgi = true;
          environmentFile = config.sops.secrets.searx.path;

          uwsgiConfig = {
            disable-logging = true;
            http = "localhost:${toString cfg.port}";
          };

          settings = {
            use_default_settings = true;

            server = {
              base_url = "https://${cfg.domain}";
              inherit (cfg) port;
              bind_address = "127.0.0.1";
              secret_key = "@SEARX_SECRET_KEY@";
              method = "GET";
              public_instance = true;
              image_proxy = true;
              limiter = true;
            };

            general = {
              instance_name = "Karun's SearXNG";
              donation_url = "https://ko-fi.com/mrsom3body";
            };

            ui = {
              hotkeys = "vim";
            };

            hostnames = {
              remove = [ "(.*\\.)?nixos.wiki$" ];
              replace = {
                "(.*\\.)?youtube\\.com$" = "inv.nadeko.net";
                "(.*\\.)?youtu\\.be$" = "inv.nadeko.net";
              };
            };

            search = {
              autocomplete = "duckduckgo";
              favicon_resolver = "duckduckgo";
              formats = [
                "html"
                "json"
              ];
            };

            engines = [
              {
                name = "annas archive";
                disabled = false;
              }
              {
                name = "nixos wiki";
                disabled = false;
              }
              {
                name = "geizhals";
                disabled = false;
              }
              {
                name = "duden";
                disabled = false;
              }
            ];
          };

          faviconsSettings = {
            favicons = {
              cfg_schema = 1;
              cache = {
                db_url = "/var/cache/searx-favicons/faviconcache.db";
                LIMIT_TOTAL_BYTES = 2147483648;
                HOLD_TIME = 5184000;
                BLOB_MAX_BYTES = 40960;
                MAINTENANCE_MODE = "auto";
                MAINTENANCE_PERIOD = 600;
              };

              proxy = {
                max_age = 5184000;
              };
            };
          };
        };
      };
    };
}
