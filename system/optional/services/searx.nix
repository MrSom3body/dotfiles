{ config, ... }:
let
  cfg = config.services.searx;
in
{
  sops.secrets.searx = {
    sopsFile = ../../../secrets/pandora/searx.env;
    format = "dotenv";
  };

  services = {
    caddy.virtualHosts = {
      "search.sndh.dev" = {
        extraConfig = ''
          reverse_proxy http://${cfg.settings.server.bind_address}:${toString cfg.settings.server.port}
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
          base_url = "https://search.sndh.dev";
          port = 8888;
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
}
