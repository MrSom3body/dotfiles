{ lib, ... }:
{
  flake.modules.nixos.jellyfin =
    { config, ... }:
    {
      my.services.glance.services = lib.singleton {
        title = "jellyfin";
        url = "https://jellyfin.sndh.dev";
        icon = "di:jellyfin";
      };

      services = {
        caddy.virtualHosts."jellyfin.${config.networking.domain}" = {
          extraConfig = ''
            reverse_proxy http://localhost:8096
            import cloudflare
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
