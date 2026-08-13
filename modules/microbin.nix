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
      '';

      microbin = {
        enable = true;
        passwordFile = config.sops.secrets.microbin-env.path;
        settings =
          let
            MICROBIN_NO_LISTING = true; # removes the /list endpoint
          in
          {
            MICROBIN_BIND = "127.0.0.1";
            MICROBIN_PORT = meta.services.microbin.port;
            MICROBIN_PUBLIC_PATH = meta.services.microbin.url;

            MICROBIN_TITLE = "Karun's MicroBin";
            MICROBIN_HIDE_HEADER = false;
            MICROBIN_HIDE_FOOTER = true;

            MICROBIN_DEFAULT_EXPIRY = "1hour";
            MICROBIN_MAX_EXPIRY = "24hour";
            MICROBIN_ENABLE_BURN_AFTER = true;
            MICROBIN_DEFAULT_BURN_AFTER = 1;
            MICROBIN_GC_DAYS = 7;

            inherit MICROBIN_NO_LISTING;
            MICROBIN_HIGHLIGHTSYNTAX = true;

            MICROBIN_QR = true;

            MICROBIN_PRIVATE = !MICROBIN_NO_LISTING; # unlisted mode (can be disabled when MICROBIN_NO_LISTING is enabled)
            MICROBIN_ENABLE_READONLY = true; # protected mode
            MICROBIN_ENCRYPTION_SERVER_SIDE = true; # secret mode
            MICROBIN_ENCRYPTION_CLIENT_SIDE = true; # private mode
            MICROBIN_DEFAULT_PRIVACY = "unlisted";
          };
      };
    };
  };
}
