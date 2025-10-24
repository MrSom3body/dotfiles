{ lib, ... }:
{
  flake.modules.nixos.miniflux =
    { config, ... }:
    let
      cfg = config.services.miniflux.config;
    in
    {
      sops.secrets.miniflux = {
        sopsFile = ../secrets/miniflux.env;
        format = "dotenv";
      };

      my.services.glance.services = lib.singleton {
        title = "miniflux";
        url = "https://read.sndh.dev";
        icon = "di:miniflux";
      };

      services = {
        caddy.virtualHosts."read.${config.networking.domain}" = {
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
    };
}
