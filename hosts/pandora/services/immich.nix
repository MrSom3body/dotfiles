{config, ...}: let
  cfg = config.services.immich;
in {
  imports = [
    ../../../system/optional/services/immich.nix
  ];

  sops.secrets.immich = {
    sopsFile = ../../../secrets/pandora/immich.env;
    format = "dotenv";
  };

  services = {
    immich = {
      secretsFile = config.sops.secrets.immich.path;
      accelerationDevices = ["/dev/dri/renderD128"];
    };

    caddy.virtualHosts = {
      "immich.sndh.dev" = {
        extraConfig = ''
          reverse_proxy http://${cfg.host}:${toString cfg.port}
          import cloudflare
        '';
      };

      "media.sndh.dev" = {
        extraConfig = ''
          reverse_proxy http://${cfg.host}:${toString cfg.port}
          tls internal
        '';
      };
    };
  };

  # from https://wiki.nixos.org/wiki/Immich#Enabling_Hardware_Accelerated_Video_Transcoding
  users.users.immich.extraGroups = ["video" "render"];
}
