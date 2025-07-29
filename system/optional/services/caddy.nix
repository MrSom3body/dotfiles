{
  config,
  pkgs,
  ...
}:
{
  sops.secrets.caddy = {
    sopsFile = ../../../secrets/caddy.env;
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
        hash = "sha256-S1JN7brvH2KIu7DaDOH1zij3j8hWLLc0HdnUc+L89uU=";
      };
    };
  };
}
