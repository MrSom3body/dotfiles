{ config, ... }:
let
  inherit (config.flake) meta;
in
{
  flake.modules.nixos.open-webui = {
    services = {
      open-webui = {
        enable = true;
        inherit (meta.services.open-webui) port;
      };

      ollama = {
        enable = true;
        syncModels = true;
      };

      caddy.virtualHosts = {
        ${meta.services.open-webui.domain} = {
          extraConfig = ''
            reverse_proxy http://localhost:${toString meta.services.open-webui.port}
          '';
        };
      };
    };
  };
}
