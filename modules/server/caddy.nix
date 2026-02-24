{
  flake.modules.nixos.server =
    { config, pkgs, ... }:
    {
      sops.secrets.caddy = {
        sopsFile = ../../secrets/caddy.env;
        format = "dotenv";
      };

      services = {
        caddy = {
          enable = true;
          environmentFile = config.sops.secrets.caddy.path;
          globalConfig = ''
            acme_dns cloudflare {$CF_TOKEN}
            servers {
              trusted_proxies cloudflare {
                interval 1h
                timeout 15s
              }
              trusted_proxies_strict
            }
          '';
          package = pkgs.caddy.withPlugins {
            plugins = [
              "github.com/caddy-dns/cloudflare@v0.2.3"
              "github.com/WeidiDeng/caddy-cloudflare-ip@v0.0.0-20231130002422-f53b62aa13cb"
            ];
            hash = "sha256-jbzlaDLv/ZGXQryhBsdZb/P44UCZ3dmHF1mAUp1sKDw=";
          };
        };
      };
    };
}
