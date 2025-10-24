{ config, ... }:
let
  inherit (config.flake) modules;
in
{
  flake.modules.nixos.arr =
    { config, ... }:
    {
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

      my.services.glance.services =
        let
          mkSite = title: url: icon: { inherit title url icon; };
        in
        [
          (mkSite "jellyseerr" "https://jellyseerr.sndh.dev" "di:jellyseerr")
          (mkSite "sonarr" "https://sonarr.sndh.dev" "di:sonarr")
          (mkSite "radarr" "https://radarr.sndh.dev" "di:radarr")
          (mkSite "prowlarr" "https://prowlarr.sndh.dev" "di:prowlarr")
        ];

      services = {
        caddy.virtualHosts =
          let
            inherit (config.networking) domain;
            mkHost = port: {
              extraConfig = ''
                reverse_proxy http://localhost:${builtins.toString port}
                import cloudflare
              '';
            };
          in
          {
            "jellyseerr.${domain}" = mkHost config.services.jellyseerr.port;
            "prowlarr.${domain}" = mkHost config.services.prowlarr.settings.server.port;
            "sonarr.${domain}" = mkHost config.services.sonarr.settings.server.port;
            "radarr.${domain}" = mkHost config.services.radarr.settings.server.port;
          };

        jellyseerr.enable = true;
        prowlarr.enable = true;
        flaresolverr.enable = true;
        sonarr.enable = true;
        radarr.enable = true;
      };
    };
}
