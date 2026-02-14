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
              "github.com/caddy-dns/cloudflare@v0.2.1"
              "github.com/WeidiDeng/caddy-cloudflare-ip@v0.0.0-20231130002422-f53b62aa13cb"
            ];
            hash = "sha256-xBb4nq1uo2pO1ZN1P8dUR2HkB3v1E6+xk75CgTyUZUw=";
          };
        };
      };
    };
}
