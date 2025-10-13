{
  flake.modules.nixos.immich =
    { config, ... }:
    let
      cfg = config.services.immich;
    in
    {
      sops.secrets.immich = {
        sopsFile = ../secrets/immich.env;
        format = "dotenv";
      };

      services = {
        immich = {
          enable = true;
          host = "127.0.0.1";
          port = 2283;
          secretsFile = config.sops.secrets.immich.path;
        };

        caddy.virtualHosts = {
          "immich.${config.networking.domain}" = {
            extraConfig = ''
              reverse_proxy http://${cfg.host}:${toString cfg.port}
              import cloudflare
            '';
          };

          "media.${config.networking.domain}" = {
            extraConfig = ''
              reverse_proxy http://${cfg.host}:${toString cfg.port}
              tls internal
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
