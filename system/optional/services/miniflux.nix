{config, ...}: let
  cfg = config.services.miniflux.config;
in {
  sops.secrets.miniflux = {
    sopsFile = ../../../secrets/pandora/miniflux.env;
    format = "dotenv";
  };

  services = {
    caddy.virtualHosts."read.sndh.dev" = {
      extraConfig = ''
        reverse_proxy http://${cfg.LISTEN_ADDR}
        import cloudflare
      '';
    };

    miniflux = {
      enable = true;
      adminCredentialsFile = config.sops.secrets.miniflux.path;
      config = {
        CREATE_ADMIN = 1;
        LISTEN_ADDR = "localhost:7070";
        BASE_URL = "https://read.sndh.dev";
      };
    };
  };
}
