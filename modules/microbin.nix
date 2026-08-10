{ config, ... }:
let
  inherit (config.flake) meta;
in
{
  flake.modules.nixos.microbin = { config, ... }: {
    sops.secrets.microbin-env.sopsFile = ../secrets/${config.networking.hostName}/microbin.yaml;

    services = {
      cloudflared.tunnels.${config.networking.hostName}.ingress."${meta.services.microbin.domain}" =
        "http://localhost:${toString meta.services.microbin.port}";

      caddy.virtualHosts."${meta.services.microbin.domain}".extraConfig = ''
        reverse_proxy http://127.0.0.1:${toString meta.services.microbin.port}
        tls internal
      '';

      microbin = {
        enable = true;
        settings = {
          MICROBIN_BIND = "127.0.0.1";
          MICROBIN_PORT = meta.services.microbin.port;
          MICROBIN_PUBLIC_PATH = meta.services.microbin.url;

          MICROBIN_TITLE = "Karun's MicroBin";
          MICROBIN_HIDE_HEADER = false;
          MICROBIN_HIDE_FOOTER = true;

          MICROBIN_NO_LISTING = true;

          MICROBIN_HIGHLIGHTSYNTAX = true;
          MICROBIN_PRIVATE = true;

          MICROBIN_EDITABLE = true;
          MICROBIN_GC_DAYS = 7;

          MICROBIN_ENABLE_BURN_AFTER = true;
          MICROBIN_DEFAULT_BURN_AFTER = 10;

          MICROBIN_QR = true;

          MICROBIN_ENABLE_READONLY = true;
        };
        passwordFile = config.sops.secrets.microbin-env.path;
      };
    };
  };
}
