{config, ...}: {
  imports = [
    ../../../system/services/arr.nix
    ../../../system/services/jellyfin.nix
  ];

  sops = {
    secrets = {
      transmission-password.sopsFile = ../../../secrets/pandora/secrets.yaml;
      sonarr-api-key.sopsFile = ../../../secrets/pandora/secrets.yaml;
      radarr-api-key.sopsFile = ../../../secrets/pandora/secrets.yaml;
    };
    templates."transmission.json" = {
      owner = "transmission";
      content =
        #json
        ''
          {
            "rpc-password": "${config.sops.placeholder.transmission-password}"
          }
        '';
    };
  };

  users.groups.arr.members = [
    "jellyfin"
  ];

  systemd = {
    tmpfiles.rules = [
      "d /media 2775 root arr -"
      "d /media/movies 2775 root arr -"
      "d /media/shows 2775 root arr -"
      "d /media/torrents 2775 root arr -"
      "d /media/torrents/movies 2775 root arr -"
      "d /media/torrents/shows 2775 root arr -"
    ];
    services.recyclarr.serviceConfig.LoadCredential = [
      "sonarr-api-key:${config.sops.secrets.sonarr-api-key.path}"
      "radarr-api-key:${config.sops.secrets.radarr-api-key.path}"
    ];
  };

  services = {
    transmission = {
      settings = {
        bind-address-ipv4 = "10.2.0.2";
        rpc-authentication-required = true;
        download-dir = "/media/torrents";
      };

      credentialsFile = config.sops.templates."transmission.json".path;
    };

    caddy.virtualHosts = let
      mkHost = port: {
        extraConfig = ''
          reverse_proxy http://localhost:${builtins.toString port}
          import cloudflare
        '';
      };
    in {
      "jellyfin.sndh.dev" = mkHost 8096;
      "jellyseerr.sndh.dev" = mkHost config.services.jellyseerr.port;
      "prowlarr.sndh.dev" = mkHost config.services.prowlarr.settings.server.port;
      "sonarr.sndh.dev" = mkHost config.services.sonarr.settings.server.port;
      "radarr.sndh.dev" = mkHost config.services.radarr.settings.server.port;
      "transmission.sndh.dev" = mkHost config.services.transmission.settings.rpc-port;
    };
  };
}
