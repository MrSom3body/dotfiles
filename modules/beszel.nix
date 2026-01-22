{ config, ... }:
let
  inherit (config.flake) meta;
in
{
  flake.modules.nixos.beszel = {
    services = {
      beszel.hub = {
        enable = true;
        inherit (meta.services.beszel) port;
      };

      caddy.virtualHosts = {
        ${meta.services.beszel.domain} = {
          extraConfig = ''
            reverse_proxy http://localhost:${toString meta.services.beszel.port}
            import cloudflare
          '';
        };
      };
    };
  };
}
