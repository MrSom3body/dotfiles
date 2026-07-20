{ config, ... }:
let
  inherit (config.flake) meta;
in
{
  flake.modules.nixos.ddns-updater = { config, ... }: {
    services = {
      caddy.virtualHosts."${
        if builtins.isString meta.services.ddns-updater.domain then
          meta.services.ddns-updater.domain
        else
          meta.services.ddns-updater.domain config.networking.hostName
      }" =
        {
          extraConfig = ''
            reverse_proxy http://localhost:${toString meta.services.ddns-updater.port}
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
