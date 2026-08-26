{ config, ... }:
let
  inherit (config.flake) meta;
  inherit (config.flake) modules;
in
{
  flake.modules.nixos.arr =
    { config, lib, ... }:
    let
      mkArrTemplate = app: {
        content = ''
          ${lib.toUpper app}__AUTH__APIKEY="${config.sops.placeholder."${app}-api-key"}"
        '';
      };

      mkArrVirtualHost = port: {
        extraConfig = ''
          @api path /api/* /feed/* /*/api /*/download

          handle @api {
            reverse_proxy http://localhost:${toString port}
          }

          handle {
            import oauth2_routes
            import oauth2 admin.role

            reverse_proxy http://localhost:${toString port}
          }
        '';
      };

      mkArrService = app: {
        enable = true;
        settings = {
          server.port = meta.services.${app}.port;
          auth = {
            required = "Enabled";
            method = "External";
          };
        };
        environmentFiles = [ config.sops.templates."${app}.env".path ];
      };
    in
    {
      imports = [
        modules.nixos.jellyfin
        modules.nixos.transmission
      ];

      sops = {
        secrets = {
          prowlarr-api-key.sopsFile = ../../secrets/${config.networking.hostName}/arr.yaml;
          sonarr-api-key.sopsFile = ../../secrets/${config.networking.hostName}/arr.yaml;
          radarr-api-key.sopsFile = ../../secrets/${config.networking.hostName}/arr.yaml;
        };

        templates = {
          "prowlarr.env" = mkArrTemplate "prowlarr";
          "sonarr.env" = mkArrTemplate "sonarr";
          "radarr.env" = mkArrTemplate "radarr";
        };
      };

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
        "transmission"
        "sonarr"
        "radarr"
        "prowlarr"
        "bazarr"
      ];

      services = {
        caddy.virtualHosts = {
          "${meta.services.prowlarr.domain}" = mkArrVirtualHost meta.services.prowlarr.port;
          "${meta.services.sonarr.domain}" = mkArrVirtualHost meta.services.sonarr.port;
          "${meta.services.radarr.domain}" = mkArrVirtualHost meta.services.radarr.port;
          "${meta.services.bazarr.domain}" = mkArrVirtualHost meta.services.bazarr.port;
          "${meta.services.seerr.domain}" = {
            extraConfig = ''
              reverse_proxy http://localhost:${toString meta.services.seerr.port}
            '';
          };
        };

        seerr = {
          enable = true;
          inherit (meta.services.seerr) port;
        };

        bazarr = {
          enable = true;
          listenPort = meta.services.bazarr.port;
        };

        prowlarr = mkArrService "prowlarr";
        sonarr = mkArrService "sonarr";
        radarr = mkArrService "radarr";
      };
    };
}
