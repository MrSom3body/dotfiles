{ config, ... }:
let
  inherit (config.flake) meta;
in
{
  flake.modules.nixos.ntfy = {
    services = {
      caddy.virtualHosts."${meta.services.ntfy.domain}" = {
        extraConfig = ''
          reverse_proxy http://localhost:${toString meta.services.ntfy.port}
        '';
      };

      ntfy-sh = {
        enable = true;
        settings = {
          listen-http = "127.0.0.1:${toString meta.services.ntfy.port}";
          base-url = "https://ntfy.sndh.dev";
          behind-proxy = true;

          auth-file = "/var/lib/ntfy-sh/user.db";
          auth-default-access = "deny-all";
          auth-users = [
            "karun:$2a$10$SjFiHl/DfANiKFrlLiE9hOomGBdG2m8.yDn5ZBJFeU9GgTlzy6kbO:admin"
            "arr:$2a$10$mFqmMvBRl5Jn3Gb.0aRwyOIiaVhKA0qG3SOsDQb5Rp4zB5FPk3jJe:user"
            "beszel:$2a$10$GwpUNbfqI3iZG.nD0t8mfukzre7I4vsg9k728zfwS7NlyXK8lGR9W:user"
            "miniflux:$2a$10$T14gqSrymV6cs0Fecg5vIuMAvWPjIJySz/46WQGWl9Wx0BqXy4RW.:user"
          ];
          auth-access = [
            "arr:jellyseer:rw"
            "arr:prowlarr:rw"
            "arr:radarr:rw"
            "arr:sonarr:rw"

            "beszel:beszel:rw"

            "miniflux:miniflux:rw"
          ];

          attachment-cache-dir = "/var/lib/ntfy-sh/attachments";
          cache-file = "/var/lib/ntfy-sh/cache-file.db";
        };
      };
    };
  };
}
