{ config, ... }:
let
  inherit (config.flake) meta;
in
{
  flake.modules.nixos.searx =
    { config, ... }:
    {
      sops.secrets.searx = {
        sopsFile = ../secrets/searx.env;
        format = "dotenv";
      };

      services = {
        caddy.virtualHosts = {
          "${meta.services.searx.domain}" = {
            extraConfig = ''
              reverse_proxy http://localhost:${toString meta.services.searx.port}
              import cloudflare
            '';
          };
        };

        searx = {
          enable = true;
          environmentFile = config.sops.secrets.searx.path;
          settings = {
            use_default_settings = true;

            server = {
              base_url = "https://${meta.services.searx.domain}";
              inherit (meta.services.searx) port;
              bind_address = "127.0.0.1";
              secret_key = "@SEARX_SECRET_KEY@";
            };

            general = {
              instance_name = "Karun's SearXNG";
            };

            hostnames = {
              remove = [ "(.*\.)?nixos.wiki$" ];
            };

            search = {
              autocomplete = "duckduckgo";
              favicon_resolver = "duckduckgo";
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

              {
                name = "google";
                disabled = true;
              }
              {
                name = "startpage";
                disabled = true;
              }
            ];
          };

          faviconsSettings = {
            favicons = {
              cfg_schema = 1;
              cache = {
                db_url = "/run/searx/faviconcache.db";
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
