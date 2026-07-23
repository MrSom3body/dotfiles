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
        };
      };
    };
  };
}
