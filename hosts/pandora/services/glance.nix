{config, ...}: let
  cfg = config.services.glance;
in {
  imports = [
    ../../../system/optional/services/glance.nix
  ];

  services.caddy.virtualHosts."home.sndh.dev" = {
    extraConfig = ''
      reverse_proxy http://${cfg.settings.server.host}:${toString cfg.settings.server.port}
      import cloudflare
    '';
  };
}
