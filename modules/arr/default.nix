{ config, ... }:
let
  inherit (config.flake) meta;
  inherit (config.flake) modules;
in
{
  flake.modules.nixos.arr = {
    imports = with modules.nixos; [
      jellyfin
      transmission
    ];

    systemd = {
      tmpfiles.rules = [
        "d /media 2775 root arr -"
        "d /media/animes 2775 root arr -"
        "d /media/movies 2775 root arr -"
        "d /media/shows 2775 root arr -"
        "d /media/torrents 2775 root arr -"
        "d /media/torrents/movies 2775 root arr -"
        "d /media/torrents/shows 2775 root arr -"
      ];
    };

    users.groups.arr.members = [
      "jellyfin"
      "sonarr"
      "radarr"
      "transmission"
    ];

    services = {
      caddy.virtualHosts =
        let
          mkHost = port: {
            extraConfig = ''
              reverse_proxy http://localhost:${toString port}
            '';
          };
        in
        builtins.listToAttrs (
          map
            (name: {
              name = meta.services.${name}.domain;
              value = mkHost meta.services.${name}.port;
            })
            [
              "jellyseerr"
              "sonarr"
              "radarr"
              "prowlarr"
            ]
        );

      jellyseerr = {
        enable = true;
        inherit (meta.services.jellyseerr) port;
      };
      prowlarr = {
        enable = true;
        settings.server.port = meta.services.prowlarr.port;
      };
      flaresolverr = {
        enable = true;
        inherit (meta.services.flaresolverr) port;
      };
      sonarr = {
        enable = true;
        settings.server.port = meta.services.sonarr.port;
      };
      radarr = {
        enable = true;
        settings.server.port = meta.services.radarr.port;
      };
    };
  };
}
