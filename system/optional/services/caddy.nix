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
        hash = "sha256-AcWko5513hO8I0lvbCLqVbM1eWegAhoM0J0qXoWL/vI=";
      };
    };
  };
}
