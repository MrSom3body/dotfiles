{config, ...}: let
  cfg = config.services.send;
in {
  imports = [
    ../../../system/optional/services/send.nix
  ];

  services.caddy.virtualHosts."send.sndh.dev" = {
    extraConfig = ''
      reverse_proxy http://${cfg.host}:${toString cfg.port}
      tls internal
    '';
  };
}
