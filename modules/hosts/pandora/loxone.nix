{ lib, ... }:
{
  flake.modules.nixos."hosts/pandora" =
    { config, ... }:
    {
      my.services.glance.services = lib.singleton {
        title = "loxone";
        url = "https://loxone.sndh.dev";
        icon = "di:loxone";
      };

      services.caddy = {
        virtualHosts = {
          "loxone.${config.networking.domain}" = {
            extraConfig = ''
              reverse_proxy http://10.0.0.10
              import cloudflare
            '';
          };
        };
      };
    };
}
