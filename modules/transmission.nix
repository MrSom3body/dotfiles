{ lib, ... }:
{
  flake.modules.nixos.transmission =
    { pkgs, config, ... }:
    {
      my.services.glance.services = lib.singleton {
        title = "transmission";
        url = "https://transmission.sndh.dev";
        icon = "di:transmission";
        alt-status-codes = [ 401 ];
      };

      services = {
        caddy.virtualHosts."transmission.sndh.dev" = {
          extraConfig = ''
            reverse_proxy http://localhost:${builtins.toString config.services.transmission.settings.rpc-port}
            import cloudflare
          '';
        };

        transmission = {
          enable = true;
          package = pkgs.transmission_4;
          settings = {
            speed-limit-up = 2000;
            speed-limit-up-enabled = true;

            ratio-limit = 1;
            ratio-limit-enabled = true;
          };
        };
      };
    };
}
