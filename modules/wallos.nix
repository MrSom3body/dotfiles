{ config, ... }:
let
  inherit (config.flake) meta;
in
{
  flake.modules.nixos.wallos =
    { config, ... }:
    let
      inherit (config.networking) hostName;
    in
    {
      sops.secrets.wallos-oauth-secret.sopsFile = ../secrets/${hostName}/wallos.yaml;

      systemd.tmpfiles.rules = [
        "d /var/lib/wallos/db 0750 root root -"
        "d /var/lib/wallos/logos 0750 root root -"
      ];

      virtualisation.oci-containers.containers.wallos = {
        image = "ghcr.io/ellite/wallos:latest";
        ports = [ "127.0.0.1:${toString meta.services.wallos.port}:80" ];
        environment = {
          TZ = config.time.timeZone;
          OIDC_ENABLED = "true";
          OIDC_ISSUER = "${meta.services.kanidm.url}/oauth2/openid/wallos";
          OIDC_CLIENT_ID = "wallos";
          OIDC_PROVIDER_NAME = "som3sso";
          OIDC_REDIRECT_URL = "${meta.services.wallos.url}/index.php";
          OIDC_SCOPES = "openid email profile";
          OIDC_AUTO_CREATE_USER = "true";
          SSRF_ALLOWLIST = meta.services.kanidm.domain;
        };
        environmentFiles = [ config.sops.secrets.wallos-oauth-secret.path ];
        volumes = [
          "/var/lib/wallos/db:/var/www/html/db:U"
          "/var/lib/wallos/logos:/var/www/html/logos:U"
        ];
      };

      services.caddy.virtualHosts.${meta.services.wallos.domain} = {
        extraConfig = ''
          reverse_proxy http://localhost:${toString meta.services.wallos.port}
        '';
      };
    };
}
