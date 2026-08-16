{ config, ... }:
let
  inherit (config.flake) meta;
  inherit (meta.services.kanidm) domain;
in
{
  flake.modules.nixos.kanidm =
    { config, pkgs, ... }:
    let
      inherit (config.networking) hostName;
      rdomain = config.networking.domain;
      cert = config.security.acme.certs.${domain};
      certDir = cert.directory;

      getIcon =
        name: sha256:
        let
          parts = pkgs.lib.splitString "." name;
          ext = if builtins.length parts > 1 then pkgs.lib.last parts else "svg";
          iconName = builtins.head parts;
        in
        pkgs.fetchurl {
          url = "https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/${ext}/${iconName}.${ext}";
          inherit sha256;
        };
    in
    {
      sops.secrets =
        let
          kanidmSecrets = {
            sopsFile = ../secrets/${hostName}/kanidm.yaml;
            owner = "kanidm";
            group = "kanidm";
            mode = "440";
          };
        in
        {
          acme-cloudflare-token.sopsFile = ../secrets/${hostName}/acme.yaml;

          kanidm-admin-password = kanidmSecrets;
          kanidm-idm-admin-password = kanidmSecrets;

          kanidm-oauth2-auth-proxy = kanidmSecrets;
          oauth2-proxy-cookie.sopsFile = ../secrets/${hostName}/kanidm.yaml;

          kanidm-oauth2-immich = kanidmSecrets;
          kanidm-oauth2-miniflux = kanidmSecrets;
          kanidm-oauth2-karakeep = kanidmSecrets;
          kanidm-oauth2-wakapi = kanidmSecrets;
          kanidm-oauth2-wallos = kanidmSecrets;
        };

      users.groups.kanidm-tls = { };
      users.users.caddy.extraGroups = [ "kanidm-tls" ];

      security.acme.certs.${domain} = {
        credentialFiles."CF_DNS_API_TOKEN_FILE" = config.sops.secrets."acme-cloudflare-token".path;
        group = "kanidm-tls";
      };

      services = {
        cloudflared.tunnels.${config.networking.hostName} = {
          ingress."${meta.services.kanidm.domain}" = {
            service = "https://localhost:${toString meta.services.kanidm.port}";
            originRequest.noTLSVerify = true; # needed as cert is for sso.sndh.dev and not localhost
          };
          ingress."${meta.services.oauth2-proxy.domain}" = {
            service = "https://localhost:443";
            originRequest.originServerName = meta.services.oauth2-proxy.domain;
          };
        };

        caddy.virtualHosts."${meta.services.oauth2-proxy.domain}" = {
          extraConfig = ''
            reverse_proxy http://127.0.0.1:${toString meta.services.oauth2-proxy.port}
          '';
        };

        oauth2-proxy =
          let
            clientID = "oauth2-proxy";
          in
          {
            enable = true;
            provider = "oidc";
            inherit clientID;
            clientSecretFile = config.sops.secrets.kanidm-oauth2-auth-proxy.path;
            cookie.secretFile = config.sops.secrets.oauth2-proxy-cookie.path;
            cookie.domain = ".${rdomain}";
            redirectURL = "${meta.services.oauth2-proxy.url}/oauth2/callback";
            oidcIssuerUrl = "${meta.services.kanidm.url}/oauth2/openid/${clientID}";
            email.domains = [ "*" ];
            httpAddress = "http://127.0.0.1:${toString meta.services.oauth2-proxy.port}";
            scope = "openid email profile groups_name";
            extraConfig = {
              skip-provider-button = "true";
              whitelist-domain = ".${rdomain}";
              pass-user-headers = "true";
              set-xauthrequest = "true";
              code-challenge-method = "S256";
            };
          };

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
          package = pkgs.kanidmWithSecretProvisioning_1_11;
          server = {
            enable = true;
            settings = {
              version = "2";
              inherit domain;
              origin = meta.services.kanidm.url;
              bindaddress = "127.0.0.1:${toString meta.services.kanidm.port}";
              tls_chain = "${certDir}/cert.pem";
              tls_key = "${certDir}/key.pem";
              http_client_address_info.x-forward-for = [
                "127.0.0.1"
                "::1"
              ];
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
              groups = [
                "idm_admins"
                "admin.role"
              ];
            };

            groups = {
              ### builtins ###
              "idm_admins".overwriteMembers = false;

              ### roles ###
              "admin.role" = { };
              "family.role".overwriteMembers = false;

              ### access ###
              "oauth2-proxy.access".members = [
                "admin.role"
                "family.role"
              ];
              "immich.access".members = [
                "admin.role"
                "family.role"
              ];
              "paperless.access".members = [
                "admin.role"
                "family.role"
              ];
              "miniflux.access".members = [
                "admin.role"
                "family.role"
              ];
              "wakapi.access".members = [
                "admin.role"
                "family.role"
              ];
              "wallos.access".members = [
                "admin.role"
                "family.role"
              ];
              "karakeep.access".members = [
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
              oauth2-proxy = {
                displayName = "OAuth2 Proxy";
                originUrl = "${meta.services.oauth2-proxy.url}/oauth2/callback";
                originLanding = meta.services.oauth2-proxy.url;
                basicSecretFile = config.sops.secrets.kanidm-oauth2-auth-proxy.path;
                preferShortUsername = true;
                scopeMaps."oauth2-proxy.access" = [
                  "openid"
                  "email"
                  "profile"
                  "groups_name"
                ];
              };
              immich = {
                displayName = "immich";
                imageFile = getIcon "immich" "sha256-pdSkOJnmP/x+lyRgNPf2PN/cQQqoA8VxPVRSkGAcTYk=";
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
                imageFile = getIcon "paperless" "sha256-udDLXdrUFvUPAfALlvfbXzdO6cnL8a1FIB4sczf9P+k=";
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
              miniflux = {
                displayName = "miniflux";
                imageFile = getIcon "miniflux" "sha256-EyAyRYpTOhRFHYw6EIovyYMF6AT8TschgxvoZ3vQqLU=";
                originUrl = "${meta.services.miniflux.url}/oauth2/oidc/callback";
                originLanding = meta.services.miniflux.url;
                basicSecretFile = config.sops.secrets.kanidm-oauth2-miniflux.path;
                allowInsecureClientDisablePkce = true;
                preferShortUsername = true;
                scopeMaps."miniflux.access" = [
                  "openid"
                  "email"
                  "profile"
                ];
              };
              karakeep = {
                displayName = "Karakeep";
                imageFile = getIcon "karakeep" "sha256-KeEmIa4ymHglxLhMdK+2cnZsXVMnXBvGr9NB7svg+rQ=";
                originUrl = "${meta.services.karakeep.url}/api/auth/callback/custom";
                originLanding = meta.services.karakeep.url;
                basicSecretFile = config.sops.secrets.kanidm-oauth2-karakeep.path;
                allowInsecureClientDisablePkce = true;
                preferShortUsername = true;
                scopeMaps."karakeep.access" = [
                  "openid"
                  "email"
                  "profile"
                ];
              };
              wakapi = {
                displayName = "wakapi";
                imageFile = getIcon "wakapi" "sha256-QMAB0lrV/PaN3jERZPeB3Dequ8XWwq+qsMooEp/WlqY=";
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
              wallos = {
                displayName = "wallos";
                imageFile = getIcon "wallos.png" "sha256-/OI3NriQUigJTbAd4W5cLT4KS05Vb58ogYreGxUC7Kw=";
                originUrl = "${meta.services.wallos.url}/index.php";
                originLanding = meta.services.wallos.url;
                basicSecretFile = config.sops.secrets.kanidm-oauth2-wallos.path;
                allowInsecureClientDisablePkce = true;
                preferShortUsername = true;
                scopeMaps."wallos.access" = [
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

      systemd.services.oauth2-proxy = {
        after = [ "kanidm.service" ];
        wants = [ "kanidm.service" ];
        serviceConfig = {
          Restart = "always";
          RestartSec = "10s";
        };
      };
    };
}
