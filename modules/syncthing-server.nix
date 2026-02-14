{ config, ... }:
let
  inherit (config.flake) meta;
in
{
  flake.modules.nixos.syncthing-server =
    { config, ... }:
    {
      services = {
        syncthing.enable = true;
        caddy.virtualHosts = {
          "syncthing.${config.networking.hostName}.${config.networking.domain}" = {
            extraConfig = ''
              reverse_proxy http://127.0.0.1:${toString meta.services.syncthing.port} {
                header_up Host {upstream_hostport}
              }
            '';
          };
        };
      };

      networking.firewall =
        let
          ports = [
            22000
            21027
          ];
        in
        {
          allowedTCPPorts = ports;
          allowedUDPPorts = ports;
        };
    };
}
