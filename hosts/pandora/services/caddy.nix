{config, ...}: {
  imports = [
    ../../common/optional/services/caddy.nix
  ];

  sops.secrets.caddy.sopsFile = ../../../secrets/pandora/secrets.yaml;

  services.caddy = {
    environmentFile = config.sops.secrets.caddy.path;
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
