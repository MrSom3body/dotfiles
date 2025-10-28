{ lib, ... }:
{
  flake.modules.nixos.atuin-server =
    { config, ... }:
    let
      cfg = config.services.atuin;
    in
    {
      my.services.glance.services = lib.singleton {
        title = "atuin";
        url = "https://atuin.${config.networking.domain}";
        icon = "di:atuin";
      };

      services = {
        atuin = {
          enable = true;
          port = 8987;
          openRegistration = true;
        };

        caddy.virtualHosts = {
          "atuin.${config.networking.domain}" = {
            extraConfig = ''
              reverse_proxy http://${cfg.host}:${toString cfg.port}
              import cloudflare
            '';
          };
        };
      };
    };
}
