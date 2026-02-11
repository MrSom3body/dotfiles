{ config, ... }:
let
  inherit (config.flake) meta;
in
{
  flake = {
    modules.nixos.wakapi =
      { config, ... }:
      {
        sops.secrets.wakapi = {
          sopsFile = ../secrets/wakapi.env;
          format = "dotenv";
        };

        services = {
          wakapi = {
            enable = true;
            environmentFiles = [ config.sops.secrets.wakapi.path ];
            database.createLocally = true;
            settings = {
              server = {
                inherit (meta.services.wakapi) port;
                public_url = "https://${meta.services.wakapi.domain}";
              };

              db = {
                dialect = "postgres";
                host = "/run/postgresql";
                port = 5432; # this needs to be set otherwise the service will fail
                name = "wakapi";
                user = "wakapi";
              };

              security = {
                insecure_cookies = false;
                allow_signup = false;
                disable_frontpage = true;
              };

              mail.enabled = false;
            };
          };

          caddy.virtualHosts = {
            ${meta.services.wakapi.domain} = {
              extraConfig = ''
                reverse_proxy http://localhost:${toString meta.services.wakapi.port}
                import cloudflare
              '';
            };
          };
        };
      };
  };
}
