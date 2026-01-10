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
          extraConfig = ''
            (cloudflare) {
              tls {
                dns cloudflare {$CF_TOKEN}
              }
            }
          '';
          package = pkgs.caddy.withPlugins {
            plugins = [ "github.com/caddy-dns/cloudflare@v0.2.1" ];
            hash = "sha256-Zls+5kWd/JSQsmZC4SRQ/WS+pUcRolNaaI7UQoPzJA0=";
          };
        };
      };
    };
}
