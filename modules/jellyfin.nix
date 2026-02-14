{ config, ... }:
let
  inherit (config.flake) meta;
in
{
  flake.modules.nixos.jellyfin = {
    services = {
      caddy.virtualHosts."${meta.services.jellyfin.domain}" = {
        extraConfig = ''
          reverse_proxy http://localhost:${toString meta.services.jellyfin.port}
        '';
      };

      jellyfin = {
        enable = true;
      };
    };

    users.users.jellyfin.extraGroups = [
      "video"
      "render"
    ];

    networking.firewall = {
      allowedTCPPorts = [
        8096 # http traffic
      ];

      allowedUDPPorts = [
        1900 # service discovery
        7359 # client discovery
      ];
    };
  };
}
