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
        loadModels = [
          "gemma3:27b"
          "qwen2.5-coder:32b"
          "gpt-oss:20b"
        ];
      };

      caddy.virtualHosts = {
        ${meta.services.open-webui.domain} = {
          extraConfig = ''
            reverse_proxy http://localhost:${toString meta.services.open-webui.port}
            import cloudflare
          '';
        };
      };
    };
  };
}
