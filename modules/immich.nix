{ config, ... }:
let
  inherit (config.flake) meta;
in
{
  flake.modules.nixos.immich =
    { config, ... }:
    {
      sops.secrets.immich = {
        sopsFile = ../secrets/immich.env;
        format = "dotenv";
      };

      services = {
        immich = {
          enable = true;
          host = "127.0.0.1";
          inherit (meta.services.immich) port;
          secretsFile = config.sops.secrets.immich.path;
        };

        caddy.virtualHosts = {
          "${meta.services.immich.domain}" = {
            extraConfig = ''
              reverse_proxy http://localhost:${toString meta.services.immich.port}
            '';
          };
        };
      };

      users.users.immich.extraGroups = [
        "video"
        "render"
      ];
    };
}
