{ config, ... }:
let
  inherit (config.flake) meta;
in
{
  flake.modules.nixos.transmission =
    { pkgs, ... }:
    {
      services = {
        caddy.virtualHosts."${meta.services.transmission.domain}" = {
          extraConfig = ''
            reverse_proxy http://localhost:${toString meta.services.transmission.port}
          '';
        };

        transmission = {
          enable = true;
          package = pkgs.transmission_4;

          settings = {
            rpc-port = meta.services.transmission.port;

            speed-limit-up = 2000;
            speed-limit-up-enabled = true;

            ratio-limit = 1;
            ratio-limit-enabled = true;
          };
        };
      };
    };
}
