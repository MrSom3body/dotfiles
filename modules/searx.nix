{ config, ... }:
let
  inherit (config.flake) meta;
in
{
  flake.modules.nixos.searx =
    { config, ... }:
    let
      inherit (config.networking) hostName;
    in
    {
      sops.secrets.searx = {
        sopsFile = ../secrets/${hostName}/searx.env;
        format = "dotenv";
      };

      services = {
        cloudflared.tunnels.${config.networking.hostName}.ingress."${meta.services.searx.domain}" = {
          service = "https://localhost:443";
          originRequest.originServerName = meta.services.searx.domain;
        };

        caddy.virtualHosts."${meta.services.searx.domain}".extraConfig = ''
          reverse_proxy http://localhost:${toString meta.services.searx.port}
        '';

        searx = {
          enable = true;
          redisCreateLocally = true;
          environmentFile = config.sops.secrets.searx.path;

          settings = {
            use_default_settings = true;

            server = {
              base_url = "https://${meta.services.searx.domain}";
              inherit (meta.services.searx) port;
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
                db_url = "/var/cache/searx/faviconcache.db";
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
