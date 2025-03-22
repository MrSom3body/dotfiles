{config, ...}: let
  cfg = config.services.immich;
in {
  imports = [
    ../../../system/services/immich.nix
  ];

  sops.secrets.immich-db-password.sopsFile = ../../../secrets/pandora/secrets.yaml;

  services = {
    immich.secretsFile = config.sops.secrets.immich-db-password.path;

    caddy.virtualHosts = {
      "immich.sndh.dev" = {
        extraConfig = ''
          reverse_proxy http://${cfg.host}:${toString cfg.port}
          import cloudflare
        '';
      };

      "media.sndh.dev" = {
        extraConfig = ''
          reverse_proxy http://${cfg.host}:${toString cfg.port}
          tls internal
        '';
      };
    };
  };
}
