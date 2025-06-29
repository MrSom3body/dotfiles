{config, ...}: let
  cfg = config.services.searx;
in {
  sops.secrets.searx-key.sopsFile = ../../../secrets/pandora/secrets.yaml;

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
      environmentFile = config.sops.secrets.searx-key.path;
      settings = {
        use_default_settings = true;

        general = {
          instance_name = "Karun's SearXNG";
        };

        server = {
          base_url = "https://search.sndh.dev";
          port = 8888;
          bind_address = "127.0.0.1";
          secret_key = "@SEARX_SECRET_KEY@";
        };

        search.autocomplete = "duckduckgo";
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
        ];
      };
    };
  };
}
