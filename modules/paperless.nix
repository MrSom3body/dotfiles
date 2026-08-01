{ config, ... }:
let
  inherit (config.flake) meta;
in
{
  flake.modules.nixos.paperless = { config, ... }: {
    sops.secrets.paperless-admin-pass.sopsFile = ../secrets/paperless.yaml;

    services = {
      caddy.virtualHosts."${meta.services.paperless.domain}" = {
        extraConfig = ''
          reverse_proxy http://localhost:${toString meta.services.paperless.port}
        '';
      };

      paperless = {
        enable = true;
        port = meta.services.paperless.port;
        domain = meta.services.paperless.domain;
        passwordFile = config.sops.secrets.paperless-admin-pass.path;
        database.createLocally = true;
        settings = {
          PAPERLESS_ADMIN_USER = "karun";
          PAPERLESS_OCR_LANGUAGE = "deu+eng";

          PAPERLESS_APPS = "allauth.socialaccount.providers.openid_connect";
          PAPERLESS_SOCIAL_ACCOUNT_SYNC_GROUPS = true;
          PAPERLESS_SOCIALACCOUNT_PROVIDERS = {
            openid_connect = {
              OAUTH_PKCE_ENABLED = true;
              APPS = [
                {
                  provider_id = "kanidm";
                  name = "som3sso";
                  client_id = "paperless";
                  secret = "";
                  settings = {
                    server_url = "${meta.services.kanidm.url}/oauth2/openid/paperless/.well-known/openid-configuration";
                    fetch_userinfo = true;
                  };
                }
              ];
              SCOPE = [
                "openid"
                "profile"
                "email"
                "groups"
              ];
            };
          };
        };
      };
    };
  };
}
