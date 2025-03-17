{pkgs, ...}: {
  sops.secrets.caddy.sopsFile = ../../../secrets/pandora/secrets.yaml;

  services.caddy = {
    enable = true;
    package = pkgs.caddy.withPlugins {
      plugins = ["github.com/caddy-dns/cloudflare@v0.0.0-20250228175314-1fb64108d4de"];
      hash = "sha256-3nvVGW+ZHLxQxc1VCc/oTzCLZPBKgw4mhn+O3IoyiSs=";
    };
    environmentFile = "/run/secrets/caddy";
    extraConfig = ''
      (cloudflare) {
        tls {
          dns cloudflare {$CF_TOKEN}
        }
      }
    '';

    virtualHosts = {
      "loxone.sndh.dev" = {
        extraConfig = ''
          reverse_proxy http://10.0.0.10
          import cloudflare
        '';
      };
    };
  };
}
