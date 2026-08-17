{ config, ... }:
let
  inherit (config.flake) meta;
in
{
  flake.modules.nixos.miniflux =
    { config, ... }:
    let
      inherit (config.networking) hostName;
    in
    {
      sops.secrets.miniflux-env.sopsFile = ../secrets/${hostName}/miniflux.yaml;

      services = {
        caddy.virtualHosts."${meta.services.miniflux.domain}" = {
          extraConfig = ''
            reverse_proxy http://localhost:${toString meta.services.miniflux.port}
          '';
        };

        miniflux = {
          enable = true;
          adminCredentialsFile = config.sops.secrets.miniflux-env.path;
          config = {
            CREATE_ADMIN = 0;
            LISTEN_ADDR = "localhost:${toString meta.services.miniflux.port}";
            BASE_URL = "https://${meta.services.miniflux.domain}";

            /*
              This disabled password auth completely. To give yourself admin use
              the following command:
              sudo -u postgres psql -d miniflux -c "UPDATE users SET is_admin=true WHERE username='karun';"
            */
            DISABLE_LOCAL_AUTH = "true";
            OAUTH2_PROVIDER = "oidc";
            OAUTH2_OIDC_PROVIDER_NAME = "som3sso";
            OAUTH2_CLIENT_ID = "miniflux";
            OAUTH2_OIDC_DISCOVERY_ENDPOINT = "${meta.services.kanidm.url}/oauth2/openid/miniflux";
            OAUTH2_REDIRECT_URL = "${meta.services.miniflux.url}/oauth2/oidc/callback";
            OAUTH2_USER_CREATION = 1;
          };
        };
      };
    };
}
