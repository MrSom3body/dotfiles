{ lib, ... }:
{
  flake.modules.nixos.beszel =
    { config, ... }:
    let
      cfg = config.services.beszel.hub;
    in
    {
      my.services.glance.services = lib.singleton {
        title = "beszel";
        url = "https://beszel.sndh.dev";
        icon = "di:beszel";
      };

      services = {
        beszel.hub.enable = true;

        caddy.virtualHosts = {
          "beszel.${config.networking.domain}" = {
            extraConfig = ''
              reverse_proxy http://${cfg.host}:${toString cfg.port}
              import cloudflare
            '';
          };
        };
      };
    };
}
