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
      sops.secrets = {
        acme-cloudflare-token.sopsFile = ../secrets/acme.yaml;

        kanidm-admin-password = {
          sopsFile = ../secrets/kanidm.yaml;
          owner = "kanidm";
          group = "kanidm";
          mode = "440";
        };
        kanidm-idm-admin-password = {
          sopsFile = ../secrets/kanidm.yaml;
          owner = "kanidm";
          group = "kanidm";
          mode = "440";
        };
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
              groups = [ ];
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
