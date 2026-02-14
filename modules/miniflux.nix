{ config, ... }:
let
  inherit (config.flake) meta;
in
{
  flake.modules.nixos.miniflux =
    { config, ... }:
    {
      sops.secrets.miniflux = {
        sopsFile = ../secrets/miniflux.env;
        format = "dotenv";
      };

      services = {
        caddy.virtualHosts."${meta.services.miniflux.domain}" = {
          extraConfig = ''
            reverse_proxy http://localhost:${toString meta.services.miniflux.port}
          '';
        };

        miniflux = {
          enable = true;
          adminCredentialsFile = config.sops.secrets.miniflux.path;
          config = {
            CREATE_ADMIN = 1;
            LISTEN_ADDR = "localhost:${toString meta.services.miniflux.port}";
            BASE_URL = "https://${meta.services.miniflux.domain}";
          };
        };
      };
    };
}
