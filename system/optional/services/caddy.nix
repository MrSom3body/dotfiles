{
  config,
  pkgs,
  ...
}: {
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
        plugins = ["github.com/caddy-dns/cloudflare@v0.2.1"];
        hash = "sha256-Gsuo+ripJSgKSYOM9/yl6Kt/6BFCA6BuTDvPdteinAI=";
      };
    };
  };
}
