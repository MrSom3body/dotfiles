{config, ...}: let
  cfg = config.services.send;
in {
  services = {
    send = {
      enable = true;
      host = "127.0.0.1";
      port = 1443;
      openFirewall = true;
    };

    caddy.virtualHosts."send.sndh.dev" = {
      extraConfig = ''
        reverse_proxy http://${cfg.host}:${toString cfg.port}
        tls internal
      '';
    };
  };

  networking.firewall.allowedTCPPorts = [80 443];
}
