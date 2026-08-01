{ config, ... }:
let
  inherit (config.flake) meta;
  inherit (meta.services.kanidm) domain;
in
{
  flake.modules.nixos.kanidm =
    { config, pkgs, ... }:
    let
      rdomain = config.networking.domain;
      cert = config.security.acme.certs.${domain};
      certDir = cert.directory;
    in
    {
      sops.secrets =
        let
          kanidmSecrets = {
            sopsFile = ../secrets/kanidm.yaml;
            owner = "kanidm";
            group = "kanidm";
            mode = "440";
          };
        in
        {
          acme-cloudflare-token.sopsFile = ../secrets/acme.yaml;

          kanidm-admin-password = kanidmSecrets;
          kanidm-idm-admin-password = kanidmSecrets;
          kanidm-oauth2-wakapi = kanidmSecrets;
          kanidm-oauth2-immich = kanidmSecrets;
        };

      users.groups.kanidm-tls = { };
      users.users.caddy.extraGroups = [ "kanidm-tls" ];

      security.acme.certs.${domain} = {
        credentialFiles."CF_DNS_API_TOKEN_FILE" = config.sops.secrets."acme-cloudflare-token".path;
        group = "kanidm-tls";
      };

      services = {
        caddy.virtualHosts.${domain} = {
          useACMEHost = domain;
          extraConfig = ''
            reverse_proxy https://localhost:${toString meta.services.kanidm.port} {
              transport http {
                tls_trusted_ca_certs ${certDir}/chain.pem
                tls_server_name ${domain}
              }
            }
          '';
        };

        kanidm = {
          package = pkgs.kanidmWithSecretProvisioning_1_10;
          server = {
            enable = true;
            settings = {
              version = "2";
              inherit domain;
              origin = meta.services.kanidm.url;
              bindaddress = "127.0.0.1:${toString meta.services.kanidm.port}";
              tls_chain = "${certDir}/cert.pem";
              tls_key = "${certDir}/key.pem";
            };
          };
          provision = {
            enable = true;

            adminPasswordFile = config.sops.secrets.kanidm-admin-password.path;
            idmAdminPasswordFile = config.sops.secrets.kanidm-idm-admin-password.path;

            persons.karun = {
              displayName = "Karun";
              legalName = "Karun";
              mailAddresses = [ "karun@${rdomain}" ];
              groups = [ "admin.role" ];
            };

            groups = {
              "admin.role" = { };
              "family.role".overwriteMembers = false;

              ### access ###
              "immich.access".members = [
                "admin.role"
                "family.role"
              ];
              "paperless.access".members = [
                "admin.role"
                "family.role"
              ];
              "wakapi.access".members = [
                "admin.role"
                "family.role"
              ];

              ### permissions ###
              "paperless.viewer".members = [
                "admin.role"
                "family.role"
              ];
              "paperless.editor".members = [
                "admin.role"
                "family.role"
              ];
            };

            systems.oauth2 = {
              immich = {
                displayName = "immich";
                originUrl = [
                  "${meta.services.immich.url}/api/oauth/mobile-redirect" # mobile
                  "${meta.services.immich.url}/auth/login" # web login
                  "${meta.services.immich.url}/user-settings" # settings link
                ];
                originLanding = meta.services.immich.url;
                basicSecretFile = config.sops.secrets.kanidm-oauth2-immich.path;
                allowInsecureClientDisablePkce = true;
                preferShortUsername = true;
                scopeMaps."immich.access" = [
                  "openid"
                  "email"
                  "profile"
                ];
              };
              paperless = {
                public = true;
                displayName = "paperless";
                originUrl = [
                  "x-paperless://oidc-callback" # Swift Paperless (iOS App)
                  "${meta.services.paperless.url}/accounts/oidc/kanidm/login/callback/"
                ];
                originLanding = meta.services.paperless.url;
                preferShortUsername = true;
                scopeMaps."paperless.access" = [
                  "openid"
                  "email"
                  "profile"
                  "groups_name"
                ];
              };
              wakapi = {
                displayName = "wakapi";
                originUrl = "${meta.services.wakapi.url}/oidc/kanidm/callback";
                originLanding = meta.services.wakapi.url;
                basicSecretFile = config.sops.secrets.kanidm-oauth2-wakapi.path;
                allowInsecureClientDisablePkce = true;
                preferShortUsername = true;
                scopeMaps."wakapi.access" = [
                  "openid"
                  "email"
                  "profile"
                ];
              };
            };
          };
        };
      };

      systemd.services.kanidm = {
        after = [ "acme-selfsigned-internal.${rdomain}.target" ];
        serviceConfig = {
          RestartSec = "60";
          SupplementaryGroups = [ cert.group ];
          BindReadOnlyPaths = [ certDir ];
        };
      };
    };
}
