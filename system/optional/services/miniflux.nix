{config, ...}: let
  cfg = config.services.miniflux.config;
in {
  sops.secrets.miniflux-password.sopsFile = ../../../secrets/pandora/secrets.yaml;

  services = {
    caddy.virtualHosts."read.sndh.dev" = {
      extraConfig = ''
        reverse_proxy http://${cfg.LISTEN_ADDR}
        import cloudflare
      '';
    };

    miniflux = {
      enable = true;
      adminCredentialsFile = config.sops.secrets.miniflux-password.path;
      config = {
        CREATE_ADMIN = 1;
        LISTEN_ADDR = "localhost:7070";
      };
    };
  };
}
