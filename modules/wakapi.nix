{ config, ... }:
let
  inherit (config.flake) meta;
in
{
  flake.modules.nixos.wakapi =
    { config, ... }:
    let
      inherit (config.networking) hostName;
    in
    {
      sops.secrets.wakapi = {
        sopsFile = ../secrets/${hostName}/wakapi.env;
        format = "dotenv";
        owner = "wakapi";
        group = "wakapi";
      };

      services = {
        cloudflared.tunnels.${config.networking.hostName}.ingress."${meta.services.wakapi.domain}" =
          "http://localhost:${toString meta.services.wakapi.port}";

        caddy.virtualHosts.${meta.services.wakapi.domain}.extraConfig = ''
          reverse_proxy http://127.0.0.1:${toString meta.services.wakapi.port}
          tls internal
        '';

        wakapi = {
          enable = true;
          environmentFiles = [ config.sops.secrets.wakapi.path ];
          database.createLocally = true;
          settings = {
            server = {
              inherit (meta.services.wakapi) port;
              public_url = meta.services.wakapi.url;
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
              oidc_allow_signup = true;
              disable_frontpage = true;

              oidc = [
                {
                  name = "kanidm";
                  display_name = "som3sso";
                  client_id = "wakapi";
                  endpoint = "https://${meta.services.kanidm.domain}/oauth2/openid/wakapi";
                }
              ];
            };

            mail =
              let
                mail = "noreply@${config.networking.domain}";
              in
              {
                enabled = true;
                provider = "smtp";
                sender = "Wakapi <${mail}>";
                smtp = {
                  host = "smtp.protonmail.ch";
                  port = 587;
                  username = mail;
                  tls = false;
                };
              };
          };
        };
      };
    };
}
