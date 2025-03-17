{config, ...}: let
  cfg = config.services.ddns-updater;
in {
  services = {
    ddns-updater = {
      enable = true;
      environment = {
        LISTENING_ADDRESS = "127.0.0.1:8000";
      };
    };

    caddy.virtualHosts."ddns.sndh.dev" = {
      extraConfig = ''
        reverse_proxy http://${cfg.environment.LISTENING_ADDRESS}
        import cloudflare
      '';
    };
  };
}
