{ config, ... }:
let
  inherit (config.flake) meta;
in
{
  flake.modules.nixos.actual = {
    services = {
      caddy.virtualHosts."${meta.services.actual.domain}" = {
        extraConfig = ''
          reverse_proxy http://localhost:${toString meta.services.actual.port}
        '';
      };

      actual = {
        enable = true;
        settings = {
          port = meta.services.actual.port;
          trustedProxies = [ "127.0.0.1" ];
        };
      };
    };
  };
}
