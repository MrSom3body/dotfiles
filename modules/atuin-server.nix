{ config, ... }:
let
  inherit (config.flake) meta;
in
{
  flake = {
    modules.nixos.atuin-server = {
      services = {
        atuin = {
          enable = true;
          inherit (meta.services.atuin) port;
          openRegistration = true;
        };

        caddy.virtualHosts = {
          ${meta.services.atuin.domain} = {
            extraConfig = ''
              reverse_proxy http://localhost:${toString meta.services.atuin.port}
            '';
          };
        };
      };
    };
  };
}
