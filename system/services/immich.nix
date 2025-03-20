{config, ...}: let
  cfg = config.services.immich;
in {
  sops.secrets.immich-db-password.sopsFile = ../../secrets/pandora/secrets.yaml;

  services = {
    caddy.virtualHosts."immich.sndh.dev" = {
      extraConfig = ''
        reverse_proxy http://${cfg.host}:${toString cfg.port}
        import cloudflare
      '';
    };

    immich = {
      enable = true;
      host = "127.0.0.1";
      port = 2283;
      secretsFile = config.sops.secrets.immich-db-password.path;
    };
  };
}
