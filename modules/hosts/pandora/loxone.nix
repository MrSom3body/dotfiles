{ config, ... }:
let
  inherit (config.flake) meta;
in
{
  flake.modules.nixos."hosts/pandora" = {
    services.caddy = {
      virtualHosts = {
        "${meta.services.loxone.domain}" = {
          extraConfig = ''
            reverse_proxy http://10.0.0.10
            import cloudflare
          '';
        };
      };
    };
  };
}
