{ config, ... }:
let
  inherit (config.flake) meta;
in
{
  flake.modules.nixos.ddns-updater = {
    services = {
      caddy.virtualHosts."${meta.services.ddns-updater.domain}" = {
        extraConfig = ''
          reverse_proxy http://localhost:${toString meta.services.ddns-updater.port}
          import cloudflare
        '';
      };

      ddns-updater = {
        enable = true;
        environment = {
          LISTENING_ADDRESS = "127.0.0.1:${toString meta.services.ddns-updater.port}";
        };
      };
    };
  };
}
