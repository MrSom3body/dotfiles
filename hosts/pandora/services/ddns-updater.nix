{config, ...}: let
  cfg = config.services.ddns-updater;
in {
  imports = [
    ../../common/optional/services/ddns-updater.nix
  ];

  services.caddy.virtualHosts."ddns.sndh.dev" = {
    extraConfig = ''
      reverse_proxy http://${cfg.environment.LISTENING_ADDRESS}
      import cloudflare
    '';
  };
}
