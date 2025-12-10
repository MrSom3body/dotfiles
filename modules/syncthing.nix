{
  flake.modules = {
    nixos.syncthing =
      { config, ... }:
      {
        services.caddy.virtualHosts = {
          "syncthing.${config.networking.hostName}.${config.networking.domain}" = {
            extraConfig = ''
              reverse_proxy http://127.0.0.1:8384 {
                header_up Host {upstream_hostport}
              }
              import cloudflare
            '';
          };
        };

        networking.firewall =
          let
            ports = [
              22000
              21027
            ];
          in
          {
            allowedTCPPorts = ports;
            allowedUDPPorts = ports;
          };
      };

    homeManager.syncthing = {
      services.syncthing.enable = true;
    };
  };
}
