{ config, ... }:
let
  cfg = config.services.karakeep;
in
{
  services = {
    caddy.virtualHosts = {
      "karakeep.sndh.dev" = {
        extraConfig = ''
          reverse_proxy ${cfg.extraEnvironment.NEXTAUTH_URL}
          import cloudflare
        '';
      };
    };

    karakeep = {
      enable = true;
      extraEnvironment = {
        NEXTAUTH_URL = "http://localhost:3000";
        DISABLE_SIGNUPS = "true";
        DISABLE_NEW_RELEASE_CHECK = "true";
      };
    };
  };
}
